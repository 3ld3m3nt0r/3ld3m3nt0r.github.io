---
layout: post
title: Base de datos
last_modified_at: false
date: 2026-01-11 06:23:59 -500
categories: [Curso-UPC]
tags: [Base de datos, UPC]
---

## Semana 14.1: Mongodb

### Creación de la colección con validación (js Schema)

```js
db.createCollection("courses", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            require: ["title", "category", "duration", "active"],
            properties: {
                title: {
                    bsonType: "string", 
                    description: "Titulo del curso"
                },
                category: {
                    bsonType: "string",
                    descripcion: "Categoria del curso"
                },
                duration: {
                    bsonType: "int",
                    minimum: 1,
                    descripcion: "Duracion del curso en horas"
                },
                active: {
                    bsonType: "bool",
                    descripcion: "Indica si el curso está disponible"
                }
            }
        }
    }
})
```
### Inserción de documentos

```js
db.courses.insertMany([
  {
    title: "Introduction to Databases",
    category: "Database",
    duration: 20,
    active: true
  },
  {
    title: "MongoDB Fundamentals",
    category: "Database",
    duration: 15,
    active: true
  },
  {
    title: "Advanced SQL Queries",
    category: "Database",
    duration: 18,
    active: true
  },
  {
    title: "Web Development Basics",
    category: "Web Development",
    duration: 22,
    active: true
  },
  {
    title: "JavaScript Essentials",
    category: "Programming",
    duration: 16,
    active: true
  },
  {
    title: "Python for Data Analysis",
    category: "Data Science",
    duration: 24,
    active: true
  },
  {
    title: "Introduction to Machine Learning",
    category: "Data Science",
    duration: 30,
    active: true
  }
]);
```
### Actualización de un documento

```js
.updateOne({filter},{update})
```

```js
db.courses.updateOne(
    { title: "MongoDB Fundamentals" },
    { $set: {duracion: 16} }
)
```
### Actualización de varios documentos

```js
db.courses.updateMany(
    { category: "Database" },
    { $set: {level: "Intermediate"} }
)
```

### Eliminación de un documento

```js
db.courses.deleteOne( { filtro } ) 
```

```js
db.courses.deleteOne( 
    { title: "Web Development Basics" } 
) 
```
### Eliminación de varios documentos

```js
db.courses.deleteMany( 
    { duration: { $lt: 18 } }
) 
```

### Ejercicios

#### Ejercicio 1

Registra un nuevo curso en la colección correspondiente a `Data Visualization with Python`, perteneciente a la categoría 
`Data Science`, con una `duración` de 20 horas y `disponible` para los estudiantes.

```js
db.courses.insertOne({ 
  title: "Data Visualization with Python",
  category: "Data Science",
  duration: 20,
  active: true
})
```
#### Ejercicio 2

Agrega dos nuevos cursos a la plataforma: 
- `Node.js Fundamentals`, perteneciente a la `categoría` Programming, con una `duración` de 18 horas. 
- `Machine Learning Basics`, perteneciente a la `categoría` Data Science, con una `duración` de 25 horas. 

Ambos cursos deben registrarse como `disponibles`.

```js
db.courses.insertMany([
  {
    title: "Node.js Fundamentals",
    category: "Programming",
    duration: 18,
    active: true
  },
  {
    title: "Machine Learning Basics",
    category: "Data Science",
    duration: 25,
    active: true
  }
])
```

#### Ejercicio 3

El curso MongoDB Fundamentals ha sido actualizado y ahora su duración será de 18 horas. Realiza la operación correspondiente para reflejar este cambio en la colección.

```js
db.courses.updateOne(
    { title: "MongoDB Fundamentals" },
    { $set: {duracion: 18} }
)
```
#### Ejercicio 4

La plataforma ha decidido clasificar todos los cursos de la categoría `Database` como cursos de nivel intermedio.
Actualiza los documentos correspondientes agregando el campo level con el valor `Intermediate`.

```js
db.courses.updateMany(
    { category: "Database" },
    { $set: {level: "Intermediate"} }
)
```

> - Si el campo level no existe, MongoDB lo crea automáticamente al usar $set.
{: .prompt-tip }

#### Ejercicio 5

El curso `Advanced SQL Queries` ya no será ofrecido en la plataforma. 
Elimina el documento correspondiente de la colección.

```js
db.courses.deleteOne( 
    { title: "Advanced SQL Queries" } 
) 
```
#### Ejercicio 6

Debido a una reorganización del catálogo, la plataforma eliminará todos los cursos cuya duración sea `menor a 18 horas`. 
Realiza la operación correspondiente para eliminar dichos documentos

```js
db.courses.deleteMany( 
    { duration: { $lt: 18 } }
) 
```

## Semana 14.2: Mongodb

### Operadores de comparación 

| Operador | Descripción |
|----------|-------------|
| `$eq` | Igual |
| `$ne` | Diferente |
| `$gt` | Mayor que |
| `$gte` | Mayor o igual que |
| `$lt` | Menor que |
| `$lte` | Menor o igual que |
| `$in` | Está dentro de un conjunto de valores |
| `$nin` | No está dentro de un conjunto de valores |

Ejemplo: 

```js
db.students.find({ age: { $gt: 20 } }) 
```

### Operadores lógicos

| Operador | Descripción |
|----------|-------------|
| `$and` | Todas las condiciones deben cumplirse. |
| `$or` | Al menos una condición debe cumplirse. |
| `$not` | Niega una condición. |
| `$nor` | Ninguna condición debe cumplirse. |

Ejemplo: 

```js
db.students.find({ 
  $and: [ 
  { age: { $gte: 20 } }, 
  { gpa: { $gte: 15 } } 
  ] 
})
```
### Busqueda de un documento

```js
.find({query}, {projection})
.find({}, { field: 1 }) // O { field: 0 } (para excluir campo)
```

Ejemplo:

```js
db.students.find({}, { name: 1, age: 1 })
```
Resultado:

```js
{
  "_id": ObjectId("65f123abc123"),
  "name": "Ana Torres",
  "age": 21
}
```

Excluir campo:

```js
db.students.find({}, { name: 1, _id: 0 })
```

Resultado:

```js
{  
  "name": "Ana Torres"  
}
```

### Ordenamiento de resultados

```js
db.collection.find().sort({ field: 1 }) // 1 = ascendente & -1 = descendente 
```

Ejemplo:

```js
db.students.find().sort({ age: -1 }) 
```

### Limitacion de resultado

```js
db.students.find().limit(5) 
```

### Omitir documentos

```js
db.students.find().skip(5) 
```

### Conteo de documentos

```js
db.students.countDocuments() 
```

Con filtro:

```js
db.students.countDocuments({ age: 21 }) 
```

### Consulta de un solo documento

```js
db.students.findOne({ name: "Ana Torres" }) 
```

### Operadores sobre arrays

Ejemplo: 

```js
{ 
  "name": "Luis", 
  "skills": ["Java", "MongoDB", "Python"] 
} 
```

Consulta: 
```js
db.students.find({ skills: "MongoDB" }) 
```

### Operaciones avanzadas

#### PROCESAMIENTO DE DATOS CON AGGREGATION FRAMEWORK 

El Aggregation Framework es un mecanismo avanzado de MongoDB que `permite procesar y transformar documentos` mediante una secuencia de etapas denominada pipeline. Cada etapa realiza una operación específica, como `filtrar`, `agrupar`, `ordenar` o `transformar` los datos, permitiendo realizar análisis complejos directamente dentro de la base de datos (MongoDB Inc., s.f.-a). 

```js
db.collection.aggregate([  
  { stage1 }, // etapa 1
  { stage2 }  // etapa 2
])
```

> Cada etapa del pipeline recibe los documentos procesados por la etapa anterior.
{: .prompt-info }

#### ETAPAS PRINCIPALES DEL PIPELINE 

El pipeline de agregación está compuesto por diferentes etapas, cada una representada mediante un operador específico 
procedido por el simbolo `$`. Estas etapas permiten construir procesos progresivos de transformación de datos  (MongoDB Inc., s.f.-b). 

`$match:` Filtra documentos

```js
db.students.aggregate([ 
  { $match: { age: { $gte: 21 } } } 
]) 
```
`$project:` Selecciona campos específicos

```js
db.students.aggregate([ 
  { 
    $project: { 
      name: 1, 
      age: 1 
    } 
  } 
])
```

`$group:` Agrupa documentos

```js
db.students.aggregate([ 
  { 
    $group: { 
      _id: "$career", //carrera 
      total: { $sum: 1 } 
    } 
  } 
]) 
```
Resultado:

```js
{
  _id: "Software Engineering",
  total: 10
}
```

`$sort`: Ordena resultados

```js
db.students.aggregate([ 
  { $sort: { age: -1 } } 
]) 
```

`limit`: Limita resultados

```js
db.students.aggregate([ 
  { $limit: 5 } 
]) 
```

#### EJEMPLO PRACTICO

```json
db.students.aggregate([
  {
    $match: { gpa: { $gte: 15 } }
  },
  {
    $group: { _id: "$career", averageGpa: { $avg: "$gpa" } }
  },
  {
    $sort: { averageGpa: -1 }
  }
])
```

### Ejercicios

#### Ejercicio 1

Recupera todos los documentos almacenados en la colección courses.

```js
db.courses.find()
```

#### Ejercicio 2

Obtén los cursos que actualmente se encuentran disponibles en la plataforma.

```js
db.courses.find({ active: true });
```

#### Ejercicio 3:

Consulta los cursos cuya duración sea mayor a 18 horas y menor a 25 horas.

```js
db.courses.find({ 
  duration: { $gt: 18, $lt: 25 } 
});
```

#### Ejercicio 4:

Obtén los cursos que pertenecen a la categoría `Data Science` y cuya duración sea mayor a 20 horas.


