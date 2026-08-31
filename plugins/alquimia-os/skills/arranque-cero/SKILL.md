---
description: Fase de definición de un proyecto nuevo, antes de escribir una sola línea. Produce el alcance, las decisiones irreversibles y el plan del primer flujo. No genera código.
---

# Arranque desde cero — definición

Idea del proyecto:

$ARGUMENTS

**No vas a escribir código en esta skill.** Si terminas esta sesión con archivos de
implementación creados, fallaste.

La forma en que un proyecto vibe codeado se vuelve inmantenible no es escribiendo mal
código: es **no tomando decisiones**. Cuando nadie decide, el modelo decide por
omisión, treinta veces, en treinta archivos, y en la semana tres nadie sabe por qué
el sistema es como es. Esta fase existe para que las decisiones que cuestan caro se
tomen a propósito y queden escritas.

---

## 1. Qué es y qué no es

Entrevista al humano. Una pregunta a la vez, esperando respuesta:

1. **En una frase, ¿qué hace este sistema y para quién?** Si no cabe en una frase,
   todavía no está claro.
2. **¿Cuál es la única cosa que si no funciona, el proyecto no sirve?** Ese es el
   camino crítico. Todo lo demás es secundario, aunque no lo parezca.
3. **¿Qué NO es este sistema?** Tres cosas que la gente va a pedir y que quedan fuera.
   Escribirlas ahora vale más que decir que no diez veces después.
4. **¿Quién lo va a usar el primer día y cuántos son?** Número real, no proyección.
5. **¿Qué pasa si esto se cae un martes a las 10 a.m.?** Define cuánta ingeniería
   merece: no es lo mismo un panel interno que un sistema por el que pasa dinero.
6. **¿Con qué tiene que hablar?** Sistemas, APIs, archivos, gente. Las integraciones
   son de donde salen las sorpresas.

## 2. Las decisiones de una sola puerta

Delega en el subagente `arquitecto` las que apliquen. Solo las que apliquen: forzar
decisiones que no existen es otra forma de perder la semana.

**El stack no se asume.** Antes de las decisiones de abajo, corre `/alquimia-os:stack`:
elige a partir de la forma del problema, no de lo que usamos la última vez. El default
de la casa es el punto de partida y la carga de la prueba está en salirse — pero es una
carga que se puede descargar, y hay ocho señales concretas que la descargan.

- **Modelo de datos** — las tres o cuatro entidades centrales y cómo se relacionan.
  Es lo más caro de cambiar de todo lo que hay en esta lista.
- **Identidad y permisos** — quién entra y qué puede ver. Si hay más de un cliente
  o más de una sede compartiendo la base, esta decisión se toma el día uno o se paga
  carísima después.
- **Dinero** — si hay valores monetarios: en qué se guardan (enteros o decimal, nunca
  punto flotante), en qué moneda, y qué pasa con impuestos y redondeo.
- **Dónde vive el estado** — base de datos, archivos, colas.
- **Cómo se despliega y cómo se revierte** un despliegue malo.

## 3. La experiencia, antes del primer píxel

Delega en el subagente `disenador-ux`. **Esta fase no produce maquetas**: produce las
decisiones que después hacen que la interfaz sea obvia de construir.

La mayoría de las interfaces malas no son feas: resolvieron bien la pantalla equivocada,
o nunca decidieron qué pasa cuando no hay datos. Lo que sale de aquí:

- **Contexto de uso real** — dónde está la persona, con qué dispositivo, cuántas veces
  al día, con cuánta prisa. Una recepcionista de pie con un paciente enfrente y un
  analista revisando en la tarde necesitan interfaces distintas para el mismo dato.
- **El flujo contado en pasos de persona**, y cuántas pantallas hacen falta de verdad.
- **Los cinco estados que nadie diseña**: vacío, cargando, error, sin permiso y datos
  extremos. Aquí vive casi todo el trabajo mal hecho, y decidirlo ahora cuesta una
  tabla; decidirlo después cuesta rehacer pantallas.
- **Dónde se confirma y dónde se deshace**, según lo caro que sea equivocarse.

Si el proyecto es para un cliente con marca propia, **pide el logo y los colores antes
de que nadie proponga una paleta**. Los colores del cliente mandan.

## 4. Los datos delicados, ahora y no después

Pregunta explícitamente: **¿qué datos va a tocar este sistema que no pueden salir en
un log, en un mensaje de error, en una URL o en analytics?**

Datos de salud, documentos de identidad, información financiera, datos de menores.
Esta respuesta se convierte en una regla de dominio del `CLAUDE.md` y en una regla
bloqueante del `REVIEW.md`. Meterla el día uno cuesta una frase; meterla el mes seis
cuesta una auditoría.

## 5. El primer flujo

Define **un solo flujo completo, de punta a punta**, que atraviese todas las capas
del sistema: entrada del usuario → lógica → datos → salida visible.

No es una pantalla. No es un módulo. Es el camino crítico del punto 1, en su versión
más pequeña que sea real.

Ejemplo: no "el módulo de exámenes", sino "un usuario entra, crea un examen con tres
campos, lo guarda, y lo ve en una lista al recargar".

## 6. Entrega

Un solo documento, que el humano aprueba antes de que exista una línea de código:

```
# <Proyecto> — Definición

## Qué es
Una frase.

## Camino crítico
La operación que no puede fallar.

## Qué NO es
Tres cosas, explícitas.

## Usuarios el día 1
Quiénes y cuántos.

## Decisiones tomadas
| Decisión | Elegida | Por qué | Qué la reconsideraría |

## Datos delicados
Qué nunca sale en logs, errores, URLs o analytics.

## Experiencia
Contexto de uso · flujo en pasos de persona · los cinco estados por pantalla.

## Primer flujo
El flujo exacto, punta a punta.

## Fuera de alcance por ahora
Lo que sabemos que hará falta y decidimos no hacer todavía.
```

Cuando esté aprobado: `/alquimia-os:nuevo-proyecto` para instrumentar el repositorio,
y después `/alquimia-os:punta-a-punta` para construir.
