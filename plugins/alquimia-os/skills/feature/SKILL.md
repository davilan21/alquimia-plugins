---
description: Construye una funcionalidad nueva en un proyecto que ya existe. Úsalo para todo lo que sea construir, igual que soporte se usa para todo lo que sea arreglar.
---

# Funcionalidad nueva

Qué construir:

$ARGUMENTS

Dos modos de trabajo, dos skills: `soporte` arregla lo que está roto, `feature`
construye lo que no existe. El riesgo es distinto — en soporte es la regresión, aquí
es **construir la cosa equivocada, o construirla de una forma que estorbe en seis meses**.

## 1. Contexto
Lee el `CLAUDE.md` del proyecto. Si hay registro de decisiones, léelo: lo que vas a
construir no puede contradecir una decisión ya tomada sin decirlo en voz alta.

## 2. Entender antes de proponer
Reformula en dos frases qué se pide y **para quién**. Si la petición viene en lenguaje
de solución ("agrégame un botón que exporte a Excel"), busca el problema detrás
("necesito pasarle estos datos al contador"). A veces la mejor implementación de un
botón es no construir el botón.

Si la respuesta cambia según una decisión de negocio que nadie tomó, **para y
pregunta**. Una funcionalidad construida sobre una suposición se descubre en
producción, y se descubre cara.

## 3. Plan antes de código
Entrega, antes de tocar nada:
- Qué archivos se crean y cuáles se modifican.
- Qué se rompe si esto sale mal.
- Qué queda explícitamente fuera de alcance.
- Si hay una decisión de una sola puerta, delega en el subagente `arquitecto`.

Espera aprobación humana del plan. **Este es el punto de control barato**: corregir un
plan cuesta un minuto, corregir una implementación cuesta una tarde.

## 3b. Si tiene interfaz, la experiencia se decide antes

Si esta funcionalidad se ve en pantalla, delega en el subagente `disenador-ux` **antes
de escribir la interfaz**, no después de tenerla fea. Lo mínimo que tiene que salir de
ahí: la única acción de cada pantalla nueva, y los estados de vacío, cargando, error y
datos extremos.

Para el estilo visual concreto —paletas, tipografías, componentes— usa la skill
`ui-ux-pro-max` si está disponible en el entorno, y respeta los colores de marca del
cliente por encima de cualquier paleta.

## 4. Rebanada, no capa
Aunque el proyecto ya exista, construye vertical: el flujo completo de esta
funcionalidad, de datos a interfaz, funcionando de punta a punta. No dejes la mitad
hecha "para completar después": la mitad sin terminar de una funcionalidad es
indistinguible de un bug, y alguien la va a encontrar.

Si no cabe en un PR razonable, pártela en rebanadas que cada una sirva para algo por
sí sola. "Fase 1: la parte de atrás; fase 2: la pantalla" no es partir en rebanadas —
la fase 1 no le sirve a nadie.

**Quién escribe el código: tú, la sesión principal.** Los subagentes de este plugin no
pueden editar; están para diagnosticar, decidir y revisar. Solo delega en el subagente
`implementador` cuando haya varias funcionalidades avanzando en paralelo sobre el mismo
repositorio, porque corre en un worktree aislado.

## 5. Test del camino feliz
Un test que recorra la funcionalidad como lo haría un usuario. No busques cobertura:
busca que si esto se rompe dentro de tres meses, alguien se entere sin que un cliente
lo reporte.

## 6. Verificación
Suite completa en verde. Después `revisor-critico` sobre el diff. Si toca dinero,
datos regulados, formatos hacia terceros o registros inmutables, también
`guardian-dominio`.

## 7. PR

```
## Qué se pidió y por qué
El problema detrás de la petición.

## Qué construí
Lista corta.

## Qué decidí por el camino
Las decisiones que tomé sin preguntar, para que puedas objetarlas.

## Qué dejé fuera
Explícito, para que no se confunda con un olvido.

## Cómo se verifica
El test nuevo.

## Cómo lo compruebas tú — 3 pasos
1. Entrá a <pantalla exacta>  (link de vista previa si existe)
2. Haz <acción exacta>
3. Deberías ver <resultado exacto>
Escrito para alguien que no lee código.

## Riesgo
Qué se rompe si esto está mal.
```

La sección **"qué decidí por el camino"** es la que hace revisable un PR de
funcionalidad nueva. Sin ella, quien revisa solo ve código y no ve las suposiciones,
que es donde de verdad están los errores.

## 8. Cierre
Si el `CLAUDE.md` del proyecto define un ritual de cierre, cúmplelo. Si esta
funcionalidad estableció una regla nueva del dominio, súbela a `CLAUDE.md` en una línea.
