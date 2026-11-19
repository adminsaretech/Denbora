# Changelog

Los cambios notables se documentan aquí. No se ha publicado una versión comercial.

## Unreleased

### Interfaz y navegación

- Añadida navegación inferior con Tabata, Rondas, Cronómetro y Más.
- Tabata permite ajustar trabajo, descanso y rondas con controles grandes y
  muestra la duración aproximada antes de iniciar.
- Cronómetro tiene un acceso directo al modo libre; Más agrupa el historial y
  los ajustes.
- El botón principal del onboarding permanece visible en pantallas compactas.
- Los delegados Material compatibles con `material_ui` se configuran fuera del
  código generado para evitar el error de `MaterialLocalizations`.
- Consulta el análisis de capturas y las decisiones de navegación en
  [docs/UX_REVIEW.md](docs/UX_REVIEW.md).

### Añadido

- Flutter/Riverpod para iOS y Android con localización española e inglesa, onboarding sin cuenta y ajustes locales.
- Motor de intervalos y cronómetro libre basados en reloj monotónico; pausa, reanudación, reinicio, salto de fase y recuperación al volver a primer plano.
- Seis plantillas originales: HIIT 20/10, Tabata 20/10 × 8, EMOM, circuito, cardio libre y estiramientos.
- Biblioteca con búsqueda, ordenación, creación, edición, duplicado y borrado confirmado.
- Almacenamiento Hive CE cifrado para rutinas, sesiones e instantánea activa; clave en almacenamiento seguro del dispositivo.
- Tonos WAV originales, voz del sistema, háptica y ajuste de pantalla siempre encendida.
- Historial local y gráfico accesible de actividad semanal.
- Concepto visual Pulso mineral, marca/icono propios, Manrope con licencia incluida y documentación REA clean-room.

### Verificado

- 53 pruebas unitarias, de repositorio y widgets pasan; `flutter analyze` no informa incidencias tras la última revisión.
- APK Android debug y bundle AAB release compilados correctamente en Windows con `flutter build apk --debug` y `flutter build appbundle --release` (R8/ProGuard activo).
- El AAB de 50,5 MB fue verificado con `jarsigner` y está sin firmar; solo puede firmarse para tienda con la keystore del titular.
- Iconos Android e iOS generados desde el PNG original opaco de 1024 × 1024.
- Configuración de release Android con R8/ProGuard y lectura opcional de keystore local; no se usa la clave debug para release.
- Recorrido smoke de integración de primer inicio añadido; su ejecución en emulador/simulador quedó bloqueada por falta de dispositivos disponibles.

### Pendiente

- Servicio/notificación persistente Android, Live Activity y notificaciones nativas iOS.
- Pruebas en emuladores/dispositivos, consumo de batería/CPU y medición de arranque en frío.
- Firma de release con la keystore del titular (Android) y Team ID/certificados (iOS), capturas reales localizadas y declaraciones de tienda contrastadas con el binario.
- Funciones opcionales de HealthKit/Health Connect y Apple Watch/Wear OS, fuera del alcance implementado actual.
