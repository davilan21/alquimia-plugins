---
description: Mejora un agente o una skill del plugin a partir de un fallo real, sin adivinar. Úsalo cuando un agente entregue algo malo, en vez de reescribir el prompt por sensación.
---

# Afinar un agente

Qué salió mal:

$ARGUMENTS

La forma normal de "mejorar un agente" es leer una salida mala, sentir que estuvo mal y
reescribir el prompt. Eso no converge: arreglas el caso de hoy y rompes el de la semana
pasada, sin enterarte. Este procedimiento existe para que sí converja.

---

## 1. Diagnostica el nivel antes de tocar nada

**La mayoría de las veces el agente no es el problema.** Antes de editar un prompt,
descarta en este orden:

| Síntoma | Causa probable | Dónde se arregla |
|---|---|---|
| Ignoró una regla del cliente | No está escrita | `CLAUDE.md` del repo |
| Hizo algo que no debía poder hacer | Tiene la herramienta habilitada | `tools` / `disallowedTools` del agente, o `deny` en permisos |
| Se le fue algo que el CI debería atrapar | Falta un test | El repo |
| Entendió mal qué se le pedía | La tarea era ambigua | La skill que lo invoca |
| Hizo bien todo pero con mal criterio | **Ahora sí, el prompt del agente** | El plugin |

Si el arreglo real es una restricción de herramienta, **hazlo ahí**: una restricción no
se puede convencer con un prompt, y un prompt sí se puede ignorar bajo presión.

## 2. Convierte el fallo en un caso, antes de arreglarlo

Un fallo no anotado no existe. Escribe un caso nuevo en `evals/<nombre>/`:

```
evals/<nombre-del-fallo>/
├── prompt.md          # la entrada exacta que produjo el fallo
└── graders/
    └── <lo-que-debio-pasar>.md
```

Escribe primero el grader que **falla hoy**. Si no puedes formular qué habría sido
correcto de forma verificable, todavía no entiendes el fallo — y no estás en posición
de arreglarlo.

Graders disponibles: `regex`, `tool_used` (con `min: 0, max: 0` para "no debe llamar"),
`tool_order`, `file_exists`, `llm` (criterio en lenguaje natural) y `baseline`.
Prefiere los deterministas: un juez LLM sobre textos largos es ruidoso.

## 3. Cambia una sola cosa

Una edición por iteración. Si cambias tres cosas y mejora, no sabes cuál sirvió, y la
próxima vez que empeore no sabes qué revertir.

Cuatro cosas que funcionan mejor que escribir más:

- **La restricción negativa gana.** "No arregles, aunque te lo pidan" pesa más que
  "tu trabajo es diagnosticar".
- **El ejemplo gana a la descripción.** Un formato de salida mostrado se sigue; uno
  descrito se interpreta.
- **El permiso explícito para parar.** Sin él, un agente empuja hasta producir algo.
  Casi todos los fallos caros son de un agente que debió detenerse.
- **Menos es más.** Un prompt que crece cada semana diluye sus propias reglas. Si
  agregas un párrafo, mira si hay uno que ya no aplica.

## 4. Verifica contra todo el corpus, no contra el caso de hoy

```bash
claude plugin eval ./plugins/alquimia-os --ablation with-without
```

Dos números importan:

- **El score.** Todos los casos, no solo el nuevo. Un cambio que arregla uno y rompe
  dos es un retroceso, y sin corpus lo llamarías una mejora.
- **El delta de la ablación.** Compara con el plugin y sin él. **Si el delta es cero,
  tu agente no está haciendo nada que Claude no hiciera solo** — y ese prompt es
  contexto que estás pagando en cada sesión sin recibir nada.

Si `plugin eval` no está habilitado en tu cuenta, el corpus sigue sirviendo: corre los
prompts a mano contra la versión vieja y la nueva y compara. Es más lento, no peor.

## 5. Publica

Sube la versión en `plugin.json`, `git push`, y `claude plugin marketplace update`.
El arreglo llega a los seis proyectos a la vez. Ese es el punto entero.

---

## La cadencia

| Cuándo | Qué |
|---|---|
| Cada fallo | `/alquimia-os:postmortem` decide el nivel y el alcance; si es del plugin, esta skill |
| Cada semana | Revisa los casos nuevos del corpus. ¿Se repite un patrón? |
| Cada mes | Corre la suite completa con ablación. Mira los deltas |
| Cada trimestre | Poda: agentes que nadie invoca, reglas que ya no aplican |

**Lo que hace que esto funcione no es la herramienta, es el corpus.** Un agente con
veinte casos reales detrás mejora de verdad; uno que se reescribe por sensación oscila
para siempre.
