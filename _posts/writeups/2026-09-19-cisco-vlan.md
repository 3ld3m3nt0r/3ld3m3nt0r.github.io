---
layout: post
title: Cisco packet trace (VLAN)
description: Configuración de VLANs 
last_modified_at: false
date: 2026-01-11 06:23:59 -500
categories: [Cisco Packet Trace]
tags: [Cisco]
home_image: logo
logo:
  path: /assets/writeups/Cisco-Packet-Tracer-CPT.png
  alt: "Cisco"
---

## Escenario

![alt text](/assets/writeups/cisco1.png)

## Configurar VLANs (10, 20, 30)

```
Switch>enable
Switch#conf t
Switch(config)#hostname SW1
SW1(config)#
```

```
SW1(config)#vlan 10
SW1(config-vlan)#vlan 20
SW1(config-vlan)#vlan 30
SW1(config-vlan)#exit
SW1(config)#end
SW1#
```

> Lo mismo para SW2 y SW3
{: .prompt-tip }

```
SW1#show vlan brief
```

![alt text](/assets/writeups/cisco2.png){: w="600" h="600" }

```
SW1#conf t
SW1(config)#interface f0/1
SW1(config-if)#switchport mode access
SW1(config-if)#switchport access vlan 10

SW1(config)#interface f0/5
SW1(config-if)#switchport mode access
SW1(config-if)#switchport access vlan 20

SW1(config)#interface f0/10
SW1(config-if)#switchport mode access
SW1(config-if)#switchport access vlan 30

SW1(config-if)#exit
SW1(config)#end
SW1#
```

```
SW1#show vlan brief
```

![alt text](/assets/writeups/cisco3.png){: w="600" h="600" }

> Lo mismo para SW3
{: .prompt-tip }

## Configurar VLAN administrativa

```
SW1#conf t
SW1(config)#vlan 99
SW1(config-vlan)#name administrativa
SW1(config-vlan)#end
SW1#
```

```
SW1#conf t
SW1(config)#interface vlan 99
SW1(config-if)#ip address 172.16.99.1 255.255.255.0
SW1(config-if)#no shutdown
SW1(config-if)#exit
SW1#
```

![alt text](/assets/writeups/cisco4.png){: w="600" h="600" }

> Lo mismo para SW2 y SW3
{: .prompt-tip }

## Configurar enlace Inter VLAN

```
SW1#conf t
SW1(config)#interface g0/1
SW1(config-if)#switchport mode trunk
SW1(config-if)#switchport trunk native vlan 99
SW1(config-if)#end
SW1#
```

```
SW1#show interface trunk
```

![alt text](/assets/writeups/cisco5.png){: w="600" h="600" }

En SW2: 

![alt text](/assets/writeups/cisco6.png){: w="600" h="600" }  

```
SW2#conf t
SW2(config)#interface g0/1
SW2(config-if)#switchport mode trunk
SW2(config-if)#switchport trunk native vlan 99
SW2(config-if)#end
SW2#
```

```
SW2#show interface trunk
```

![alt text](/assets/writeups/cisco7.png){: w="600" h="600" }  

> Lo mismo desde el SW2 y SW3
{: .prompt-tip }

## Configurar Ruteo de VLAN  

```
SW2#conf t
SW2(config)#interface f0/24
SW2(config-if)#switchport mode trunk
SW2(config-if)#switchport trunk native vlan 99
SW2(config-if)#end
SW2#
```

![alt text](/assets/writeups/cisco8.png){: w="600" h="600" }  

> El puerto debe estar encendido
{: .prompt-info }

```
Router#conf t
Router(config)#hostname R1
R1(config)#end
R1#

R1#conf t
R1(config)#interface g0/0.10
R1(config-subif)#encapsulation dot1q 10
R1(config-subif)#ip address 172.16.10.1 255.255.255.0
R1(config-subif)#exit

R1(config)#interface g0/0.20
R1(config-subif)#encapsulation dot1q 20
R1(config-subif)#ip address 172.16.20.1 255.255.255.0
R1(config-subif)#exit

R1(config)#interface g0/0.30
R1(config-subif)#encapsulation dot1q 30
R1(config-subif)#ip address 172.16.30.1 255.255.255.0
R1(config-subif)#exit

R1(config)#interface g0/0.99
R1(config-subif)#encapsulation dot1q 99 native
R1(config-subif)#ip address 172.16.99.1 255.255.255.0 | (Posible error, seria: 172.16.99.4 o en SW1)
R1(config-subif)#exit
```

> Esa IP (172.16.99.1 o la corregida 172.16.99.4) en la subinterfaz g0/0.99 de R1 actúa como el default gateway para todos los dispositivos que estén en la VLAN 99.
{: .prompt-warning }

```
R1(config)#interface g0/0
R1(config-subif)#no shutdown
```

Verificar:

![alt text](/assets/writeups/cisco9.png){: w="600" h="600" }  

![alt text](/assets/writeups/cisco10.png){: w="600" h="600" }  

## Configurar default gateway

```
SWX>enable
SWX#conf t
SWX(config)#ip default-gateway 172.16.99.1
```

> Lo mismo para SW2 y SW3
{: .prompt-tip }

FIN...
