---
description: Diseña y construye superficies de datos — tablas, bandejas de conversaciones, paneles, fichas y formularios de CRM o ERP. Úsala ANTES de escribir la pantalla. Elige la librería probada en vez de construir desde cero.
---

# Superficies de datos

Superficie a construir (si no se indica, dedúcela del contexto y **dilo en voz alta
antes de seguir**):

$ARGUMENTS

## Regla dura: esto no se construye desde cero

Una tabla de datos de verdad necesita ordenar, filtrar, paginar, virtualizar, navegar
con teclado, redimensionar columnas y anunciarse a un lector de pantalla. Eso son
semanas de trabajo que alguien ya hizo mejor, y que además ya está probado por miles
de proyectos.

**Si te encuentras escribiendo la lógica de ordenamiento de una tabla, para.** Estás
reimplementando una librería. Lo mismo aplica a la virtualización de una lista larga,
al foco de un modal, o al manejo de un formulario con validaciones.

Lo que sí escribes tú es el **criterio**: qué columna manda, qué dice la pantalla
vacía, contra qué se compara un número. Eso no viene en ningún paquete.

## Las tres decisiones, en este orden

### 1. ¿Quién está del otro lado?

Esta decisión cambia todo lo demás, y son dos mundos distintos:

| | **Operativa** | **Ojeada** |
|---|---|---|
| Quién | Personal que vive adentro 8 horas | Alguien que entra 5 minutos a decidir |
| Manda | Densidad, velocidad de escaneo, no equivocarse | Jerarquía, una respuesta clara, cero ruido |
| Teclado | Obligatorio. Se navega sin soltar las manos | Opcional |
| Cantidad | Toda la que haya. Se filtra, no se esconde | Lo mínimo que responda la pregunta |
| Exportar | Siempre. Van a querer sacarlo a Excel | Casi nunca |

**Si no lo sabes, pregúntalo.** No lo adivines: una tabla operativa diseñada como
ojeada es inservible para quien la usa todo el día, y al revés es un muro de números
para quien solo quería una respuesta.

### 2. ¿Qué librería?

Antes de elegir, **mira el `package.json` del proyecto**: lo que ya está instalado
gana sobre lo que sería ideal. Una librería más es una librería que mantener.

Defaults cuando no hay nada instalado y el stack es React + Tailwind:

| Necesitas | Usa | Por qué |
|---|---|---|
| Tabla de datos | **shadcn/ui `data-table`** (TanStack Table por dentro) | Se copia al repo, no es dependencia opaca. Headless: el estilo es tuyo |
| Componentes base | **shadcn/ui** | Si el proyecto ya tiene Tailwind + `lucide-react`, ya es su stack |
| Gráficos | **Recharts** | Declarativo, encaja con React sin ceremonia |
| Formularios | **react-hook-form + zod** | La validación se escribe una vez y sirve para el tipo y para el mensaje |
| Lista muy larga | **TanStack Virtual** | Solo si de verdad pasas de ~200 filas visibles |

Para el detalle de shadcn/ui —instalación, composición, temas— usa la skill `shadcn`.
Para elegir y diseñar un gráfico, usa la skill `dataviz`. Para paletas y tipografía,
`ui-ux-pro-max`. No dupliques lo que esas ya dicen.

**Anuncia la librería que elegiste y por qué, antes de instalar nada.** Si el proyecto
es de un cliente, agregar una dependencia es una decisión que se justifica en el PR.

### 3. El criterio, que es lo que sigue

Abre **solo** el archivo de tu superficie. Los demás no los necesitas:

| Estás construyendo | Abre |
|---|---|
| Lista de registros: usuarios, clientes, facturas, casos | `superficies/tabla.md` |
| Bandeja de conversaciones, chats, tickets | `superficies/bandeja.md` |
| Panel de métricas para decidir | `superficies/panel.md` |
| La pantalla de un registro con su historia | `superficies/ficha.md` |
| Captura o edición de datos | `superficies/formulario.md` |

Si la pantalla es dos cosas a la vez —una tabla que abre una ficha al lado—, lee las
dos y dilo. No mezcles a ojo.

## Lo que aplica a todas

- **Los cinco estados no son opcionales**: vacío, cargando, error, un solo dato, y
  demasiados datos. El agente `disenador-ux` los define; aquí se implementan. Una
  pantalla sin estado vacío es la forma más rápida de que alguien crea que se dañó.
- **Todo número que cambia lleva `tabular-nums`.** Sin eso las cifras bailan al
  actualizarse y la columna se ve rota.
- **Nada depende solo del color.** Un estado que solo se distingue por rojo o verde no
  existe para quien no los diferencia, y son más de los que crees.
- **Si el sistema se usa 8 horas al día, esto es salud laboral**, no cumplimiento.

## Lo que NO haces aquí

- No eliges paleta ni tipografía. Eso es `ui-ux-pro-max`.
- No decides el flujo ni los estados. Eso es `disenador-ux`, y va antes.
- No construyes la superficie sin saber cuál de los dos mundos es.
- No instalas una librería sin mirar primero qué hay instalado.
