---
description: Audita y sanea los archivos de memoria y contexto del proyecto (CLAUDE.md y docs de estado) cuando las sesiones arrancan lentas o el contexto se llena solo.
---

# Higiene de memoria

Un sistema de memoria mal mantenido se convierte en el mayor consumidor de contexto
del proyecto: el archivo que existía para ahorrar contexto termina gastándolo entero.
Y hay un efecto de segundo orden peor: cuanto más largo el texto, menos peso relativo
tiene cada regla dentro de él.

## 1. Mide

Para `CLAUDE.md` y para cada archivo que el proyecto declare de lectura obligatoria:

```bash
for f in CLAUDE.md docs/*.md; do
  [ -f "$f" ] && echo "$(printf '%-40s' "$f") $(wc -c < "$f") bytes ≈ $(( $(wc -c < "$f") / 4 )) tokens"
done | sort -k2 -rn | head -15
```

Suma el costo de lo obligatorio. Compáralo contra el presupuesto de abajo.

## 2. Presupuesto

| Archivo | Tope | Por qué |
|---|---|---|
| `CLAUDE.md` | 150 líneas | Se lee entero, siempre, en cada sesión, PR y rutina |
| Estado actual | 300 líneas | Solo lo vivo: en qué se está y qué sigue |
| Mapa del proyecto | 200 líneas | Dónde está cada cosa |
| Lectura obligatoria total | **~8.000 tokens** | Por encima de esto ya estás pagando un peaje en cada sesión |

## 3. Diagnostica la inversión

Compara el historial de commits:

```bash
git log --oneline -- CLAUDE.md | wc -l
git log --oneline -- <archivo-de-estado> | wc -l
```

Si el archivo de estado tiene decenas de veces más commits que `CLAUDE.md`, la memoria
está invertida: el aprendizaje duradero se está escribiendo en el archivo efímero y las
reglas permanentes no crecen. Es el síntoma más común y el más caro.

## 4. Reparte

Recorre el archivo inflado y clasifica cada bloque en uno de tres destinos:

- **Regla permanente** (se cumple siempre, no caduca) → sube a `CLAUDE.md`, en una línea.
- **Historia** (lo que se hizo, decisiones ya tomadas, incidentes cerrados) → baja al
  log de tareas o de decisiones, que nadie lee al arrancar.
- **Estado vivo** (en qué se está trabajando ahora, qué bloquea, qué sigue) → se queda,
  dentro del tope.

Nunca borres: mueve. Y muestra el diff de cada movimiento antes de aplicarlo.

## 5. Deja la baranda puesta

El hook `memoria-guard` del plugin avisa cuando un archivo declarado de lectura
obligatoria supera su tope. Confirma que el proyecto declara sus archivos de memoria
en `CLAUDE.md` para que el hook sepa cuáles vigilar.
