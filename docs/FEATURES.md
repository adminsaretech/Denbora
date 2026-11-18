# Análisis funcional de referencia

Fecha de consulta: 18 de noviembre de 2026. El análisis se hizo como usuario, usando exclusivamente las fichas públicas, las capturas que muestran las tiendas y las reseñas públicas. REA ejecutó escenarios de navegador controlados con idioma `es-ES`; no se descargó ni inspeccionó ningún IPA/APK, código, recurso o contenido interno de la app.

## Fuentes y límites

- [Ficha de Timer Plus en App Store (España)](https://apps.apple.com/es/app/timer-plus-workouts-timer/id1279716547), evidencia REA `ev_f52e45112a17f40d036d76b6bc8b3cf4617c0a500dadf43c37f5882ce7e03b6c`.
- [Ficha de Timer Plus en Google Play (España)](https://play.google.com/store/apps/details?id=com.vgfit.timerplus&hl=es), evidencia REA `ev_d3a90ca68da6d9f836fac4bd2f71a62594aa6c7f8401e6fb696a9192a10e37d2`.
- [REA README](https://github.com/morluto/rea) y [contrato de captura de navegador](https://github.com/morluto/rea/blob/main/docs/guides/web/browser-scenario-contract.md). REA permite examinar la ficha pública con acciones de navegador declaradas y guardar límites y procedencia de la evidencia.

La descripción, las imágenes promocionales y las funciones pueden variar por plataforma, país y versión. Las tiendas no demuestran el comportamiento de cada versión instalada. «No confirmado» significa que no se afirma que la app de referencia lo tenga. Las funciones solicitadas para Tempo se especifican aparte y no se presentan como observaciones de la referencia.

## Resumen de lo observado

| Capacidad | Evidencia pública | Estado de evidencia |
|---|---|---|
| Temporizador de intervalos para HIIT, Tabata y circuitos | Las dos fichas lo describen; las capturas incluyen una preparación y fases de trabajo/descanso. | Observado |
| Rondas y ciclos, su número y duración | Descripción de ambas tiendas; capturas muestran contador de repeticiones y ciclos. | Observado |
| Descanso entre ciclos y enfriamiento | Captura muestra un descanso entre ciclos; notas de versiones mencionan tiempo de enfriamiento. | Observado en capturas/notas |
| Crear temporizadores propios y conservarlos en historial | Descripción de ambas tiendas; capturas muestran editor de entrenamiento y una vista de resultados. | Observado |
| Funcionamiento con la app en segundo plano | Declarado en ambas descripciones. La tienda no acredita que todos los avisos o el sonido sobrevivan a cualquier suspensión del sistema. | Declarado; detalle técnico no confirmado |
| Guía de voz | Declarada por ambas tiendas. Una reseña de iOS indica que el sonido no le interrumpe la música. | Observado/declarado |
| Aviso visual con flash | Declarado por ambas tiendas. | Observado/declarado |
| Apple Watch y HealthKit | La ficha de iOS declara app para Apple Watch, acceso a temporizadores personalizados guardados desde iPhone y uso de HealthKit para mantenerla activa en segundo plano. | Observado/declarado |
| Wear OS, Google Fit / Health Connect | No aparecen en las fichas consultadas. | No confirmado |
| Temas seleccionables, historial detallado, notificaciones persistentes y pantalla siempre encendida | Se ven colores distintos por fase y una pantalla de historial/rendimiento; las fichas no confirman selector de temas, notificación persistente ni ajuste de pantalla encendida. | Parcial / no confirmado |
| Plantillas predefinidas | Tabata aparece en las fichas y capturas. No se ha confirmado el catálogo de presets disponibles. | Tabata observado; catálogo no confirmado |
| Reseñas | La ficha Apple mostraba 4,8/5 y unas 23 mil valoraciones. Play mostraba alrededor de 63,2 mil reseñas; la valoración observada varió entre renders de la ficha, por lo que no se usa como señal funcional estable. | Contexto solamente |

### Señales de reseñas públicas

- En iOS, una reseña reciente destaca la configuración sencilla y que los avisos de sonido pueden convivir con la música.
- En Play, reseñas recientes describen controles y tipografía difíciles de leer después de un cambio visual, pérdida de rutinas personalizadas durante una actualización y una solicitud de pago inesperada durante el uso.
- Consecuencia para Tempo: controles primarios grandes y de alto contraste; guardar de forma persistente y segura los entrenamientos; no cambiar el estado comercial durante una sesión; en el lanzamiento, no incluir anuncios ni compras.

## Historias de usuario y criterios de aceptación

Los criterios de esta sección definen Tempo. Las etiquetas de evidencia separan lo que se observó en la referencia de las decisiones de producto pedidas para Tempo.

### 1. Temporizadores y modos de entrenamiento

**Historia:** Como persona que entrena, quiero escoger una cuenta atrás, un cronómetro libre o un temporizador por intervalos para adaptar Tempo a mi sesión.

**Criterios:**

- Puedo iniciar un cronómetro libre y detenerlo con un resumen de duración.
- Puedo configurar preparación, trabajo y descanso, además de las fases que componen un circuito.
- Puedo usar HIIT, Tabata y EMOM desde plantillas originales; la pantalla muestra el nombre de fase y el progreso actual.
- Una cuenta regresiva nunca muestra tiempo negativo; al acabar el plan, pasa a estado terminado una sola vez.
- Evidencia de referencia: intervalos, HIIT, Tabata y circuitos; el cronómetro de intervalos figura en ambas fichas.

### 2. Rondas, ciclos, series, descansos y saltos

**Historia:** Como persona que prepara bloques repetidos, quiero configurar rondas, series, descansos y enfriamiento para no tener que contar mentalmente.

**Criterios:**

- Puedo configurar cantidad y duración de rondas/ciclos, series y descanso entre fases, ciclos y series.
- Puedo avanzar a la fase siguiente, pausar, reanudar, reiniciar o detener.
- Reiniciar vuelve al primer estado del plan; saltar avanza exactamente una fase; al saltar la última se muestra el estado final.
- Si la app vuelve de segundo plano, recalcula fase y tiempo restante desde una base monotónica.
- Evidencia de referencia: conteo/duración de rondas y ciclos; se ve el descanso entre ciclos y se anuncia enfriamiento en el historial de versiones.

### 3. Entrenamientos propios, plantillas, orden y búsqueda

**Historia:** Como persona con varias rutinas, quiero crear y mantener entrenamientos guardados para repetirlos en futuras sesiones.

**Criterios:**

- Puedo crear, editar, duplicar y borrar un entrenamiento; Tempo valida nombre y duraciones antes de guardarlo.
- Puedo ordenar y buscar por nombre; reiniciar la app conserva los entrenamientos guardados.
- Una plantilla integrada permanece intacta si la edito; al editarla se guarda una copia personal.
- Se incluyen HIIT 20/10, Tabata 20/10 × 8, EMOM, circuito, cardio libre y estiramientos.
- Evidencia de referencia: guardado de un número ilimitado de temporizadores, editor personalizado en capturas y Tabata en ficha/capturas.

### 4. Audio, voz, cuenta atrás y avisos visuales

**Historia:** Como persona que entrena sin mirar continuamente el teléfono, quiero recibir avisos configurables que no interfieran de forma innecesaria con mi música.

**Criterios:**

- Puedo activar/desactivar por separado los sonidos y la síntesis de voz del idioma activo.
- Puedo elegir avisos al iniciar, durante los últimos tres segundos, al cambiar de fase y al terminar.
- Cada aviso ocurre una vez por frontera; al volver de una suspensión no se reproducen avisos antiguos en ráfaga.
- Puedo desactivar flash visual y háptica sin afectar el temporizador.
- Evidencia de referencia: guía de voz, flash informativo y reseña que valora no cortar la música.

### 5. Apariencia, temas y accesibilidad

**Historia:** Como persona que usa la app entre ejercicios, quiero distinguir trabajo, descanso y preparación de un vistazo y con texto legible.

**Criterios:**

- Hay modo claro, oscuro y automático; las fases se distinguen con color, texto e icono, no solo con color.
- El reloj tiene controles amplios, separados y fáciles de alcanzar con una mano.
- VoiceOver y TalkBack anuncian fase, restante, ronda y acción disponible; controles tienen etiquetas semánticas.
- El texto respeta el tamaño del sistema sin recortar controles; el contraste cumple WCAG AA para texto y controles.
- Evidencia de referencia: capturas usan estados visuales de alto contraste; selección de tema y cumplimiento de accesibilidad no están confirmados en la ficha.

### 6. Historial y resumen semanal

**Historia:** Como persona que quiere seguir su constancia, quiero revisar mis sesiones y ver cuántas rondas he completado por semana.

**Criterios:**

- Al terminar, se guarda una sesión con fecha, duración, entrenamiento y rondas/ciclos completados.
- La misma finalización no se guarda dos veces tras reabrir la app.
- El historial muestra una lista de sesiones y un resumen semanal; las unidades y fechas siguen el idioma y región elegidos.
- Puedo borrar una sesión o todo el historial.
- Evidencia de referencia: historial de ejercicios declarado en las fichas y captura de rendimiento/resultados.

### 7. Apple Watch, Wear OS y salud

**Historia:** Como persona que desea usar un reloj o registrar la sesión en una app de salud, quiero habilitar esa integración solo cuando decida usarla.

**Criterios:**

- Tempo explica qué datos escribirá y pide permisos justo antes de la primera escritura; denegar permisos no bloquea el temporizador.
- En iOS, la integración debe limitarse a la sesión de ejercicio necesaria; no lee muestras de salud para el flujo básico.
- En Android, se prioriza Health Connect donde esté disponible; no se promete Google Fit hasta validar su soporte vigente.
- La ficha de referencia sí declara Apple Watch y HealthKit; no se observó evidencia pública de Wear OS o Google Fit.

### 8. Segundo plano, notificación y pantalla encendida

**Historia:** Como persona que deja el móvil bloqueado durante el entrenamiento, quiero que la fase y el tiempo sigan avanzando y recibir avisos nativos permitidos por el sistema.

**Criterios:**

- El estado se calcula desde un reloj monotónico que avanza durante el sueño del dispositivo; un `Timer`/ticker solo refresca la interfaz.
- iOS muestra una Live Activity cuando está disponible y agenda avisos locales permitidos; Android muestra una notificación persistente durante la sesión activa.
- El modo de pantalla encendida es opcional y se apaga al terminar o detener.
- Si se deniegan notificaciones o el sistema suspende/mata el proceso, la app explica qué avisos pueden faltar y recupera la fase correcta al volver.
- Evidencia de referencia: el funcionamiento en segundo plano está declarado en ambas fichas; Live Activity/notificación persistente y pantalla encendida son requisitos propios de Tempo, no afirmaciones sobre la referencia.

### 9. Ajustes, idioma y modo offline

**Historia:** Como persona que quiere usar Tempo sin crear una cuenta, quiero ajustar idioma y comportamiento del temporizador y mantener mis datos en el dispositivo.

**Criterios:**

- Puedo elegir español o inglés, apariencia clara/oscura/automática, unidades, sonidos, voz, háptica y pantalla encendida.
- El idioma del sistema se usa de forma predeterminada y se puede cambiar desde Ajustes.
- Las funciones principales, entrenamientos e historial están disponibles sin red y sin registro.
- No se activa publicidad ni una compra en la primera versión; ninguna función del temporizador queda tras un pago.

## Decisiones de clean room

- El nombre de la app, textos, icono, paleta, composición de pantallas y sonidos de Tempo se crean desde cero.
- No se reutilizan capturas, arte, textos promocionales, sonidos ni recursos de Timer Plus.
- La ficha de referencia se usa para enumerar necesidades observables y el diseño se inspira en principios generales de legibilidad, no en su composición visual.
