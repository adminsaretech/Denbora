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
| Rutinas | Buscar, ordenar, crear y gestionar rutinas | Abrir una plantilla o una rutina guardada |
| Cronómetro | Empezar una sesión sin intervalos | Iniciar el cronómetro libre |
| Más | Llegar a historial y preferencias | Abrir historial o ajustes |

La barra inferior permanece visible en las cuatro áreas. Las pantallas visitadas
conservan su estado al cambiar de destino. Las tareas de historial y ajustes
quedan agrupadas en «Más», así se reserva espacio de navegación para Tabata,
Rutinas y Cronómetro.

## Ajustes de usabilidad

- El botón principal del onboarding queda anclado bajo el contenido desplazable,
  para que se vea en pantallas compactas y el texto pueda seguir desplazándose.
- Los controles de Tabata usan botones grandes para subir o bajar los valores,
  muestran unidades y resumen la duración antes de iniciar. Estos cambios se
  aplican solo a esa sesión; las rutinas que el usuario guarda se administran
  desde Rutinas.
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
- Prueba de widget: abrir Rutinas no produce la excepción de localización y carga
  las plantillas.
- La generación de localizaciones se ha ejecutado; Tempo conserva sus delegados
  Material compatibles fuera de los archivos generados.

Las comprobaciones automatizadas no reemplazan la inspección de contraste y
lectura con VoiceOver/TalkBack ni la validación visual en varios tamaños reales.

## Refinamiento visual y ciclos de Tabata — 20-11-2026

Una segunda revisión cubrió las capturas nuevas y el código Flutter. La realizó el agente especializado en diseño de aplicaciones móviles usando la skill `mobile-design`. La revisión fue de solo lectura y se limitó al material de Tempo facilitado por el usuario.

### Hallazgos prioritarios

- **Tabata (P1):** la pantalla solo exponía trabajo, descanso y rondas; preparación, ciclos, pausa entre ciclos y enfriamiento quedaban ocultos en valores fijos.
- **Biblioteca (P1):** búsqueda y ordenación compartían ancho, y el botón flotante cubría parte de la lista en las capturas.
- **Cronómetro y «Más» (P2):** baldosa de icono genérico, tarjetas repetidas y espacio sin una tarea clara hacían que la interfaz se sintiera ensamblada.
- **Temporizador activo (P2):** el modelo llamaba «series» a los grupos de rondas que Tabata presenta como ciclos.
- **Verificación pendiente:** las capturas no permiten medir contraste real, escalado grande de texto ni el orden completo de VoiceOver/TalkBack.

### Decisiones aplicadas

- Tabata permite ajustar preparación, trabajo, descanso tras cada ronda, rondas por ciclo, ciclos, descanso entre ciclos y enfriamiento. Mantiene los valores iniciales 5 s, 20/10 s, 8 rondas y 1 ciclo.
- El descanso tras cada ronda sigue también a la última ronda de cada ciclo; la pausa entre ciclos se añade después cuando tiene un valor mayor que cero. La duración estimada usa esa secuencia y queda visible junto al botón fijo para empezar.
- En la sesión Tabata, el progreso se llama «Ciclo N de M» y la pausa se anuncia como «Descanso entre ciclos». Se conserva el formato interno `sets` para no invalidar rutinas o sesiones ya guardadas.
- La biblioteca muestra la búsqueda a ancho completo, mueve la ordenación debajo y sitúa «Crear entrenamiento» en la barra superior para dejar libre la lista.
- Cronómetro usa el tiempo y su estado como foco; «Más» agrupa historial y preferencias mediante filas y separadores. El color secundario de navegación se alinea con el verde/turquesa; el coral queda para estados puntuales.

### Validación de esta revisión

- Los tests de inicio comprueban los siete controles, el resumen de ciclos y la duración recalculada; el test del temporizador comprueba los rótulos de ciclo y descanso entre ciclos.
- Las pruebas de widget se ejecutan en un tamaño de teléfono; aún falta revisar en dispositivo, texto al 200 %, contraste automatizado y lectores de pantalla.
- El diseño conserva Pulso mineral, Manrope, temas claro/oscuro y objetivos táctiles de 56 dp; no toma recursos visuales de la app de referencia.
