---
description: Convierte un fallo reciente en una baranda permanente. Úsalo cada vez que algo se rompa, en cualquier proyecto.
---

# Postmortem

Qué se rompió:

$ARGUMENTS

## 1. Qué pasó
Dos frases: qué falló y por qué el sistema lo permitió.

## 2. Elige el nivel de la baranda
De más fuerte a más débil. Sube al escalón más alto que sea viable:

1. **Un test** — la máquina lo verifica sola, para siempre.
2. **Un permiso `deny`** en `.claude/settings.json` — Claude Code lo bloquea; el
   modelo no puede negociarlo.
3. **Un hook** — corre solo y devuelve el error en el acto.
4. **Una regla en `REVIEW.md`** — el revisor lo marca antes de que llegue un humano.
5. **Una línea en `CLAUDE.md`** — la más débil: depende de que el modelo la lea y la respete.

## 3. Decide el alcance — este paso es el que hace que el sistema escale

Pregúntate: **¿este fallo puede pasar en otro proyecto?**

- **Solo en este cliente** (una regla de su negocio) → va al `CLAUDE.md` del repo.
- **Puede pasar en cualquier proyecto** (una forma de fallar del stack, de git, del
  proceso) → va al **plugin `alquimia-os`**, para que los demás proyectos queden
  protegidos sin que nadie lo repita a mano. Di explícitamente que hay que abrir
  un PR contra el repo del plugin, y redacta el cambio.

Un fallo que se arregla solo en un repo se va a repetir en los otros cinco.

## 4. Impleméntalo
En el nivel y el alcance que elegiste.

## 5. Redacta la regla como un hecho, no como un consejo
Mal: "tener cuidado con las migraciones".
Bien: "toda columna nueva no-nullable necesita default o backfill en la misma migración".

## 6. Muestra el diff de lo que agregaste.
