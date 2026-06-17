---
pin: true
layout: post
title: Wordpress
description: "Modulo de HTB Academy | Tier 2"
last_modified_at: false
date: 2026-01-11 06:23:59 -500
categories: [Modulos-HTB]
tags: [Modulos, Wordpress]
home_image: banner
banner:
  path: https://academy.hackthebox.com/storage/modules/17/logo.png
  alt: "Wordpress"
---

## CMS

Un CMS es una herramienta poderosa que ayuda a crear un sitio web sin necesidad de programarlo todo desde cero (ni siquiera saber programar). 

## Estructura de archivos predeterminada de WordPress

Ubicación: `/var/www/html`

LAMP: L (Linux) A (Apache) M (MySQL) P (PHP / Perl / Python)

Estructura de archivos: 

```shell
ELDEMENTOR@htb[/htb]$ tree -L 1 /var/www/html
.
├── index.php
├── license.txt
├── readme.html
├── wp-activate.php
├── wp-admin
├── wp-blog-header.php
├── wp-comments-post.php
├── wp-config.php
├── wp-config-sample.php
├── wp-content
├── wp-cron.php
├── wp-includes
├── wp-links-opml.php
├── wp-load.php
├── wp-login.php
├── wp-mail.php
├── wp-settings.php
├── wp-signup.php
├── wp-trackback.php
└── xmlrpc.php
```

`wp-admin`:  La carpeta contiene la página de inicio de sesión para el acceso de administrador y el panel de control del backend. Una vez que un usuario ha iniciado sesión, puede realizar cambios en el sitio según sus permisos asignados. La página de inicio de sesión se encuentra en una de las siguientes rutas:

```php
/wp-admin/login.php
/wp-admin/wp-login.php
/login.php
/wp-login.php
```

`xmlrpc.php`: Es un archivo que representa una función de WordPress que permite la transmisión de datos mediante HTTP como mecanismo de transporte y XML como mecanismo de codificación. Este tipo de comunicación ha sido reemplazado por la API REST de WordPress .

### Archivo de configuración de WordPress

wp-config.php: 

```php
<?php
/** <SNIP> */
/** The name of the database for WordPress */
define( 'DB_NAME', 'database_name_here' );

/** MySQL database username */
define( 'DB_USER', 'username_here' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password_here' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Authentication Unique Keys and Salts */
/* <SNIP> */
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );

/** WordPress Database Table prefix */
$table_prefix = 'wp_';

/** For developers: WordPress debugging mode. */
/** <SNIP> */
define( 'WP_DEBUG', false );

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
```