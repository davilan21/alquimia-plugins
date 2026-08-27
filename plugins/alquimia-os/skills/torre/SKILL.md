---
description: Muestra en un solo lugar qué está esperando tu decisión en TODOS los proyectos. Úsalo cuando quieras saber en qué estás parado sin abrir seis repos.
---

# Torre de control

Alcance (si no se indica, todos los repositorios de la organización):

$ARGUMENTS

No monitoreas agentes. **Monitoreás una cola de decisiones.** Ese es el cambio de
modelo mental: no te importa qué está haciendo cada agente ahora mismo, te importa
qué está detenido esperándote a tú.

## 1. Reúne el estado

Usa `gh` para consultar GitHub sin clonar nada. Ajustá el `--owner` al de la organización.

```bash
# PRs abiertos en todos los repos
gh search prs --owner davilan21 --state open --limit 50 \
  --json repository,number,title,author,createdAt,isDraft,url

# Issues esperando una decisión de negocio
gh search issues --owner davilan21 --state open --label needs-decision --limit 30 \
  --json repository,number,title,createdAt,url

# Soporte sin triage
gh search issues --owner davilan21 --state open --label soporte --limit 30 \
  --json repository,number,title,createdAt,labels,url
```

Para cada PR abierto, mira el estado del CI:

```bash
gh pr checks <numero> --repo davilan21/<repo> --json name,state 2>/dev/null
```

## 2. Clasifica por lo que te toca hacer, no por proyecto

Un reporte ordenado por proyecto te obliga a leerlo entero para saber qué hacer.
Ordenalo por acción:

| Cubo | Qué entra |
|---|---|
| **Decidí tú** | Issues con `needs-decision`. Nada avanza hasta que respondas |
| **Revisa y mezclá** | PRs con CI en verde esperando aprobación |
| **Está roto** | PRs con CI en rojo, rutinas que fallaron |
| **Se está enfriando** | PRs o issues sin movimiento hace más de 3 días |
| **Corriendo** | Lo que está en progreso. Informativo, no accionable |

## 3. Entrega

```
# Torre de control — <fecha>

## Decidí tú  (N)
- [proyecto] #123 — la pregunta concreta en una línea → link

## Revisa y mezclá  (N)
- [proyecto] #124 — qué hace, en una línea → link

## Está roto  (N)
- [proyecto] #125 — qué falla → link

## Se está enfriando  (N)
- [proyecto] #126 — quieto hace N días → link

## Números
PRs abiertos · issues de soporte sin triage · % cerrados sin decisión humana esta semana
```

Cierra con **una sola línea**: por dónde empezar hoy.

## Reglas

- Si un cubo está vacío, dilo en una línea y sigue. No inventes trabajo.
- Nunca listes más de 10 por cubo: si hay más, agrupá y dá el conteo. Una lista de
  cuarenta cosas no es una torre de control, es ruido con formato.
- No abras PRs ni modifiques nada. Esta skill solo mira.
