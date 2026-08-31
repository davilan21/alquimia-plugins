# Tabla de registros

Para listas de usuarios, clientes, facturas, casos, movimientos. La superficie que
aparece en todo CRM y todo ERP.

Antes de leer esto ya decidiste **operativa u ojeada** y **qué librería**. Si no,
vuelve al `SKILL.md`.

## La columna que ancla

De todas las columnas, hay **una** por la que la persona busca cuando escanea: el
nombre del cliente, el número de la factura, la cédula. No es la llave de la base de
datos; es cómo esa fila se llama en la cabeza de quien la busca.

Esa columna va **primera, a la izquierda, y con más peso visual** que las demás. Es lo
único que sostiene el escaneo vertical.

Si no sabes cuál es, pregúntalo así: *"si alguien te dice un registro por teléfono,
¿qué dato te da?"*. Esa es la columna.

## Alineación: no es estética, es velocidad

- **Números a la derecha**, siempre. Alineados a la derecha las unidades quedan bajo
  las unidades y las decenas bajo las decenas, y el ojo compara magnitudes sin leer.
  Alineados a la izquierda hay que leer cada uno.
- **Números con `tabular-nums`.** Sin eso cada dígito tiene ancho distinto, la columna
  se mueve al actualizarse y se pierde la alineación que acabas de ganar.
- **Texto a la izquierda.** Centrado solo si es una sola palabra corta y siempre.
- **Fechas**: un solo formato en toda la tabla, y que ordene bien. Si la fila importa
  por lo reciente, muestra "hace 3 días" pero deja la fecha exacta al pasar el mouse.
- **Cada columna tiene UNA alineación.** Mezclar dentro de la misma columna rompe el
  escaneo entero.

## Densidad: se decide, no se hereda

Di el número en píxeles y aplícalo parejo:

- **Operativa**: 8–12px de relleno vertical. Apretado a propósito. Quien vive ahí
  quiere ver treinta filas sin bajar, no doce cómodas.
- **Ojeada**: 14–20px. Menos filas, más aire, se lee de un vistazo.

**Separa las filas con espacio y tono antes que con líneas.** Una tabla con borde en
cada celda es una reja: las líneas compiten con los datos por la atención. Si necesitas
separación, un cambio sutil de fondo hace más y estorba menos.

## Los cinco estados — y el que casi nadie hace

**Vacío es dos pantallas distintas, no una.** Este es el error más común de todos:

| Situación | Qué dice | Qué ofrece |
|---|---|---|
| **Todavía no hay nada** | "Aún no tienes clientes" | El botón para crear el primero |
| **El filtro no encontró nada** | "Ningún cliente coincide con «juan» en estado Activo" | **Limpiar el filtro** |

Mostrar "no hay clientes" cuando sí los hay pero el filtro los escondió hace que la
persona crea que perdió los datos. Repite el criterio de búsqueda en el mensaje: le
dice qué buscó, que casi siempre es donde está el error.

Los otros tres:

- **Cargando**: un esqueleto con la forma de las filas y la altura real que van a
  tener. Un spinner en el medio hace que la página salte cuando llegan los datos.
- **Error**: qué pasó y qué puede hacer. "Error 500" no es ninguna de las dos.
- **Datos extremos**: un nombre de 90 caracteres, un monto de diez cifras, un campo
  vacío. Pruébalos antes de dar la tabla por hecha; van a llegar.

## Orden por defecto

Toda tabla llega ordenada por algo. **Elígelo, no lo dejes al azar de la base de
datos.**

Casi siempre: lo más reciente arriba. Si el trabajo es una cola —casos por atender,
facturas por aprobar— entonces manda la urgencia, no la fecha.

Y deja ver por dónde está ordenada. Una tabla ordenada sin indicarlo se siente
desordenada.

## Truncado y desbordamiento

Un nombre largo no puede romper la fila ni empujar las columnas.

- Corta con `…` al final y deja el texto completo al pasar el mouse.
- **Nunca truques la columna ancla si con eso se vuelve ambigua.** Dos clientes que se
  ven igual truncados es peor que una columna más ancha.
- Números **nunca** se truncan. Se abrevian con criterio (`1,2 M`) o se muestran
  completos.

## Cuántas filas: los umbrales

| Filas | Qué haces |
|---|---|
| Hasta ~100 | Todas de una. Ni pagines ni virtualices; no hace falta |
| ~100 a ~1.000 | Paginar, o scroll con encabezado fijo |
| Más de ~1.000 | **Virtualizar** (TanStack Virtual). Y filtrar en el servidor, no en el navegador |

En operativa, **scroll infinito no**: quien trabaja ahí necesita saber cuántos van y
poder volver al mismo punto. Paginación con total visible ("312 de 4.019").

## Acciones: por fila y masivas

- **Por fila**: máximo dos visibles; el resto en un menú. Una fila con seis botones es
  ruido en cada una de las trescientas filas.
- **La acción destructiva nunca es la primera** ni queda pegada a la común. Borrar al
  lado de editar es un accidente esperando.
- **Masivas** (solo operativa): seleccionar con casilla, y una barra que aparece al
  seleccionar diciendo **cuántos** ("3 seleccionados"). Que el número sea explícito es
  lo que evita el desastre de aplicar algo a 400 en vez de a 4.
- **Deshacer vale más que confirmar.** Si la acción se puede revertir, hazla y ofrece
  deshacer por unos segundos. Es más rápido de usar y más seguro que un "¿está seguro?"
  que la gente aprende a aceptar sin leer.

## Exportar

En operativa, **siempre**. Van a querer sacarlo a Excel, y si no se lo das lo van a
copiar y pegar mal.

Exporta **lo que está filtrado, no toda la tabla** — y dilo en el botón o en el
archivo. Que alguien exporte creyendo que lleva su filtro y se lleve 10.000 filas es
un problema real.

## El piso de accesibilidad

- Encabezados de verdad (`<th>` con su ámbito), no celdas con negrilla. De eso depende
  que un lector de pantalla pueda decir "columna Monto, fila 12".
- Se navega con teclado: tabular entre acciones, foco visible siempre.
- El estado no puede vivir solo en el color: acompáñalo de texto o ícono.
- Si la tabla se ordena al hacer clic, el encabezado es un botón y anuncia el orden.

## Lo que NO haces

- No escribes la lógica de ordenar, filtrar o paginar. Esa es la librería.
- No dejas la tabla sin estado vacío "porque siempre va a tener datos". No siempre.
- No metes doce columnas porque existen doce campos. Pregunta cuáles se usan; las
  demás viven en la ficha.
- No pones scroll horizontal en operativa sin fijar la columna ancla. Se pierde de
  vista qué fila se está leyendo.
- No inventas la densidad fila por fila. Se decide una vez, arriba.
