---
description: Activa el statusLine de este plugin en ~/.claude/settings.json (solo hace falta una vez).
---

Tu tarea es habilitar el statusLine del plugin `statusline` en la configuración global de Claude Code del usuario, añadiéndolo a `~/.claude/settings.json` sin tocar el resto de su configuración.

Pasos:

1. Resuelve la ruta absoluta al script del plugin. La variable `${CLAUDE_PLUGIN_ROOT}` apunta a la raíz del plugin instalado; el script vive en `${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh`. Para `~/.claude/settings.json` necesitas la ruta absoluta resuelta (no la variable, porque `${CLAUDE_PLUGIN_ROOT}` solo se expande dentro de configs propias del plugin). Usa Bash para imprimirla:

   ```bash
   echo "$CLAUDE_PLUGIN_ROOT/scripts/statusline.sh"
   ```

2. Lee `~/.claude/settings.json`. Si no existe, créalo como `{}`.

3. Inserta o reemplaza la clave `statusLine` con este objeto, usando la ruta absoluta resuelta en el paso 1:

   ```json
   "statusLine": {
     "type": "command",
     "command": "<ruta-absoluta-resuelta>",
     "padding": 0
   }
   ```

4. Asegúrate de que el script tenga permisos de ejecución:

   ```bash
   chmod +x "$CLAUDE_PLUGIN_ROOT/scripts/statusline.sh"
   ```

5. Confirma al usuario que el statusLine quedó activo y que debe reiniciar Claude Code (o abrir una nueva sesión) para verlo.

Importante:
- No modifiques otras claves de `settings.json`.
- Pregunta al usuario antes de sobrescribir si ya existe un `statusLine` distinto.
