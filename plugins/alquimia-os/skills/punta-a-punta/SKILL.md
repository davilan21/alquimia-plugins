---
description: Construye el primer flujo de punta a punta de un proyecto nuevo — un camino completo que atraviesa todas las capas, con test y despliegue — antes de construir cualquier otra cosa.
---

# Primer flujo de punta a punta

Flujo a construir (si no se indica, tómalo de la definición del proyecto):

$ARGUMENTS

## Por qué esto y no las pantallas

La tentación al arrancar es construir a lo ancho: todas las pantallas, todos los
modelos, todo el CRUD. Se ve productivo y es la forma más confiable de terminar con
cuarenta archivos que nunca se probaron juntos.

Construir de punta a punta es lo contrario: **un solo camino que atraviesa todas las
capas**. Es poco código, pero valida lo caro: que el stack encaja, que el modelo de
datos aguanta, que el despliegue funciona, que la autenticación no estorba. Los
problemas que hunden un proyecto aparecen en las costuras entre capas, y este camino
las cruza todas.

Multiplicar a lo ancho después de esto es barato. Antes, es apostar.

## El procedimiento

### 1. Plan primero
Escribe qué archivos vas a crear y por qué, antes de crear ninguno. Máximo una
pantalla de texto. Si la lista pasa de doce archivos, el flujo es demasiado grueso:
recórtalo.

### 2. El esqueleto que corre
Antes de la lógica: que el proyecto arranque, compile y muestre algo en pantalla.
Commit. Un proyecto que no arranca no se puede depurar; un proyecto que arranca vacío sí.

### 3. Los datos
Solo las entidades del flujo. Nada de "ya que estamos" con las otras ocho tablas.
Si hay migraciones, que sean reversibles desde la primera.

### 4. El flujo, de atrás hacia adelante
Datos → lógica → interfaz. En ese orden: la interfaz sobre lógica que no existe
produce pantallas bonitas que no hacen nada, y esa es la forma más común de
autoengañarse sobre el avance.

### 5. Los estados, no solo el camino feliz
Antes de dar por hecha la interfaz, implementa los estados que definió la fase de
experiencia: vacío, cargando, error y datos extremos. Una tabla vacía sin texto es la
forma más rápida de que alguien crea que el sistema se dañó.

Si este flujo tiene interfaz y no hubo fase de experiencia, delega en el subagente
`disenador-ux` antes de seguir. No inventes los estados sobre la marcha.

### 6. El test de humo — este paso no es opcional
Un test end-to-end que recorre el flujo completo como lo haría una persona.
**Uno solo, del camino feliz.**

Este test es la razón entera de construir así: es la primera baranda del proyecto, y
si no se escribe ahora no se escribe nunca — después siempre hay algo más urgente.
A partir de aquí, cada flujo nuevo agrega su test y el proyecto nunca está sin red.

### 7. Desplegar
A un entorno real, aunque no lo use nadie todavía. Desplegar es la parte que siempre
sorprende: variables de entorno, permisos, build que funciona en local y no fuera.
Descubrirlo con doce archivos es una tarde; descubrirlo con doscientos es una semana.

### 8. Cerrar el ciclo
- Actualiza `CLAUDE.md`: los comandos reales que quedaron, no los que planeaste.
- Anota en el registro de decisiones lo que cambió respecto al plan. **Siempre cambia
  algo**, y ese delta es la información más valiosa del proyecto.
- Corre `/alquimia-os:preflight`.

## Lo que NO haces en esta fase

- No agregas una dependencia sin poder decir qué se rompe si no está.
- No creas abstracciones para casos que todavía no existen. Con dos usos se ve el
  patrón; con uno solo se adivina, y adivinar es cómo se llega a arquitecturas que
  nadie entiende.
- No construyes pantallas fuera del flujo.
- No optimizas nada. Con los usuarios del día uno, no hay nada que optimizar.

## Después

De aquí en adelante el proyecto ya no es "nuevo": cada cosa que agregues entra por
`/alquimia-os:feature`, un flujo a la vez.
