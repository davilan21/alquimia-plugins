# Arrancar un proyecto nuevo

Qué usar y cuándo, entre lo propio (`alquimia-os`) y lo de terceros (`wshobson/agents`
y el plugin de `vercel`). El orden importa más que las herramientas.

## Antes de nada: hay tres audiencias, no una

| Quién | Qué toca | Cómo le llega el estándar |
|---|---|---|
| Tú y el equipo | Claude Code en su máquina | Configuración personal + este documento |
| **El cliente** | Un formulario de GitHub o el bot. Nunca abre Claude Code | **Solo lo que esté en el repositorio** |
| Las rutinas y sesiones de nube | Nada. No hay nadie configurando | **Solo lo que esté en el repositorio** |

De ahí sale la regla que gobierna todo lo demás:

> **Si el estándar depende de que alguien configure su máquina, el camino autónomo
> queda por fuera — y ese camino es el propósito del proyecto.**

Por eso lo que es de la casa vive en `plantilla/.claude/settings.json`, versionado. Lo
que es preferencia personal vive en `~/.claude/settings.json` y no se le impone a nadie.

## Las seis fases

### 1. Definición — antes de una sola línea de código

```
/alquimia-os:arranque-cero
```

Produce alcance, decisiones irreversibles y el plan del primer flujo. **No genera
código**, y esa es la parte que importa.

Dentro de esa fase, delega:

- `/alquimia-os:stack` — elegir el stack por la forma del problema, no por costumbre.
- Subagente **`arquitecto`** — para cada decisión difícil de revertir. Lo primero que
  hace es decirte si de verdad es irreversible; la mayoría no lo es.
- Subagente **`disenador-ux`** — el flujo y los cinco estados, antes de que exista una
  pantalla.

**Aquí no entra nada de terceros.** Esta fase es criterio de la casa y de dominio del
cliente. Ningún plugin genérico sabe qué es irreversible en facturación DIAN.

### 2. Instrumentar el repositorio

```
/alquimia-os:nuevo-proyecto
./scripts/preparar-repo.sh davilan21/<repo>
```

El primero deja `CLAUDE.md`, `REVIEW.md`, `.claude/settings.json`, la plantilla de
soporte del cliente y los workflows. El segundo crea las etiquetas que usan `torre` y
`soporte`.

**El piso de infraestructura, en este orden:**

1. **CI que corra los tests en cada PR.** Antes que cualquier otra cosa.
2. `.env.example` — el contrato de qué hace falta para levantar el proyecto.
3. Decidir **dónde viven los secretos** (GitHub o el proveedor) y que sea uno solo.
4. Recién ahí, los workflows de Claude.

> **Primero CI, después Claude.** Un repositorio con revisión automática de Claude pero
> sin tests corriendo tiene el orden invertido: la opinión de un agente pasó a ser la
> única barrera. Para auditar esto en un repo existente: `/alquimia-os:replicar`.

### 3. El primer flujo, de punta a punta

```
/alquimia-os:punta-a-punta
```

Un solo camino que atraviesa todas las capas, con test de humo y desplegado. Multiplicar
a lo ancho después es barato; antes es apostar.

### 4. Construir

```
/alquimia-os:feature
```

Y para cualquier pantalla de datos —tabla, bandeja, panel, ficha, formulario—:

```
/alquimia-os:tablero
```

**Aquí sí entra lo de terceros**, y solo aquí: `alquimia-os` es proceso y dominio, no
tiene contenido de ningún lenguaje. Ese hueco lo llenan otros:

| Necesitas | Usa | Dónde se enciende |
|---|---|---|
| Next.js, React, Turbopack, shadcn | plugin `vercel` | Global — ya está encendido |
| Accesibilidad, WCAG, lectores de pantalla | `accessibility-compliance` | **En la plantilla** — le llega a todos |
| Python a fondo (16 skills) | `python-development@claude-code-workflows` | **Solo en el repo que sea Python primario** |
| Postgres / PLpgSQL | `database-design` | Global — ya está encendido |

**Lo que NO se enciende, y por qué:**

- `backend-development` — habla de CQRS, event sourcing, microservicios y sagas. Es
  vocabulario de escala empresarial y sesga en contra de lo que el `arquitecto` busca:
  menos piezas, nada construido para una escala que no existe.
- `frontend-mobile-development` — su contenido apunta a Next.js 14/15 y sus agentes se
  auto-invocan. El plugin de `vercel` cubre lo mismo, al día y mantenido por ellos.
- `javascript-typescript` — casi todo es *"Master ES6+"*: conocimiento que el modelo ya
  tiene, empaquetado como skill.
- `ui-design` — se pisa con `ui-ux-pro-max` y con `tablero`.

### 5. Revisar

```
/alquimia-os:revisar     # te lo explica en lenguaje de negocio, sin leer código
/alquimia-os:preflight   # verificación completa antes de mezclar
```

Y el subagente **`revisor-critico`**, que empieza por datos y permisos: consultas sin
filtro de tenant, datos sensibles en logs, dinero en punto flotante.

**Si vas a usar varios revisores, que cada uno mire una dimensión distinta.** Dos
revisores genéricos sobre el mismo diff no duplican la confianza: duplican el punto
ciego. Dimensiones disponibles hoy:

| Dimensión | Quién |
|---|---|
| Datos, permisos, corrección, reversibilidad | `revisor-critico` (propio) |
| Fallas silenciosas, diseño de tipos, cobertura | `pr-review-toolkit` (encendido) |
| Accesibilidad | `accessibility-compliance` (en la plantilla) |
| React / TSX | `vercel:react-best-practices` |

### 6. Sostener

| Cuando | Usa |
|---|---|
| Llega un reporte de cliente | `/alquimia-os:soporte` |
| Quieres saber qué espera tu decisión | `/alquimia-os:torre` |
| Algo se rompió | `/alquimia-os:postmortem` |
| El CI se disparó de precio | `/alquimia-os:costos` |
| Las sesiones arrancan lentas | `/alquimia-os:memoria` |
| Auditar un repo contra el estándar | `/alquimia-os:replicar` |

## Cómo se decide si un plugin nuevo entra

Un plugin vale la pena **solo si aporta una de estas tres**:

1. **Aislamiento de contexto** — explora muchos archivos y devuelve la conclusión.
2. **Restricción de herramientas** — p. ej. un revisor que no puede escribir.
3. **Procedimiento que el modelo no sigue por defecto** — TDD, causa raíz antes del fix.

**«Eres un experto en X» no es ninguna de las tres.** Es una persona de rol: mismo
modelo, mismo resultado, distinto preámbulo. Y cada plugin encendido se inyecta en
todas las sesiones y diluye la selección. Ante la duda, no se enciende.

Regla práctica al mirar un plugin ajeno: **las skills suelen ser procedimiento, los
agentes suelen ser persona de rol.** Se puede encender un plugin por sus skills sabiendo
que sus agentes sobran — pero si esos agentes dicen *"Use PROACTIVELY"*, se meten solos
y ya no sobran: estorban.

## Dónde va cada cosa

| Nivel | Qué | Quién lo recibe |
|---|---|---|
| `plantilla/.claude/settings.json` **de este plugin** | El estándar de la casa | Todo proyecto nuevo, el equipo, el bot, las rutinas |
| `.claude/settings.json` **del repo del cliente** | Lo que solo ese proyecto necesita | Quien trabaje ese repo |
| `~/.claude/settings.json` | Preferencia personal | Solo esa persona. **No se le impone al equipo** |
