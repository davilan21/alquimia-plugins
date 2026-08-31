# Ficha de un registro

La pantalla de un cliente, un caso, una factura. A donde lleva el clic desde la tabla.

Antes de leer esto ya decidiste **operativa u ojeada** y **qué librería**.

## Lo primero que se ve responde tres preguntas

Sin bajar, sin abrir nada:

1. **¿Qué es esto?** — el nombre por el que la persona lo conoce, grande y arriba.
2. **¿En qué va?** — el estado, visible, con texto y no solo color.
3. **¿Qué puedo hacer?** — la acción principal, una sola, evidente.

Todo lo demás puede estar más abajo. Si para saber en qué estado está un caso hay que
bajar o abrir una pestaña, la ficha está mal armada.

## No vuelques todos los campos

Que la tabla de la base de datos tenga cuarenta columnas no significa que la ficha
tenga cuarenta filas.

Pregunta cuáles se **miran** y cuáles solo se **guardan**. Los que se miran van
arriba, agrupados por tema. Los que solo se guardan van en una sección plegada al
final, o no van.

Una ficha con todo se lee igual de mal que una tabla con todo: la persona tiene que
buscar entre lo que no le importa.

## La línea de tiempo es la mitad del valor

En un CRM o un ERP, la pregunta real casi nunca es "¿cuáles son los datos?" sino
**"¿qué ha pasado con esto?"**.

- Ordenada de lo más reciente a lo más viejo.
- Cada entrada dice **qué pasó, quién y cuándo**. Las tres. "Estado cambiado" sin quién
  no sirve para nada cuando hay que reconstruir un problema.
- Distingue lo que hizo una persona de lo que hizo el sistema.
- Agrupa por día, y usa "hace 2 horas" para lo reciente con la fecha exacta al pasar el
  mouse.
- Si la historia es larga, se pagina o se filtra por tipo. No se carga entera.

**Los comentarios y los cambios van en la misma línea de tiempo**, no en pestañas
separadas. Separarlos obliga a mirar dos sitios para entender un episodio.

## Editar: en el sitio o en formulario

Dos caminos, y la decisión es por consecuencia:

- **En el sitio** (clic en el campo y se edita ahí): para campos sueltos, reversibles,
  de bajo costo. Rápido, y quien trabaja ahí lo agradece.
- **En formulario**: cuando los campos dependen unos de otros, cuando hay validación
  cruzada, o cuando el cambio es caro de revertir. Para eso ve a
  `superficies/formulario.md`.

**No mezcles los dos modos en la misma pantalla sin que se note.** Si unos campos se
editan al clic y otros no, la persona no sabe cuáles.

Si editas en el sitio: se guarda solo, se ve que se guardó, y si falla se dice y se
conserva lo que escribió. Un guardado silencioso que falló es peor que no tener
guardado automático.

## Lo relacionado

Un cliente tiene facturas; un caso tiene mensajes. Eso va como **lista corta con lo
más reciente y un enlace a la lista completa**, no como una tabla entera embebida.

Si son más de cinco o seis, muestra los últimos y di cuántos hay en total.

## Los estados

- **Cargando**: esqueleto con la forma real. La ficha es la pantalla donde más se nota
  un salto de layout, porque el nombre de arriba cambia de tamaño.
- **No existe**: puede ser que se borró, que nunca existió, o que el enlace está mal.
  Di cuál y ofrece volver a la lista.
- **Sin permiso**: distinto de "no existe". Decir "no existe" cuando en realidad no
  tiene permiso confunde a quien sí debería verlo; decir "no tienes permiso" cuando no
  existe filtra información. Elige según lo que maneje el sistema, y sé consistente.
- **Borrado o anulado**: no lo escondas, muéstralo marcado y sin las acciones. Un
  registro que desaparece sin explicación se siente como un error del sistema.
- **Sin historia todavía**: "aún no ha pasado nada con este caso", no una línea de
  tiempo vacía.

## Volver a donde estaba

Quien llega desde una tabla filtrada y ordenada espera **volver a esa misma tabla**,
con su filtro, su orden y su página. Perder eso obliga a rehacer el trabajo en cada
registro que revisa, y en una jornada eso son cien veces.

Si se pueden recorrer varios registros seguidos, unas flechas de anterior y siguiente
que respeten el orden de la lista valen mucho.

## Lo que NO haces

- No escondes el estado debajo del pliegue.
- No pones cuarenta campos porque existen cuarenta.
- No separas comentarios de cambios en pestañas distintas.
- No pierdes el filtro de la tabla al volver.
- No dejas la acción destructiva al lado de la principal.
