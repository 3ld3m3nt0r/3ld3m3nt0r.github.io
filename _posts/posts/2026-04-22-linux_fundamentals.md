---
pin: true
layout: post
title: Linux Fundamentals
description: "Modulo de HTB Academy | Tier 0"
last_modified_at: false
date: 2026-01-11 06:23:59 -500
categories: [Modulos-HTB]
tags: [Modulos, Linux Fundamentals]
home_image: banner
banner:
  path: /assets/posts/linux_fundamentals.png
  alt: "Linux Fundamentals"
---

## Sección 1: Estructura de Linux

Linux es un sistema operativo, al igual que Windows o macOS, cuya función principal es administrar los recursos del hardware y permitir que el software funcione correctamente. Sin embargo, lo que hace especial a Linux es que es libre y de código abierto, lo que significa que cualquiera puede estudiarlo, modificarlo y distribuirlo.

En el mundo de la ciberseguridad, Linux es fundamental porque es seguro, estable y altamente configurable, lo que lo convierte en la base de muchas herramientas de hacking ético y análisis de sistemas.

### Historia de Linux

Linux tiene sus raíces en Unix (creado en 1970). Luego, en 1983, Richard Stallman inició el proyecto GNU con la idea de crear un sistema libre. Finalmente, en 1991, Linus Torvalds desarrolló el núcleo de Linux, que con el tiempo se convirtió en la base de cientos de sistemas operativos.

Hoy en día existen más de 600 distribuciones (distros) como Ubuntu, Debian o Parrot OS (muy usado en ciberseguridad).

### Filosofía de Linux

| Principio | Descripción |
|----------|------------|
| Everything is a file | Todos los recursos del sistema se representan como archivos |
| Programas simples | Cada programa cumple una función específica |
| Encadenamiento | Se pueden combinar programas para tareas complejas |
| Uso de terminal | Mayor control mediante línea de comandos |
| Configuración en texto | Archivos configurables en texto plano |

### Componentes de Linux

| Componente | Descripción |
|-----------|------------|
| Bootloader | Es el primer programa que se ejecuta al encender la computadora. Se encarga de iniciar el sistema operativo cargando el kernel en la memoria. Ejemplo: GRUB, que permite incluso elegir entre varios sistemas instalados. |
| Kernel | Es el núcleo del sistema operativo. Gestiona directamente el hardware como la CPU, la memoria y los dispositivos de entrada/salida. Además, controla los procesos, asigna recursos y asegura que todo funcione de manera eficiente y sin conflictos. |
| Daemons | Son procesos que se ejecutan en segundo plano sin interacción directa del usuario. Se encargan de tareas esenciales como la red, impresión, servicios web o ejecución de tareas programadas. |
| Shell | Es la interfaz entre el usuario y el sistema operativo. Permite introducir comandos para ejecutar tareas. Existen diferentes shells como Bash, Zsh o Fish, cada uno con características propias. |
| Graphics Server | Proporciona el sistema gráfico que permite mostrar ventanas e interfaces visuales. El más común es el servidor X (X11) o Wayland, que gestionan la comunicación entre el hardware gráfico y las aplicaciones. |
| Window Manager | Se encarga de la apariencia y organización de las ventanas en la pantalla. Controla cómo se abren, cierran y distribuyen las aplicaciones. Ejemplos: GNOME, KDE, XFCE. |
| Utilities | Son programas y herramientas que permiten al usuario realizar tareas específicas como editar archivos, gestionar procesos, navegar por el sistema o administrar recursos. Incluyen comandos básicos y aplicaciones del sistema. |

### Jerarquía del sistema de archivos

![alt text](assets/img/seccion3.1.png){: w="750" h="750" }


| Ruta | Descripción |
|------|------------|
| / | Es la raíz del sistema. Desde aquí se organiza todo el sistema operativo |
| /bin | Contiene comandos esenciales que el sistema necesita para funcionar |
| /boot | Incluye archivos necesarios para el arranque del sistema |
| /dev | Representa los dispositivos de hardware como archivos |
| /etc | Almacena archivos de configuración del sistema |
| /home | Contiene los archivos personales de cada usuario |
| /lib | Incluye librerías necesarias para el funcionamiento del sistema |
| /media | Punto de montaje para dispositivos externos como USB |
| /mnt | Usado para montajes temporales |
| /opt | Software adicional o de terceros |
| /root | Carpeta personal del usuario administrador |
| /sbin | Comandos administrativos del sistema |
| /tmp | Archivos temporales que pueden eliminarse automáticamente |
| /usr | Programas, librerías y documentación |
| /var | Archivos variables como logs y datos en uso |

## Sección 2: Distribuciones de Linux

Las distribuciones de Linux, también conocidas como distros, son sistemas operativos basados en el núcleo Linux. Cada una representa una versión adaptada del sistema, diseñada para cubrir diferentes necesidades, como uso personal, servidores, ciberseguridad o entornos empresariales.

Se pueden entender como variantes de un mismo sistema base, donde todas comparten el kernel, pero difieren en herramientas, interfaz, paquetes y configuración. 


### Características generales de las distribuciones

- Basadas en el mismo núcleo Linux  
- Diferencias en paquetes de software y herramientas  
- Interfaces adaptadas a distintos usuarios  
- Configuraciones específicas según el uso  
- Alto nivel de personalización  

### Ejemplos de distribuciones populares

| Distribución | Uso principal |
|-------------|-------------|
| Ubuntu | Escritorio, usuarios principiantes |
| Fedora | Innovación y desarrollo |
| Debian | Servidores, estabilidad |
| Red Hat Enterprise Linux | Entornos empresariales |
| CentOS | Servidores empresariales |

### Diferencias entre distribuciones

Las principales diferencias entre distros se basan en:

| Aspecto | Descripción |
|--------|------------|
| Paquetes | Software incluido por defecto |
| Interfaz | Entorno gráfico o experiencia de usuario |
| Herramientas | Aplicaciones específicas según el propósito |
| Uso | Escritorio, servidor, seguridad, etc. |

## Sección 3: Introducción a Shell

Una terminal Linux, también llamada shelllínea de comandos, proporciona una interfaz de entrada/salida (E/S) basada en texto entre los usuarios y el núcleo del sistema informático. En la ventana de la terminal, se pueden ejecutar comandos para controlar el sistema.

### Emuladores de terminal

Un emulador de terminal es un software que permite utilizar una terminal dentro de una interfaz gráfica. Su función es simular una terminal real, facilitando el uso de comandos en entornos visuales. 

### CLI

La CLI es la interfaz de línea de comandos que permite interactuar con el sistema mediante texto. Puede ejecutarse en varias instancias dentro de una misma terminal.

![alt text](assets/img/seccion3.3.png){: w="750" h="750" } 

### Tipos de shell en Linux

| Shell | Descripción |
|------|------------|
| Bash | Shell más utilizado, parte del proyecto GNU |
| Zsh | Más avanzada y personalizable |
| Ksh | Usada en entornos empresariales |
| Tcsh/Csh | Variante del shell C |
| Fish | Shell moderna y amigable |



### Sección 4: Indicador de Bash (Prompt)

El prompt es la línea que aparece en la terminal indicando que el sistema está listo para recibir comandos. Muestra información básica como el usuario, el equipo y el directorio actual.

Formato típico:
```shell
<usuario>@<host>[directorio]$
```

> El prompt permite saber en todo momento quién eres, dónde estás y con qué permisos trabajas dentro del sistema.
{: .prompt-info }

---

## Variable PS1

La apariencia del prompt se controla con la variable PS1, que permite personalizar la información mostrada.

### Caracteres especiales en PS1

| Símbolo | Descripción |
|--------|------------|
| \u | Usuario actual |
| \h | Nombre del host |
| \w | Directorio actual |
| \d | Fecha |
| \t | Hora (24h) |
| \T | Hora (12h) |
| \@ | Hora actual |
| \n | Nueva línea |
| \s | Nombre del shell |

---

## Registro de comandos

Linux guarda el historial en:
`.bash_history` 

## Sección: Obtener ayuda en Linux

Cuando trabajamos en la terminal de Linux es normal encontrar comandos desconocidos o no recordar sus opciones. Por ello, el sistema proporciona herramientas integradas que permiten obtener ayuda de forma rápida y directa desde la consola.

> En Linux no es necesario memorizar todo, lo importante es saber cómo obtener ayuda cuando la necesitas.
{: .prompt-info }

Las principales formas de obtener ayuda son:

| Comando | Uso |
|--------|-----|
| man | Muestra el manual completo de un comando |
| --help | Muestra ayuda rápida con opciones |
| -h | Versión corta de ayuda |
| apropos | Busca comandos por palabra clave |

Algunos ejemplos básicos:

- man ls  
- ls --help  
- curl -h  
- apropos sudo  

El comando `ls` se utiliza para listar archivos y directorios dentro de una carpeta, permitiendo visualizar el contenido del sistema y gestionarlo de forma más eficiente.

> Falta completar


