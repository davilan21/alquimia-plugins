# alquimia-plugins

El marketplace de Alquimia. Un solo lugar donde vive **cómo se trabaja**, para que los
6 proyectos hereden el mismo estándar sin copiar carpetas a mano.

## Instalar (una vez por máquina)

```bash
claude plugin marketplace add davilan21/alquimia-plugins
claude plugin install alquimia-os@alquimia
```

Si el repo es privado, autentica git primero: `gh auth setup-git`.

## Instalar por proyecto (lo que hereda cualquiera que clone)

En `.claude/settings.json` del repositorio del cliente:

```json
{
  "extraKnownMarketplaces": {
    "alquimia": { "source": { "source": "github", "repo": "davilan21/alquimia-plugins" } }
  },
  "enabledPlugins": { "alquimia-os@alquimia": true }
}
```

## Actualizar todos los proyectos a la vez

```bash
# en el repo del plugin
# 1. haces el cambio
# 2. subes la version en plugins/alquimia-os/.claude-plugin/plugin.json
# 3. git push

# en cualquier máquina
claude plugin marketplace update alquimia
```

Ese es el punto entero: **un cambio aquí llega a los seis proyectos.**

## Probar antes de publicar

```bash
claude --plugin-dir ./plugins/alquimia-os
claude plugin validate ./plugins/alquimia-os
```
