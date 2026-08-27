---
description: Convierte un objetivo en un PLAN.md ejecutable por turnos desatendidos, con tareas autorizadas una por una. Úsalo cuando quieras dejar trabajo corriendo de noche.
---

# Plan ejecutable

Objetivo:

$ARGUMENTS

Una sesión desatendida **no recuerda la anterior**: cada corrida arranca limpia y solo
sabe lo que está en el repositorio. Por eso el plan no puede vivir en una conversación:
tiene que vivir en un archivo, y ese archivo es a la vez la memoria y la autorización.

## 1. Descomponé en tareas de un turno

Cada tarea tiene que caber en **una corrida de una sesión** y terminar en **un PR
mergeable por sí solo**. Si una tarea depende de que otra se haya mezclado antes,
dilo con `depende:` — el turno de noche no la va a tocar hasta que la anterior esté
mezclada.

Reglas de tamaño: cinco archivos o menos, un solo propósito, y un criterio de
terminado que se pueda verificar sin opinar.

## 2. Escribe `PLAN.md` en la raíz del repositorio

```markdown
# Plan — <objetivo>

Cada tarea es autorizada individualmente marcando [x] en "autorizada".
El turno de noche SOLO ejecuta tareas autorizadas y no bloqueadas.

## T1 — Título corto
- autorizada: [x]
- estado: pendiente        # pendiente | en-pr | mezclada | bloqueada
- depende: —
- qué: una frase.
- terminado cuando: criterio verificable.
- no toca: lo que queda explícitamente fuera.

## T2 — Título corto
- autorizada: [ ]          # sin marcar = el turno de noche la salta
- estado: pendiente
- depende: T1
- qué: ...
- terminado cuando: ...
- no toca: ...
```

**`autorizada: [x]` es tu firma.** Una tarea sin marcar no se ejecuta, aunque esté
perfectamente descrita. Autorizás las que quieres que corran esta noche y dejas el resto
sin marcar; mañana marcas más.

## 3. Revisa el plan con criterio antes de firmarlo

Por cada tarea pregúntate:

- ¿Qué pasa si esto sale mal a las 3 a.m. y nadie lo ve hasta las 8?
- ¿Es reversible con un revert limpio?
- ¿Toca dinero, datos regulados, formatos hacia terceros o migraciones?

Si la respuesta a la última es sí, **no la autorices para la noche.** Esas se hacen con
tú presente. Dejala descrita y sin marcar.

## 4. Entrega

El `PLAN.md`, y una lista de cuáles recomiendas autorizar esta noche y cuáles no,
con la razón en media línea. Tú decides y marcas.
