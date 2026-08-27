# ui-ux-pro-max — copia vendorizada

Esta skill NO es de Alquimia. Es una copia de
[ui-ux-pro-max](https://github.com/NextLevelBuilder/ui-ux-pro-max) (MIT,
© 2024 Next Level Builder). El texto de la licencia está en `LICENSE`.

## Por qué está aquí

Las skills de `~/.claude/skills/` **no viajan a las sesiones de nube ni a las rutinas**.
Como la fase de diseño tiene que funcionar igual en la nube que en la máquina, la copia
vive dentro del plugin: los plugins declarados en el repositorio sí se instalan al
arrancar una sesión de nube.

## Cómo se invoca

- Desde el plugin: `/alquimia-os:ui-ux-pro-max`
- Si además la tienes instalada localmente: `/ui-ux-pro-max`

Las dos conviven. El agente `disenador-ux` usa la que encuentre.

## Cómo se actualiza

Es una copia, así que no se actualiza sola. Cada tanto:

```bash
git -C ~/ui-ux-pro-max-skill pull
cp ~/ui-ux-pro-max-skill/.claude/skills/ui-ux-pro-max/SKILL.md \
   plugins/alquimia-os/skills/ui-ux-pro-max/SKILL.md
cp -r ~/ui-ux-pro-max-skill/src/ui-ux-pro-max/{scripts,data} \
   plugins/alquimia-os/skills/ui-ux-pro-max/
```

No la edites acá: los cambios se pierden en la próxima actualización. Si quieres
ajustarla a tu criterio, ponlo en `disenador-ux`, que es tuyo.
