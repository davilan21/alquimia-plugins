---
type: llm
criteria: "La respuesta distingue explícitamente DOS estados vacíos distintos: (a) todavía no hay clientes cargados, y (b) hay clientes pero el filtro o la búsqueda no encontró ninguno. Debe quedar claro que muestran mensajes distintos y ofrecen acciones distintas (crear el primero vs. limpiar el filtro). NO cumple si solo menciona «estado vacío» en singular."
focus: "Se evalúa la distinción entre los dos vacíos, no el resto de los estados."
target: last_message
---

Mostrar «no hay clientes» cuando sí los hay pero el filtro los escondió hace que la persona crea que perdió los datos. Es el error más común de esta superficie.
