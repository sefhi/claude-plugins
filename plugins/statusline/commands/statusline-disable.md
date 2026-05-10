---
description: Quita el statusLine del plugin de ~/.claude/settings.json.
---

Tu tarea es eliminar la clave `statusLine` de `~/.claude/settings.json` si apunta al script de este plugin.

Pasos:

1. Lee `~/.claude/settings.json`. Si no existe, informa al usuario y termina.
2. Si la clave `statusLine.command` contiene `claude-plugins/plugins/statusline/scripts/statusline.sh`, elimínala.
3. Si apunta a otro script, pregunta al usuario antes de tocar nada.
4. Confirma el cambio y recuerda al usuario que debe reiniciar Claude Code.
