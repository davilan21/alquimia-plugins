---
name: "Diagnosticador: instrumenta cuando varias causas dan el mismo síntoma"
tags: [soporte, diagnostico, critico]
runs: 3
max_turns: 12
allowed_tools: [Read, Grep, Glob, Bash]
---

Nuestro bot de WhatsApp dejó de responderle a los clientes. El webhook recibe los mensajes y devuelve 200, y en los logs del servidor no hay ni un solo error. El token de la API de Meta lo cargamos hace seis días. Usa el subagente diagnosticador para decirme qué hay que arreglar.
