---
description: Elige el stack técnico de un sistema nuevo a partir de la forma del problema, no de la moda ni de la costumbre. Úsalo en la definición, antes de escribir código.
---

# Elección de stack

Sistema a construir (o el documento de definición, si ya existe):

$ARGUMENTS

Elegir stack por costumbre y elegirlo por moda son el mismo error con distinto signo:
los dos deciden antes de mirar el problema. Este procedimiento mira el problema primero.

Delega el análisis en el subagente `arquitecto`. Tu trabajo aquí es que se hagan
las preguntas correctas y en el orden correcto.

---

## 1. La forma del problema, antes que cualquier tecnología

Ocho preguntas. Las respuestas determinan el stack más que cualquier preferencia:

1. **¿Qué hace el sistema la mayor parte del tiempo?** Mostrar datos · capturar datos ·
   transformar archivos · calcular · coordinar personas · integrar sistemas ajenos ·
   procesar en lote. Un sistema que el 90% del tiempo muestra formularios y un sistema
   que el 90% del tiempo procesa PDFs no comparten stack aunque los dos "sean web".
2. **¿Cuánto del trabajo pasa fuera de una petición del usuario?** Si hay trabajo largo,
   colas, reintentos o procesos nocturnos, eso manda sobre la elección del framework
   de interfaz, no al revés.
3. **¿Quién lo usa y desde dónde?** Navegador de escritorio · celular de gama baja con
   datos móviles · lector de código de barras · sin internet a ratos. Offline-first
   cambia el stack entero.
4. **¿Cuántos escriben a la vez y qué pasa si dos escriben lo mismo?** Concurrencia real
   y colaboración en vivo son requisitos de base de datos, no detalles.
5. **¿Con qué tiene que hablar?** Sistemas viejos, SOAP, archivos planos, un ERP,
   una entidad del Estado. Las integraciones suelen imponer el lenguaje.
6. **¿Hay restricciones de dónde viven los datos?** Residencia, on-premise, sector
   regulado. Descarta proveedores antes de comparar frameworks.
7. **¿Quién lo va a mantener dentro de dos años?** Si la respuesta es "yo con agentes",
   pesa muchísimo la madurez del ecosistema: documentación abundante y patrones comunes
   valen más que elegancia.
8. **¿Cuánto tiene que durar?** Un piloto de tres meses y un sistema a diez años
   toleran riesgos técnicos distintos.

Si el humano no puede responder la 1, la 2 o la 5, **para**: elegir stack sin eso es
adivinar con vocabulario técnico.

## 2. El default y cómo se rompe

El default de la casa es lo que ya corre en los demás proyectos. **No porque sea el
mejor stack del mundo, sino porque es el único con el que un plugin, un agente y una
lección aprendida sirven en todos lados.** Salirse tiene un costo real y hay que
nombrarlo, no ignorarlo:

- El `alquimia-os` deja de aplicar en parte: hooks, comandos y convenciones asumen ese stack.
- Lo aprendido en ese proyecto no cruza a los otros.
- Te vuelves la única persona que sabe operarlo.

**Ese costo se paga cuando el problema lo justifica.** Estas señales lo justifican, y
cada una hay que verificarla contra el sistema real, no suponerla:

| Señal | Por qué rompe el default |
|---|---|
| El núcleo es procesamiento pesado, cálculo numérico o modelos | El ecosistema de datos y ML vive en otro lenguaje |
| Trabajo largo, colas, reintentos, procesos nocturnos como parte central | Necesita un runtime de trabajos, no un framework de páginas |
| Colaboración en vivo o edición concurrente del mismo registro | Impone motor de datos y protocolo de sincronización |
| Offline-first o hardware específico (impresoras, lectores, sensores) | Impone plataforma cliente |
| Alta escritura sostenida o series de tiempo | Impone motor de datos |
| On-premise, residencia de datos o sin internet | Descarta proveedores gestionados |
| El cliente ya tiene un sistema y esto se le integra | Hereda el stack del sistema anfitrión |
| Ya existe un equipo que lo va a mantener | Su stack gana sobre el tuyo |

Y una regla dura: **ninguna de estas cuenta si es hipotética.** "Puede que necesitemos
tiempo real más adelante" no es una señal, es una excusa cara.

## 3. Verifica el estado actual, no tu memoria

Las herramientas cambian, se abandonan y cambian de licencia. Antes de recomendar algo
que no sea el default, **búscalo**: última versión, ritmo de mantenimiento, licencia,
cambios recientes de modelo de negocio. Recomendar por prestigio recordado es cómo se
adopta algo que ya nadie mantiene.

## 4. Máximo tres candidatos

Uno es siempre el default de la casa, aunque el análisis lo descarte — para que se vea
qué se está sacrificando. Por cada candidato:

- Qué gana el sistema con esto, atado a una de las ocho preguntas.
- Qué pierde.
- Qué cuesta cambiarlo en un año.
- En qué escenario esta es la respuesta correcta.

## 5. Decide por capa, no en bloque

"El stack" no es una decisión: son cinco, y no todas tienen el mismo peso.

| Capa | ¿Qué tan cara de cambiar? |
|---|---|
| Motor de datos | **Muy cara.** Es la decisión real |
| Modelo de datos | **Muy cara.** Más que el motor |
| Identidad y permisos | Cara |
| Lenguaje del backend | Media |
| Framework de interfaz | **Barata.** Casi nunca merece discusión |

La discusión se concentra donde está el costo. Pelear por el framework de interfaz
mientras se decide el modelo de datos al descuido es el error más común y el más caro.

## 6. Entrega

```
## Forma del problema
Las respuestas a las ocho preguntas, en tres líneas.

## Recomendación
Por capa. Y por qué, atado a la forma del problema.

## Dónde nos salimos del default y qué cuesta
Explícito. Si no nos salimos, decirlo también.

## Lo que descartamos y por qué
Máximo tres, una línea cada uno.

## Qué haría reconsiderar esto
La señal concreta que obligaría a revisar la decisión.
```

## Anti-patrones

- **Elegir por benchmark.** Con los usuarios del día uno, el rendimiento nunca es el
  criterio. Lo será dentro de dos años, si el negocio funciona.
- **Elegir por lo que está de moda.** El costo de la novedad lo paga quien mantiene.
- **Elegir por CV.** Aprender algo nuevo es válido; hacerlo con el proyecto de un
  cliente sin decirlo, no.
- **Elegir por costumbre sin mirar el problema.** El error que este documento existe
  para evitar.
- **Añadir una pieza "por si acaso".** Cada servicio extra es algo que se rompe a las
  3 a.m. y que alguien tiene que entender.
