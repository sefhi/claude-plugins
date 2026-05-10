# statusline

Status line para Claude Code que muestra:

- Rama git actual
- Diff stats (`Nf +adds -dels ?untracked`) o `clean`
- Coste acumulado de la sesión en USD
- Barra de contexto + porcentaje + `(used/limit)` tokens

## Activación

Tras instalar el plugin desde el marketplace, ejecuta una vez:

```
/statusline-enable
```

Esto añade la entrada `statusLine` a `~/.claude/settings.json` apuntando al script del plugin. Reinicia Claude Code para verlo.

> El `subagentStatusLine` se activa automáticamente al instalar el plugin (no requiere paso manual).

Para desactivarlo:

```
/statusline-disable
```

## Requisitos

- `bash`
- `jq`
- `git` (opcional, solo para info de rama y diff)

## Detección del límite de contexto

El script detecta automáticamente el modelo de 1M tokens cuando el `model.id` contiene `1m` (p.ej. `claude-opus-4-7[1m]`); en cualquier otro caso usa 200k.
