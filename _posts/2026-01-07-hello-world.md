---
title: MySql
description: "Apuntes de MySql"
last_modified_at: false
date: 2026-01-08 06:23:59 -500
categories: [BaseDeDatos, Mysql]
tags: [Relacional, Querys]
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
## Ejemplo practico


| user_id | name   | surname  | age | init_date  | email             |
|--------:|--------|----------|----:|------------|-------------------|
| 1       | John   | Doe      | 25  | 2026-01-08 | johndoe@gmail.com |
| 2       | Sara   | NULL     | 20  | 2023-10-12 | sara@gmail.com    |
| 3       | Carlos | Azaustro | 15  | NULL       | sara@gmail.com    |
| 4       | S4vitar| NULL     | NULL| NULL       | NULL              |
| 5       | Miriam | Gonzáles | 15  | NULL       | miriam@gmail.com  |
| 6       | Martín | Beta     | NULL| NULL       | NULL              |


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

-- Obtiene el nombre, apellido y edad de la tabla "users", y si la edad es nula la muestra como 0
SELECT name, surname, IFNULL(age, 0) AS age FROM users;
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

### Alias
```sql
-- Establece el alias 'Fecha de inicio en programación' a la columna init_date
SELECT name, init_date AS 'Fecha de inicio en programación' FROM users WHERE name = 'carlos'
```

### Concat
```sql
-- Concatena en una sola columa los campos nombre y apellido
SELECT CONCAT('Nombre: ', name, ', Apellidos: ', surname) FROM users

-- Concatena en una sola columa los campos nombre y apellido y le establece el alias 'Nombre completo'
SELECT CONCAT('Nombre: ', name, ', Apellidos: ', surname) AS 'Nombre completo' FROM users
```

### Group by
```sql
-- Agrupa los resultados por edad diferente
SELECT MAX(age) FROM users GROUP BY age

-- Agrupa los resultados por edad diferente y cuenta cuantos registros existen de cada una
SELECT COUNT(age), age FROM users GROUP BY age

-- Agrupa los resultados por edad diferente, cuenta cuantos registros existen de cada una y los ordena
SELECT COUNT(age), age FROM users GROUP BY age ORDER BY age ASC

-- Agrupa los resultados por edad diferente mayor de 15, cuenta cuantos registros existen de cada una y los ordena
SELECT COUNT(age), age FROM users WHERE age > 15 GROUP BY age ORDER BY age ASC

```

### Having
```sql
-- Cuenta cuantas filas contienen un dato no nulo en el campo edad de la tabla "users" mayor que 3
SELECT COUNT(age) FROM users HAVING COUNT(age) > 3

--- Devuelve los productos cuya suma total de cantidades vendidas es mayor a 10.
SELECT producto, SUM(cantidad) FROM ventas GROUP BY producto HAVING SUM(cantidad) > 10
```
#### Ejemplo having 

| producto | cantidad |
|----------|----------|
| A        | 5        |
| A        | 3        |
| B        | 2        |
| B        | 10       |

> - Se usa cuando necesitas poner condiciones sobre funciones de agregación. 
{: .prompt-tip }


### Case

```sql
-- Obtiene todos los datos de la tabla "users" y establece condiciones de visualización de cadenas de texto según el valor de la edad 
SELECT *,
CASE 
    WHEN age > 18 THEN 'Es mayor de edad'
    WHEN age = 18 THEN 'Acaba de cumplir la mayoría de edad'
    ELSE 'Es menor de edad'
END AS '¿Es mayor de edad?'
FROM users;

-- Obtiene todos los datos de la tabla "users" y establece condiciones de visualización de valores booleanos según el valor de la edad 
SELECT *,
CASE 
    WHEN age > 17 THEN True
    ELSE False
END AS '¿Es mayor de edad?'
FROM users;
```
#### Ejemplo case 


![Example CASE](assets/img/example.jpeg){: w="550" h="400" }

## Relaciones

![Example CASE](assets/img/Relaciones.jpg){: w="200" h="200" }

```sql
-- El campo user_id de la tabla "dni" es clave foránea de la clave primaria user_id de la tabla "users"
-- (Un usuario sólo puede tener un DNI. Un DNI sólo puede estar asociado a un usuario)
CREATE TABLE dni(
    dni_id int AUTO_INCREMENT PRIMARY KEY,
    dni_number int NOT NULL,
    user_id int,
    UNIQUE(dni_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);
```

> - Para las relaciones (1:1) -> La clave foránea va en la tabla dependiente.
{: .prompt-info }

```sql
CREATE TABLE companies(
    company_id int AUTO_INCREMENT PRIMARY KEY,
    name varchar(100) NOT NULL
);
ALTER TABLE users
ADD company_id int;

-- El campo company_id de la tabla "users" es clave foránea de la clave primaria company_id de la tabla "companies"
-- (Un empleado (usuario) sólo puede tener una empresa, pero una empresa puede tener muchos empleados (usuarios))
ALTER TABLE users 
ADD CONSTRAINT fk_companies
FOREIGN KEY(company_id) REFERENCES companies(company_id)
```

> - Para las relaciones (1:N) -> La clave foránea siempre va en el lado N (muchos).
{: .prompt-info }

```sql
CREATE TABLE languages(
    language_id int AUTO_INCREMENT PRIMARY KEY,
    name varchar(100) NOT NULL
);

-- El campo user_id y language_id de la tabla intermedia "users_languages" es clave foránea de las
-- claves primarias user_id de la tabla "users" y de language_id de la tabla "languages"
-- Un usuario puede conoces muchos lenguajes. Un lenguaje puede ser conocido por muchos usuarios.
CREATE TABLE users_languages(
    users_language_id int AUTO_INCREMENT PRIMARY KEY,
    user_id int,
    language_id int,
    FOREIGN KEY(user_id) REFERENCES users(user_id),
    FOREIGN KEY(language_id) REFERENCES languages(language_id),
    UNIQUE (user_id, language_id)
);
```

> - Para las relaciones (N:M) -> Tabla intermedia con FKs a ambas tablas.
{: .prompt-info }
