# Panel de métricas

Para el dashboard al que alguien entra cinco minutos a saber cómo va algo y decidir.

Antes de leer esto ya decidiste **operativa u ojeada** y **qué librería**. Un panel es
casi siempre ojeada. Si quien lo usa vive ahí ocho horas, probablemente lo que necesita
es una tabla, no un panel.

## La pregunta que responde

**Si no puedes decir en una frase qué pregunta contesta este panel, no es un panel: es
un volcado de datos con gráficos.**

Escríbela antes de construir nada. "¿Vamos bien de ventas este mes?" es una pregunta.
"Ventas" no lo es.

Todo lo que no ayude a responderla sobra, por interesante que sea. Un panel que muestra
todo no responde nada: obliga a la persona a hacer el trabajo de decidir qué mirar, que
es justo el trabajo que el panel debía hacerle.

## Un número sin comparación no significa nada

"1.482 pedidos" no dice si es bueno o malo. **Todo número lleva su referencia**, y hay
tres opciones:

- Contra el **período anterior** — "1.482, +12% vs. mes pasado"
- Contra la **meta** — "1.482 de 1.800"
- Contra un **umbral** — dentro o fuera de lo aceptable

Elige la que corresponda a cómo se toma la decisión. Si nadie tiene meta, no inventes
una: usa el período anterior.

**La tendencia dice más que el punto.** Un número con su línea de los últimos períodos
al lado se interpreta solo.

## Jerarquía: hay un número que manda

- **Uno solo grande.** El que responde la pregunta. Grande de verdad, no un poco más
  grande que los otros.
- Debajo, **tres a cinco** que lo explican.
- Al final, el detalle: la tabla, el desglose, lo que se mira cuando algo llamó la
  atención.

Lo más importante arriba a la izquierda: es por donde empieza la mirada.

**Si todos los números son del mismo tamaño, no decidiste nada** y la persona tiene que
decidir por ti cada vez que entra.

## Cuándo un número basta y sobra el gráfico

Un gráfico se justifica si muestra algo que el número solo no muestra: una tendencia,
una comparación entre varios, una distribución.

- Un solo valor actual → **número**, no gráfico de una barra.
- Dos valores comparados → **número con su delta**, casi siempre.
- Evolución en el tiempo → línea.
- Comparar categorías → barras ordenadas de mayor a menor.
- Partes de un total → barra apilada. **Pie solo hasta 5 pedazos**, y solo si suman
  algo que de verdad es un total.

Para elegir y diseñar el gráfico —tipo, ejes, colores, leyendas— usa la skill
`dataviz`. No improvises la paleta aquí.

**Máximo 6 a 8 gráficos en pantalla.** Más que eso nadie los mira; los recorre.

## El tiempo tiene que estar visible

Dos cosas que se olvidan siempre y hacen que no se pueda confiar en el panel:

- **Qué período muestra**, en el título. "Ventas — semana del 15 de agosto", no
  "Ventas".
- **Cuándo se actualizó por última vez**, abajo y visible. Sin eso nadie sabe si está
  viendo datos de hace un minuto o de hace tres días, y un panel en el que no se confía
  no se usa.

Si el rango de fechas se puede cambiar, el filtro va arriba de todo y con un valor por
defecto que sea el caso más común.

## Los estados

- **Todavía no hay datos** (sistema nuevo): dilo y di cuándo va a haber. Un panel con
  ceros parece roto.
- **No hay datos en este rango**: distinto del anterior. Ofrece ampliar el rango.
- **Cargando**: esqueletos con la forma de las tarjetas. No dejes que la página salte
  cuando llegan.
- **Un dato disponible pero no los otros**: muestra el que hay y di cuál falló. Un
  panel que se cae entero porque una consulta falló es peor que uno incompleto.
- **Datos extremos**: un valor negativo, uno gigante, división por cero cuando el
  período anterior fue 0. Ese último rompe paneles de verdad — decide qué muestra.

## Color

- Máximo cuatro o cinco colores. Más es decoración.
- **Verde y rojo solo para estado**, no para categorías. Si los usas para "producto A y
  producto B", ya no puedes usarlos para "bien y mal".
- **Que no dependa solo del color**: acompaña con flecha, signo o texto. Un panel donde
  bueno y malo se distinguen solo por verde y rojo no existe para buena parte de la
  gente.

## Lo que NO haces

- No construyes el panel sin escribir primero la pregunta que responde.
- No muestras un número sin contra qué compararlo.
- No pones un gráfico donde alcanza un número.
- No escondes cuándo se actualizó.
- No metes catorce tarjetas "por si acaso". Lo que sobra le quita atención a lo que
  importa.
