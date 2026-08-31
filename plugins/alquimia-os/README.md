# alquimia-os

El sistema operativo agéntico de Alquimia. Es la respuesta a una sola pregunta:
**¿qué parte de cómo trabajamos es igual en todos los proyectos?**

## Las tres capas — el criterio para decidir dónde va cada cosa

| Capa | Dónde vive | Qué va aquí | Se comparte |
|---|---|---|---|
| **Universal** | este plugin | Cómo se diagnostica, se revisa, se verifica y se recuerda | Sí, a todos |
| **Personal** | `~/.claude/` | Tus atajos, tu modelo, tus alias | No, es tuyo |
| **Del cliente** | `CLAUDE.md` del repo | Reglas de negocio, comandos, errores pasados | Nunca |

La pregunta al escribir cualquier regla nueva: *¿esto es verdad en los seis proyectos?*
Si sí, va aquí. Si no, va al `CLAUDE.md` de ese repo. Equivocarse hacia arriba
(meter aquí algo específico de un cliente) es peor que equivocarse hacia abajo.

## Qué trae

## Dos modos de trabajo

Un proyecto vive en uno de dos modos, y el riesgo es distinto en cada uno.
Confundirlos es de donde vienen la mayoría de los problemas.

| | **Construir** | **Sostener** |
|---|---|---|
| Qué pasa | No existe todavía | Ya existe y hay que no romperlo |
| El riesgo | Construir la cosa equivocada, o de una forma que estorbe en 6 meses | La regresión: arreglar A y romper B |
| La baraja | `arranque-cero` → `nuevo-proyecto` → `punta-a-punta` → `feature` | `soporte` → `preflight` → `postmortem` |
| La disciplina clave | Decidir a propósito antes de escribir | Test que falla antes del arreglo |

## Agentes

Se invocan con `@agent-alquimia-os:<nombre>` o los delega Claude solo.

| Agente | Para qué | Modo |
|---|---|---|
| `arquitecto` | Opciones y costos de una decisión difícil de revertir | Construir |
| `disenador-ux` | Contexto de uso, flujo, jerarquía y los cinco estados. Antes del primer píxel | Construir |
| `diagnosticador` | Encuentra la causa raíz sin arreglar nada | Sostener |
| `revisor-critico` | Busca defectos en un diff. No felicita | Ambos |
| `guardian-dominio` | Valida contra las reglas de negocio del cliente | Ambos |
| `implementador` | Escribe código en un worktree aislado. **Solo para trabajo en paralelo** | Ambos |
| `interprete` | Traduce entre negocio y código, en las dos direcciones | Ambos |

## Skills

Se invocan con `/alquimia-os:<nombre>`.

| Skill | Para qué | Modo |
|---|---|---|
| `arranque-cero` | Definición, experiencia y decisiones irreversibles. **No escribe código** | Construir |
| `nuevo-proyecto` | Entrevista e instrumenta el repositorio | Construir |
| `punta-a-punta` | El primer flujo completo, con test y despliegue | Construir |
| `feature` | Funcionalidad nueva en un proyecto que ya existe | Construir |
| `soporte` | Reporte de cliente → PR listo para revisión | Sostener |
| `preflight` | Verificación completa antes de mezclar | Ambos |
| `postmortem` | Convierte un fallo en baranda, y decide si es de un repo o de todos | Ambos |
| `memoria` | Sanea los archivos de contexto cuando se inflan | Ambos |
| `replicar` | Audita si un repo cumple el estándar | Ambos |
| `torre` | Qué está esperando tu decisión, en todos los proyectos a la vez | Ambos |
| `revisar` | Revisa un PR sin leer código: te lo explican y traducen tu opinión | Ambos |
| `costos` | Dónde se van los minutos de CI y qué recortar primero | Ambos |
| `stack` | Elige el stack por la forma del problema, no por costumbre ni por moda | Construir |
| `plan` | Convierte un objetivo en `PLAN.md` ejecutable por turnos desatendidos | Ambos |
| `afinar` | Mejora un agente a partir de un fallo real, sin adivinar | Meta |

## Hooks

Corren solos, en todos los proyectos.

| Hook | Cuándo | Qué hace |
|---|---|---|
| `post-edit` | Tras cada edición | Formatea y verifica tipos. Devuelve el error al instante |
| `pre-entrega` | Cuando el agente cree que terminó | Corre la suite. Si falla, lo obliga a seguir |
| `memoria-guard` | Al arrancar la sesión | Avisa si la lectura obligatoria se infló |

## Quién escribe el código

Los agentes de consulta —`arquitecto`, `disenador-ux`, `diagnosticador`,
`revisor-critico`, `guardian-dominio`— tienen `Write` y `Edit` **prohibidos a nivel de
herramienta**. No es una instrucción del prompt: la herramienta no existe para ellos.

**El que implementa es el hilo principal de la sesión.** Es deliberado:

- Tiene el contexto de la conversación: tus correcciones, lo que ya se descartó, el
  matiz que dijiste hace diez mensajes.
- Un solo escritor por tarea. Dos agentes editando los mismos archivos es una tarde
  perdida en conflictos.
- Puedes interrumpirlo y corregirle el rumbo a mitad de camino.
- La baranda `pre-entrega` dispara cuando el hilo principal cree que terminó, así que
  cubre el trabajo sin importar quién lo escribió.

El agente `implementador` existe para el único caso donde eso no alcanza: **varias
tareas avanzando en paralelo sobre el mismo repositorio**. Corre con
`isolation: worktree`, así que cada uno trabaja en su copia y no se pisan.

Para un solo ticket no lo uses. Agrega una frontera de contexto donde se pierde
información —el subagente no hereda la conversación— a cambio de un aislamiento que
no necesitas.

## Los hooks son defensivos a propósito

Corren en repos distintos, así que **detectan antes de actuar**: si el proyecto no
tiene `package.json`, o no define `lint`, o no es TypeScript, el hook sale en silencio
con éxito. Un hook que asume un stack rompe los repos que no lo usan; un hook molesto
se termina desactivando, y entonces no protege a nadie.

Escape por repositorio: crea un archivo vacío `.alquimia-off` en la raíz.

## Convenciones que los hooks esperan

Si tu `package.json` usa estos nombres, los hooks los aprovechan solos:

- `lint` · `typecheck` · `test` (o `test:run` para la corrida no interactiva)

No es obligatorio. Lo que falte, se salta.

## Plantilla de arranque

`plantilla/` tiene `CLAUDE.md`, `REVIEW.md`, `.claude/settings.json`, los workflows de
GitHub y el formato de reporte de cliente. La usa `/alquimia-os:nuevo-proyecto`.

## La capa de UX

`disenador-ux` cubre lo que va **antes** del píxel: contexto de uso, flujo, jerarquía y
los cinco estados. Para el estilo visual concreto —paletas, tipografías, componentes—
delega en `ui-ux-pro-max`, que **viene incluida en este plugin**
(`skills/ui-ux-pro-max/`, MIT, ver su `NOTICE.md`).

Está adentro por una razón concreta: las skills de `~/.claude/skills/` no viajan a las
sesiones de nube ni a las rutinas. Dentro del plugin sí, porque un plugin declarado en
el repositorio se instala al arrancar la sesión. Es Python de biblioteca estándar: no
hay nada que instalar.

## Cómo mejora esto con el tiempo

`evals/` es el corpus: cada caso es un fallo real convertido en prueba. Los cinco que
vienen de fábrica prueban lo más difícil de sostener — **saber parar**: pedir información
cuando falta, escalar una decisión de negocio, no escribir código en la fase de
definición, cubrir los estados que nadie diseña, y respetar una restricción de
herramienta aunque el prompt pida lo contrario.

```bash
claude plugin eval ./plugins/alquimia-os --ablation with-without
```

La ablación corre cada caso dos veces, con el plugin y sin él. **Si el delta es cero,
ese agente no está aportando nada que Claude no hiciera solo.**

`claude plugin eval` está en early access por organización. Si no está habilitado, los
casos siguen sirviendo: se corren a mano contra la versión vieja y la nueva.
El corpus es el activo; el runner solo automatiza el conteo.
