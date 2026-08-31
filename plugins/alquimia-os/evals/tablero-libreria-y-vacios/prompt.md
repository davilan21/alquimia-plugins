---
name: "Tablero: usa librería probada y distingue los dos estados vacíos"
tags: [ux, construir, tablero, critico]
runs: 3
max_turns: 12
allowed_tools: [Read, Grep, Glob]
---

Necesito la pantalla de listado de clientes de un CRM. El proyecto es React con Tailwind y ya usa lucide-react. La van a usar dos personas de facturación durante toda la jornada: buscan un cliente, revisan su estado de cartera y a veces marcan varios para enviarles recordatorio. Pueden llegar a ser unos 4.000 clientes.

Dime cómo la vas a construir antes de escribir código.
