---
layout: post
title: Fundamentos en ciberseguridad
last_modified_at: false
date: 2026-01-11 06:23:59 -500
categories: [Curso-UPC]
tags: [Fundamentos, UPC]
---


## Semana 14: Mejores practicas en ciberseguridad

### Indice:

- Qué son los `estándares de ciberseguridad` y por qué son necesarios.
- Cómo funciona la `familia de normas ISO/IEC 27000`.
- Qué `requisitos` y `controles` define `ISO/IEC 27001:2022`.
- Cómo aplicar de forma introductoria `NIST CSF 2.0` en una `evaluación de riesgos`.
- Cómo comparar enfoques: `ISO/IEC 27001` vs `NIST CSF`.
- Qué es el modelo `Zero Trust`, sus `principios` y `componentes técnicos`.


### Qué son los estándares de ciberseguridad y por qué son necesarios
Un estándar de ciberseguridad es un conjunto documentado de buenas prácticas, requisitos o controles que una organización puede adoptar para proteger su información y sus sistemas frente a amenazas. No son leyes obligatorias por sí mismas (salvo cuando un regulador o cliente las exige contractualmente), pero funcionan como un lenguaje común entre empresas, auditores y proveedores.
Son necesarios por varias razones:

- Permiten medir el nivel de madurez de seguridad de una organización con criterios objetivos, en lugar de percepciones subjetivas.
- Facilitan el cumplimiento regulatorio (por ejemplo, en sectores financieros o de salud, donde la ley exige ciertos controles mínimos).
- Reducen el riesgo de incidentes al obligar a pensar en gestión de riesgos de forma sistemática, no solo reactiva.
Generan confianza ante clientes y socios: una certificación demuestra que existe un proceso, no solo buenas intenciones.


### Cómo funciona la familia de normas ISO/IEC 27000
La <mark>familia ISO/IEC 27000</mark> es un conjunto de normas internacionales dedicadas a la gestión de la seguridad de la información. No es una sola norma, sino un ecosistema de documentos que se complementan:

- ISO/IEC 27000: vocabulario y visión general de toda la familia.
- ISO/IEC 27001: la norma certificable, que define los requisitos de un Sistema de Gestión de Seguridad de la Información (SGSI).
- ISO/IEC 27002: catálogo detallado de controles de seguridad (es la "caja de herramientas" que complementa al Anexo A de la 27001).
- ISO/IEC 27005: guía específica para la gestión de riesgos de seguridad de la información.
- ISO/IEC 27017 / 27018: extensiones para entornos en la nube y protección de datos personales en la nube.

La lógica de la familia es: la 27001 dice qué hay que cumplir (los requisitos del sistema de gestión), y normas como la 27002 o la 27005 explican cómo hacerlo en la práctica.

### Qué requisitos y controles define ISO/IEC 27001:2022
ISO/IEC 27001:2022 es la norma que permite certificar un Sistema de Gestión de Seguridad de la Información (SGSI). Se estructura en dos grandes bloques:

Cláusulas 4 a 10 (requisitos del sistema de gestión)
Estas cláusulas son obligatorias para certificarse y siguen la lógica del ciclo PHVA (Planificar-Hacer-Verificar-Actuar):

- Contexto de la organización: entender el entorno, las partes interesadas y el alcance del SGSI.
- Liderazgo: compromiso de la alta dirección, política de seguridad, roles y responsabilidades.
- Planificación: evaluación y tratamiento de riesgos, definición de objetivos de seguridad.
- Soporte: recursos, competencias, concienciación, comunicación y documentación.
- Operación: ejecución del tratamiento de riesgos en el día a día.
- Evaluación del desempeño: auditorías internas, revisión por la dirección, métricas.
- Mejora: gestión de no conformidades y mejora continua.

Anexo A (controles)
La versión 2022 redujo y reorganizó los controles en 93 controles, agrupados en 4 categorías en lugar de las 14 anteriores:

- Organizacionales (37 controles): políticas, roles, gestión de proveedores, gestión de incidentes.
- Personas (8 controles): selección de personal, formación, acuerdos de confidencialidad.
- Físicos (14 controles): seguridad perimetral, control de acceso físico, eliminación segura de equipos.
- Tecnológicos (34 controles): control de accesos lógicos, criptografía, prevención de fuga de datos, seguridad de redes.

La organización no tiene que aplicar todos los controles del Anexo A, sino justificar en una Declaración de Aplicabilidad (SoA) cuáles aplica y cuáles excluye, según el resultado de su evaluación de riesgos.

### Cómo aplicar de forma introductoria NIST CSF 2.0 en una evaluación de riesgos
El NIST Cybersecurity Framework (CSF) 2.0, publicado en 2024, es un marco voluntario (no certificable como la ISO 27001) organizado en seis funciones principales:

- Gobernar (Govern): nueva función añadida en la versión 2.0, centrada en la estrategia, roles y supervisión.
- Identificar (Identify): entender los activos, riesgos y el contexto del negocio.
- Proteger (Protect): implementar salvaguardas (control de accesos, formación, protección de datos).
- Detectar (Detect): monitoreo continuo para identificar eventos anómalos.
- Responder (Respond): planes de respuesta a incidentes.
- Recuperar (Recover): restauración de servicios y aprendizaje post-incidente.

Para usarlo de forma introductoria en una evaluación de riesgos, un enfoque simple es:

- Definir el perfil objetivo (Target Profile): qué nivel de madurez se quiere alcanzar en cada función.
- Evaluar el perfil actual (Current Profile): en qué estado real está la organización hoy, función por función.
- Identificar las brechas entre el perfil actual y el objetivo.
- Priorizar acciones según el apetito de riesgo del negocio (no todo se puede arreglar a la vez).
- Construir un plan de acción con responsables y plazos para cerrar las brechas más críticas primero.

A diferencia de ISO 27001, el CSF no exige una estructura documental formal ni una certificación; es más flexible y suele usarse como punto de partida antes de adoptar un marco más riguroso.

### Cómo comparar enfoques: ISO/IEC 27001 vs NIST CSF


| **Aspecto** | **ISO/IEC 27001** | **NIST CSF 2.0** |
|-------------|-------------------|------------------|
| **Naturaleza** | Norma certificable | Marco de referencia voluntario |
| **Origen** | Internacional (ISO/IEC) | Estados Unidos (NIST) |
| **Estructura** | Cláusulas y Anexo A (93 controles en la edición 2022) | Seis funciones: **Govern, Identify, Protect, Detect, Respond y Recover** |
| **Enfoque** | Sistema de Gestión de Seguridad de la Información (SGSI) con mejora continua | Marco flexible para evaluar y fortalecer la ciberseguridad |
| **Certificación** | Sí, mediante auditoría externa | No, se utiliza como herramienta de autoevaluación y mejora |
| **Nivel de rigidez** | Más estructurado y con mayor documentación requerida | Más adaptable a organizaciones de cualquier tamaño |
| **Caso de uso típico** | Empresas que necesitan demostrar cumplimiento formal ante clientes, socios o reguladores | Organizaciones que buscan un punto de partida ágil o complementar otros marcos de seguridad |

> **En la práctica:** Muchas organizaciones utilizan ambos enfoques de forma complementaria. El **NIST CSF 2.0** proporciona una visión práctica y flexible para evaluar el estado de la ciberseguridad e identificar oportunidades de mejora, mientras que **ISO/IEC 27001** ofrece un marco formal para implementar, gestionar y certificar un Sistema de Gestión de Seguridad de la Información (SGSI), permitiendo demostrar el cumplimiento ante clientes, socios comerciales y organismos reguladores.

### Qué es el modelo Zero Trust, sus principios y componentes técnicos
El modelo Zero Trust ("confianza cero") parte de una premisa distinta a la seguridad perimetral tradicional: <mark>nunca confiar por defecto, verificar siempre</mark>, sin importar si la solicitud viene de dentro o fuera de la red corporativa.
Principios fundamentales

- Verificación explícita: cada solicitud de acceso se autentica y autoriza usando todos los datos disponibles (identidad, ubicación, estado del dispositivo, etc.), no solo una vez al inicio de sesión.
- Acceso de mínimo privilegio: los usuarios y dispositivos solo obtienen el acceso estrictamente necesario para su tarea, limitado en tiempo y alcance.
- Asumir la brecha (Assume Breach): se diseña el sistema asumiendo que ya hay un atacante dentro, por lo que se segmenta y monitorea todo el tráfico, no solo el perímetro.

Componentes técnicos típicos

- Microsegmentación de red: dividir la red en segmentos pequeños para limitar el movimiento lateral de un atacante.
- Gestión de identidades y accesos (IAM) con autenticación multifactor (MFA) como pieza central.
- Acceso de red Zero Trust (ZTNA): reemplaza a las VPN tradicionales, otorgando acceso a aplicaciones específicas en lugar de a toda la red.
- Monitoreo y análisis continuo (UEBA/SIEM): detectar comportamientos anómalos en tiempo real para reevaluar la confianza otorgada.
- Cifrado de datos en tránsito y en reposo, independientemente de si el tráfico es interno o externo.
- Políticas dinámicas basadas en contexto, gestionadas a menudo por un motor de políticas central (Policy Engine) que decide en cada solicitud si se concede, deniega o limita el acceso.

Zero Trust no es un producto único que se compra e instala, sino una filosofía arquitectónica que se implementa combinando varias tecnologías (IAM, segmentación, monitoreo) bajo los principios mencionados.
