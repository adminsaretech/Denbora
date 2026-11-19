# Revisión visual y navegación de Tempo

Revisión de las capturas facilitadas el 19-11-2026. Las imágenes se usaron para
entender la jerarquía y las tareas del usuario; Tempo mantiene su marca, paleta,
iconografía y componentes propios.

## Error observado

En una captura de Tempo aparece la excepción de Flutter:

> No MaterialLocalizations found. AppBar widgets require MaterialLocalizations
> to be provided by a Localizations widget ancestor.

La excepción apunta al `AppBar`; el rótulo `DEBUG` solo identifica una versión de
depuración y no es el fallo. El proyecto usa `material_ui`, cuya implementación
de `MaterialLocalizations` no coincide con los delegados Flutter estándar que
genera `gen-l10n`. La configuración explícita de delegados para Tempo ahora
incluye la implementación compatible de `material_ui`, separada del código
generado, y una prueba recorre la navegación hasta la biblioteca de rutinas.

## Estructura que se adopta

La referencia organiza los accesos en cuatro destinos. Tempo conserva esa
estructura y la orienta a las tareas más frecuentes:

| Destino | Uso principal | Acción destacada |
|---|---|---|
| Tabata | Ajustar una sesión corta por intervalos | Cambiar trabajo, descanso y rondas; consultar duración; iniciar |
| Rondas | Buscar, ordenar, crear y gestionar rutinas | Abrir una plantilla o una rutina guardada |
| Cronómetro | Empezar una sesión sin intervalos | Iniciar el cronómetro libre |
| Más | Llegar a historial y preferencias | Abrir historial o ajustes |

La barra inferior permanece visible en las cuatro áreas. Las pantallas visitadas
conservan su estado al cambiar de destino. Las tareas de historial y ajustes
quedan agrupadas en «Más», así se reserva espacio de navegación para Tabata,
Rondas y Cronómetro.

## Ajustes de usabilidad

- El botón principal del onboarding queda anclado bajo el contenido desplazable,
  para que se vea en pantallas compactas y el texto pueda seguir desplazándose.
- Los controles de Tabata usan botones grandes para subir o bajar los valores,
  muestran unidades y resumen la duración antes de iniciar. Estos cambios se
  aplican solo a esa sesión; las rutinas que el usuario guarda se administran
  desde Rondas.
- La pantalla de Cronómetro explica su propósito y abre el mismo motor de sesión
  que usa el resto de la app.
- «Más» usa filas táctiles claras para historial y ajustes, y muestra en una sola
  frase que Tempo funciona sin cuenta, anuncios ni compras.
- Se mantienen temas claro/oscuro, colores con contraste, etiquetas para los
  controles y textos localizados en español e inglés.

## Comprobaciones

- Prueba de widget: el botón de onboarding queda dentro del área visible en una
  pantalla de 360 × 640.
- Prueba de widget: las cuatro pestañas aparecen; Tabata actualiza sus valores;
  Cronómetro y Más abren sus acciones principales.
- Prueba de widget: abrir Rondas no produce la excepción de localización y carga
  las plantillas.
- La generación de localizaciones se ha ejecutado; Tempo conserva sus delegados
  Material compatibles fuera de los archivos generados.

Las comprobaciones automatizadas no reemplazan la inspección de contraste y
lectura con VoiceOver/TalkBack ni la validación visual en varios tamaños reales.

