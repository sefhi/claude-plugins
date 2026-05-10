# claude-plugins

Marketplace personal de plugins para [Claude Code](https://docs.claude.com/claude-code). Hooks, comandos y skills que reutilizo en todos mis proyectos.

## Plugins disponibles

| Plugin | Descripción |
| --- | --- |
| [`statusline`](./plugins/statusline) | Status line con rama git, diff stats, coste de sesión y barra de contexto. |

## Instalación

### 1. Añadir el marketplace

En cualquier sesión de Claude Code:

```
/plugin marketplace add sefhi/claude-plugins
```

> También funciona con la URL completa: `/plugin marketplace add https://github.com/sefhi/claude-plugins`

### 2. Instalar un plugin

```
/plugin install statusline@sefhi-plugins
```

Listar lo que ya tienes instalado:

```
/plugin list
```

### 3. Activar el plugin (si aplica)

Algunos plugins necesitan un paso de activación. Por ejemplo, `statusline`:

```
/statusline-enable
```

Esto parchea `~/.claude/settings.json` automáticamente; solo hay que hacerlo una vez por máquina.

## Mantenimiento

```
# Actualizar el marketplace a su última versión
/plugin marketplace update sefhi-plugins

# Quitar un plugin
/plugin uninstall statusline@sefhi-plugins

# Quitar el marketplace entero
/plugin marketplace remove sefhi-plugins
```

## Estructura del repositorio

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json        # Manifest del marketplace
└── plugins/
    └── statusline/
        ├── .claude-plugin/
        │   └── plugin.json     # Manifest del plugin
        ├── settings.json       # subagentStatusLine (auto-activo)
        ├── commands/           # Slash commands del plugin
        ├── scripts/            # Scripts ejecutables
        └── README.md
```

## Añadir un nuevo plugin

1. Crea `plugins/<nombre>/.claude-plugin/plugin.json` con `name`, `description`, `version`.
2. Añade los recursos del plugin en las carpetas convencionales:
   - `commands/` → slash commands (Markdown con frontmatter `description`).
   - `agents/` → subagentes.
   - `skills/<skill>/SKILL.md` → skills.
   - `hooks/hooks.json` → hooks.
   - `scripts/` → ejecutables auxiliares.
3. Registra el plugin en `.claude-plugin/marketplace.json` dentro del array `plugins`.
4. Valida con `/plugin validate .` desde la raíz del repo.

Variables útiles dentro de configs del plugin:

- `${CLAUDE_PLUGIN_ROOT}` → ruta absoluta del plugin instalado.
- `${CLAUDE_PLUGIN_DATA}` → directorio de datos persistente entre actualizaciones.

## Referencias

- [Plugin marketplaces](https://docs.claude.com/claude-code/plugin-marketplaces)
- [Plugins reference](https://docs.claude.com/claude-code/plugins-reference)
- [Status line](https://docs.claude.com/claude-code/statusline)

## Licencia

MIT — ver [LICENSE](./LICENSE).
