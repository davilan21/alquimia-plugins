---
description: Diagnostica en qué se están yendo los minutos de GitHub Actions de un repositorio y qué recortar primero. Úsalo cuando la factura o el consumo de CI se dispare.
---

# Dónde se van los minutos de CI

Repositorio (si no se indica, el actual):

$ARGUMENTS

Los minutos de Actions no se van por un workflow caro. Se van por **la multiplicación**:
cuántos workflows corren × cuántas veces se empuja. Casi siempre el problema es el
segundo factor, y casi siempre se busca en el primero.

## 1. Mide antes de opinar

```bash
# Consumo de la cuenta (necesita gh instalado y autenticado)
gh api "/users/$(gh api user -q .login)/settings/billing/actions"

# Las 50 corridas más recientes, con duración
gh run list --repo <owner/repo> --limit 50 \
  --json name,conclusion,createdAt,updatedAt,event

# Qué workflow acumula más corridas
gh run list --repo <owner/repo> --limit 200 --json name -q '.[].name' | sort | uniq -c | sort -rn
```

Si `gh` no está instalado, el consumo está en
**github.com → Settings → Billing and licensing → Usage**.

## 2. Calcula el costo de un push

Cuenta cuántos workflows dispara **un solo push** a una rama con PR abierto, y suma sus
duraciones. Ese número, multiplicado por los pushes del mes, es tu factura.

Si un push cuesta 12 minutos y hay 400 pushes al mes, son 4.800 minutos —
muy por encima de lo incluido en cualquier plan que no sea Enterprise.

## 3. Recorta en este orden

| # | Palanca | Por qué primero |
|---|---|---|
| 1 | **Menos pushes por PR** | Es el multiplicador. Commitear local y empujar una vez cuando la suite está verde divide la factura, sin tocar un solo workflow |
| 2 | **`concurrency` con `cancel-in-progress`** | Mata las corridas viejas cuando llega un push nuevo. Una línea por workflow |
| 3 | **Unificar workflows** | Tres workflows separados hacen tres `checkout` y tres `npm ci`. Como jobs de un mismo workflow, comparten el arranque |
| 4 | **Saltar borradores** | `if: github.event.pull_request.draft == false` |
| 5 | **Detección temprana dentro del job** | Un primer paso que mira qué cambió y sale en segundos si no aplica. **No pongas `paths:` en el `on:`** de un check requerido: el job no arranca y el PR queda colgado esperando un estado que nunca llega |
| 6 | **`timeout-minutes` en todo** | No baja el costo normal; evita que un cuelgue se coma la cuota |
| 7 | **Runner propio** | Si ya pagas un servidor, ahí los minutos no se cobran igual. Verifica las condiciones vigentes antes de moverte |

## 4. Lo que NO hay que recortar

- **Los tests.** Si el CI cuesta caro, el problema es cuántas veces corre, no que corra.
- **El chequeo de tipos y el build.** Son los más baratos y los que más atrapan.

Recortar verificación para ahorrar minutos es cambiar una factura que ves por
incidentes que no ves.

## 5. Entrega

```
## Consumo actual
Minutos usados, incluidos, y qué queda.

## Qué lo está causando
El workflow y el disparador, con números. No adivines.

## Costo de un push
Workflows disparados × duración = minutos por push.

## Qué recortar, en orden
Máximo tres cosas, con el ahorro estimado de cada una.

## Qué NO tocar
Y por qué.
```
