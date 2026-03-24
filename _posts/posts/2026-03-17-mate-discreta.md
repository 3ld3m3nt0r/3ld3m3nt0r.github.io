---
title: "Matemática Discreta"
description: "Apuntes de matemática discreta UPC"
tags: []
categories: []
math: true
home_image: banner
banner:
  path: /assets/posts/mate-discr.png
  alt: mate-discr
---

## Transformaciones lineales

### Problema

Determine si la transformación siguiente es lineal:

$$
T: \mathbb{R}^2 \to \mathbb{R}^2
$$

$$
T
\begin{pmatrix}
x\\
y
\end{pmatrix}
=
\begin{pmatrix}
x+y\\
x-y
\end{pmatrix}
$$

---

### Definición

Sea $T$ una aplicación de $\mathbb{R}^n$ en $\mathbb{R}^m$.

Se llama **Transformación Lineal** si se cumple:

$$
T(u+v)=T(u)+T(v)
$$

$$
T(\lambda u)=\lambda T(u)
$$

---

### Solución

Se tiene:

$$
T
\begin{pmatrix}
x\\
y
\end{pmatrix}
=
\begin{pmatrix}
x+y\\
x-y
\end{pmatrix}
$$

Sean:

$$
u=
\begin{pmatrix}
x_1\\
y_1
\end{pmatrix},
\qquad
v=
\begin{pmatrix}
x_2\\
y_2
\end{pmatrix}
$$

#### 1. Verificación de aditividad

$$
T(u+v)
=
T
\begin{pmatrix}
x_1+x_2\\
y_1+y_2
\end{pmatrix}
=
\begin{pmatrix}
(x_1+x_2)+(y_1+y_2)\\
(x_1+x_2)-(y_1+y_2)
\end{pmatrix}
$$

$$
\begin{pmatrix}
x_1 + y_1 \\
x_1 - y_1
\end{pmatrix}
+
\begin{pmatrix}
x_2 + y_2 \\
x_2 - y_2
\end{pmatrix}
=
T(u) + T(v)
$$

#### 2. Verificación de homogeneidad

$$
T(\lambda u)
=
T
\begin{pmatrix}
\lambda x_1\\
\lambda y_1
\end{pmatrix}
=
\begin{pmatrix}
\lambda x_1 + \lambda y_1\\
\lambda x_1 - \lambda y_1
\end{pmatrix}
$$

$$
\lambda
\begin{pmatrix}
x_1 + y_1\\
x_1 - y_1
\end{pmatrix}
=
\lambda T(u)
$$

---

### Conclusión

$$
T(u+v)=T(u)+T(v)
$$

$$
T(\lambda u)=\lambda T(u)
$$

Por lo tanto, **la transformación es lineal**.


## Autovalores y autovectores

### Problema

Determine los valores y vectores propios de la matriz:

$$
A =
\begin{pmatrix}
2 & 1 & -1 \\
1 & 1 & 0 \\
1 & 0 & 1
\end{pmatrix}
$$

---

### Solución

Determinamos los valores propios mediante el polinomio característico:

$$
p(\lambda) = |A - \lambda I| = 0
$$

$$
p(\lambda)=
\left|
\begin{pmatrix}
2 & 1 & -1 \\
1 & 1 & 0 \\
1 & 0 & 1
\end{pmatrix}
-
\lambda
\begin{pmatrix}
1 & 0 & 0 \\
0 & 1 & 0 \\
0 & 0 & 1
\end{pmatrix}
\right|
=0
$$

$$
p(\lambda)=
\left|
\begin{pmatrix}
2-\lambda & 1 & -1 \\
1 & 1-\lambda & 0 \\
1 & 0 & 1-\lambda
\end{pmatrix}
\right|
=0
$$

Desarrollando el determinante:

$$
p(\lambda)
=
(2-\lambda)(1-\lambda)(1-\lambda)-0
$$

$$
p(\lambda)
=
(2-\lambda)(1-\lambda)^2
$$

Igualando a cero:

$$
(2-\lambda)(1-\lambda)^2=0
$$

Por lo tanto, los valores propios son:

$$
\lambda_1=2, \qquad \lambda_2=1
$$

donde $\lambda=1$ tiene multiplicidad algebraica 2.

### Vectores propios

Ahora determinamos los vectores propios asociados a cada valor propio.

#### 1. Para $\lambda = 2$

Resolvemos:

$$
(A-2I)\mathbf{x}=0
$$

$$
\begin{pmatrix}
2 & 1 & -1 \\
1 & 1 & 0 \\
1 & 0 & 1
\end{pmatrix}
-
2
\begin{pmatrix}
1 & 0 & 0 \\
0 & 1 & 0 \\
0 & 0 & 1
\end{pmatrix}
=
\begin{pmatrix}
0 & 1 & -1 \\
1 & -1 & 0 \\
1 & 0 & -1
\end{pmatrix}
$$

Entonces:

$$
\begin{pmatrix}
0 & 1 & -1 \\
1 & -1 & 0 \\
1 & 0 & -1
\end{pmatrix}
\begin{pmatrix}
x \\
y \\
z
\end{pmatrix}
=
\begin{pmatrix}
0 \\
0 \\
0
\end{pmatrix}
$$

Lo que produce el sistema:

$$
y-z=0
$$

$$
x-y=0
$$

$$
x-z=0
$$

De aquí se obtiene:

$$
x=y=z
$$

Tomando $x=t$, resulta:

$$
\mathbf{x}=t
\begin{pmatrix}
1 \\
1 \\
1
\end{pmatrix}
$$

Por lo tanto, un vector propio asociado a $\lambda=2$ es:

$$
\begin{pmatrix}
1 \\
1 \\
1
\end{pmatrix}
$$

---

#### 2. Para $\lambda = 1$

Resolvemos:

$$
(A-I)\mathbf{x}=0
$$

$$
\begin{pmatrix}
2 & 1 & -1 \\
1 & 1 & 0 \\
1 & 0 & 1
\end{pmatrix}
-
\begin{pmatrix}
1 & 0 & 0 \\
0 & 1 & 0 \\
0 & 0 & 1
\end{pmatrix}
=
\begin{pmatrix}
1 & 1 & -1 \\
1 & 0 & 0 \\
1 & 0 & 0
\end{pmatrix}
$$

Entonces:

$$
\begin{pmatrix}
1 & 1 & -1 \\
1 & 0 & 0 \\
1 & 0 & 0
\end{pmatrix}
\begin{pmatrix}
x \\
y \\
z
\end{pmatrix}
=
\begin{pmatrix}
0 \\
0 \\
0
\end{pmatrix}
$$

Lo que produce el sistema:

$$
x+y-z=0
$$

$$
x=0
$$

Sustituyendo $x=0$ en la primera ecuación:

$$
y-z=0
$$

Entonces:

$$
y=z
$$

Tomando $y=t$, resulta:

$$
\mathbf{x}=t
\begin{pmatrix}
0 \\
1 \\
1
\end{pmatrix}
$$

Por lo tanto, un vector propio asociado a $\lambda=1$ es:

$$
\begin{pmatrix}
0 \\
1 \\
1
\end{pmatrix}
$$

---

### Conclusión

Los vectores propios de la matriz son:

- Para $\lambda=2$:

$$
\mathbf{v}_1=
\begin{pmatrix}
1 \\
1 \\
1
\end{pmatrix}
$$

- Para $\lambda=1$:

$$
\mathbf{v}_2=
\begin{pmatrix}
0 \\
1 \\
1
\end{pmatrix}
$$

Cualquier múltiplo escalar de estos vectores también es un vector propio.


## Cadenas de Markov

### Problema

En un pueblo, al 90% de los días soleados le siguen días soleados, y al 80% de los días nublados le siguen días nublados.

Con esta información, modelar el clima del pueblo como una cadena de Markov.

---

### Solución

Definimos los estados:

- $S$: Soleado  
- $N$: Nublado  

---

### Matriz de transición

Las probabilidades son:

- $P(S \to S) = 0.90$
- $P(S \to N) = 0.10$
- $P(N \to S) = 0.20$
- $P(N \to N) = 0.80$

---

### Matriz estocástica

$$
A =
\begin{pmatrix}
0.90 & 0.20 \\
0.10 & 0.80
\end{pmatrix}
$$

---

### Interpretación

- Las columnas representan el **estado inicial**
- Las filas representan el **estado final**

---

### Propiedades

Una matriz estocástica cumple:

- Todos sus elementos son $\geq 0$
- La suma de cada columna es igual a 1

$$
0.90 + 0.10 = 1
$$

$$
0.20 + 0.80 = 1
$$

---

### Conclusión

El clima del pueblo se puede modelar mediante la siguiente matriz de transición:

$$
A =
\begin{pmatrix}
0.90 & 0.20 \\
0.10 & 0.80
\end{pmatrix}
$$

