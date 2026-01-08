---
title: MySql
description: "Apuntes de MySql"
last_modified_at: false
date: 2026-01-08 06:23:59 -500
categories: [BaseDeDatos, Mysql]
tags: [Relacional, querys]
image: https://altnix.com/_next/static/media/mySQL.d519545a.png
---

MySQL es un sistema de gestión de bases de datos relacional (RDBMS) de código abierto, ampliamente utilizado para almacenar, organizar y administrar información de forma eficiente. Se basa en el lenguaje SQL (Structured Query Language), que permite crear, consultar, modificar y eliminar datos mediante sentencias llamadas queries.

## Crear una base de datos

```sql
-- Crea una base de datos llamada "test"
CREATE DATABASE test;
```

## Eliminar una base de datos

```sql
-- Elimina la base de datos llamada "test"
DROP DATABASE test;
```

## Crear una tabla

```sql
-- Crea una tabla llamada "persons" con nombre de columna (atributos) de tipo int, varchar y date
CREATE TABLE persons (
    id int,
    name varchar(100),
    age int,
    email varchar(50),
    created date
);
```

```sql
-- NOT NULL: Obliga a que el campo id posea siempre un valor no nulo
CREATE TABLE persons2 (
    id int NOT NULL,
    name varchar(100) NOT NULL,
    age int,
    email varchar(50),
    created date
);
```

```sql
-- UNIQUE: Obliga a que el campo id posea valores diferentes
CREATE TABLE persons3 (
    id int NOT NULL,
    name varchar(100) NOT NULL,
    age int,
    email varchar(50),
    created datetime,
    UNIQUE(id)
);
```

```sql
-- PRIMARY KEY: Establece el campo id como clave primaria para futuras relaciones 
-- con otras tablas
CREATE TABLE persons4 (
    id int NOT NULL,
    name varchar(100) NOT NULL,
    age int,
    email varchar(50),
    created datetime,
    UNIQUE(id),
    PRIMARY KEY(id)
);
```

```sql
-- DEFAULT: Establece un valor por defecto en el campo created correspondiente a la 
-- fecha del sistema
CREATE TABLE persons6 (
    id int NOT NULL,
    name varchar(100) NOT NULL,
    age int,
    email varchar(50),
    created datetime DEFAULT CURRENT_TIMESTAMP(),
    UNIQUE(id),
    PRIMARY KEY(id),
    CHECK(age>=18)
);
```

```sql
-- AUTO_INCREMENT: Indica que el campo id siempre se va a incrementar en 1 con cada nuevo inserto
CREATE TABLE persons7 (
    id int NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    age int,
    email varchar(50),
    created datetime DEFAULT CURRENT_TIMESTAMP(),
    UNIQUE(id),
    PRIMARY KEY(id),
    CHECK(age>=18)
);
```

## Eliminar una tabla

```sql
-- Elimina la tabla llamada "persons8"
DROP TABLE persons8;
```

## Alter table

```sql
-- ADD: Añade un nuevo atributo surname a la tabla "persons8"
ALTER TABLE persons8
ADD surname varchar(150);
```

```sql
-- RENAME COLUMN: Renombra el atributo surname a description en la tabla "persons8"
ALTER TABLE persons8
RENAME COLUMN surname TO description;
```

```sql
-- MODIFY COLUMN: Modifica el tipo de dato del atributo description en la tabla "persons8"
ALTER TABLE persons8
MODIFY COLUMN description varchar(250);
```

```sql
-- DROP COLUMN: Elimina el atributo description en la tabla "persons8"
ALTER TABLE persons8
DROP COLUMN description;
```

## Writing
### Insert

```sql
-- Inserta un registro con identificador, nombre y apellido en la tabla "users"
INSERT INTO users (user_id, name, surname) VALUES (8, 'María', 'López')

-- Inserta un registro con nombre y apellido en la tabla "users"
INSERT INTO users (name, surname) VALUES ('Paco', 'Pérez')

-- Inserta un registro con identificador no correlativo, nombre y apellido en la tabla "users"
INSERT INTO users (user_id, name, surname) VALUES (11, 'El', 'Merma')
```

### Update
```sql
-- Estable el valor 21 para la edad del registro de la tabla "users" con identificador igual a 11
UPDATE users SET age = '21' WHERE user_id = 11

-- Estable el valor 20 para la edad del registro de la tabla "users" con identificador igual a 11
UPDATE users SET age = '20' WHERE user_id = 11

-- Estable edad y una fecha para registro de la tabla "users" con identificador igual a 11
UPDATE users SET age = 20, init_date = '2020-10-12' WHERE user_id = 11
```

### Delete
```sql
-- Elimina el registro de la tabla "users" con identificador igual a 11
DELETE FROM users WHERE user_id = 11;
```


## Reading
### Select 
```sql
-- Obtiene todos los datos de la tabla "users"
SELECT * FROM users;

-- Obtiene todos los nombres de la tabla "users"
SELECT name FROM users;

-- Obtiene todos los identificadores y nombres de la tabla "users"
SELECT user_id, name FROM users;
```

### Distint

```sql
-- Obtiene todos los datos distintos entre sí de la tabla "users"
SELECT DISTINCT * FROM users;

-- Obtiene todos los valores distintos referentes al atributo edad de la tabla "users"
SELECT DISTINCT age FROM users;
```

### Where

```sql
-- Filtra todos los datos de la tabla "users" con edad igual a 15
SELECT * FROM users WHERE age = 15;

-- Filtra todos los nombres de la tabla "users" con edad igual a 15
SELECT name FROM users WHERE age = 15;

-- Filtra todos los nombres distintos de la tabla "users" con edad igual a 15
SELECT DISTINCT name FROM users WHERE age = 15;

-- Filtra todas las edades distintas de la tabla "users" con edad igual a 15
SELECT DISTINCT age FROM users WHERE age = 15;
```
### Order by
```sql
-- Ordena todos los datos de la tabla "users" por edad (ascendente por defecto)
SELECT * FROM users ORDER BY age;

-- Ordena todos los datos de la tabla "users" por edad de manera ascendente
SELECT * FROM users ORDER BY age ASC;

-- Ordena todos los datos de la tabla "users" por edad de manera descendente
SELECT * FROM users ORDER BY age DESC;

-- Obtiene todos los datos de la tabla "users" con email igual a sara@gmail.com y los ordena por edad de manera descendente
SELECT * FROM users WHERE email='sara@gmail.com' ORDER BY age DESC;

-- Obtiene todos los nombres de la tabla "users" con email igual a sara@gmail.com y los ordena por edad de manera descendente
SELECT name FROM users WHERE email='sara@gmail.com' ORDER BY age DESC;
```

### Like
```sql
-- Obtiene todos datos de la tabla "users" que contienen un email con el texto "gmail.com" en su parte final
SELECT * FROM users WHERE email LIKE '%gmail.com';

-- Obtiene todos datos de la tabla "users" que contienen un email con el texto "sara" en su parte inicial
SELECT * FROM users WHERE email LIKE 'sara%';

-- Obtiene todos datos de la tabla "users" que contienen un email una arroba
SELECT * FROM users WHERE email LIKE '%@%';
```

### NOT, AND, OR
```sql
-- Obtiene todos datos de la tabla "users" con email distinto a sara@gmail.com
SELECT * FROM users WHERE NOT email = 'sara@gmail.com';

-- Obtiene todos datos de la tabla "users" con email distinto a sara@gmail.com y edad igual a 15
SELECT * FROM users WHERE NOT email = 'sara@gmail.com' AND age = 15;

-- Obtiene todos datos de la tabla "users" con email distinto a sara@gmail.com o edad igual a 15
SELECT * FROM users WHERE NOT email = 'sara@gmail.com' OR age = 15;
```

### Limit
```sql
-- Obtiene las 3 primeras filas de la tabla "users"
SELECT * FROM users LIMIT 3;

-- Obtiene las 2 primeras filas de la tabla "users" con email distinto a sara@gmail.com o edad igual a 15
SELECT * FROM users WHERE NOT email = 'sara@gmail.com' OR age = 15 LIMIT 2;
``` 

### Null
```sql
-- Obtiene todos datos de la tabla "users" con email nulo
SELECT * FROM users WHERE email IS NULL;

-- Obtiene todos datos de la tabla "users" con email no nulo
SELECT * FROM users WHERE email IS NOT NULL;

-- Obtiene todos datos de la tabla "users" con email no nulo y edad igual a 15
SELECT * FROM users WHERE email IS NOT NULL AND age = 15;
```

### Min, Max
```sql
-- Obtiene el valor menor del campo edad de la tabla "users"
Select MIN(age) FROM users;

-- Obtiene el valor mayor del campo edad de la tabla "users"
Select MAX(age) FROM users;
```

### Count
```sql
-- Cuenta cuantas filas contiene la tabla "users"
Select COUNT(*) FROM users;

-- Cuenta cuantas filas contienen un dato no nulo en el campo edad de la tabla "users"
Select COUNT(age) FROM users;
```

### Sum
```sql
-- Suma todos los valores del campo edad de la tabla "users"
Select SUM(age) FROM users;
```

### Avg
```sql
-- Obitne la media de edad de la tabla "users"
Select AVG(age) FROM users;
```
### In

```sql
-- Ordena todos los datos de la tabla "users" con nombre igual a carlos y sara
SELECT * FROM users WHERE name IN ('carlos', 'sara')
```

### Between

```sql
-- Ordena todos los datos de la tabla "users" con edad comprendida entre 20 y 30
SELECT * FROM users WHERE age BETWEEN 20 AND 30
```

