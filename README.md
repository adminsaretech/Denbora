# Tempo: Workout Timer

Temporizador de entrenamiento offline para intervalos, HIIT, Tabata, circuitos, rondas y series. El nombre es provisional y la app todavía está en fase de implementación.

## Estado

Fases de análisis, arquitectura, diseño y preparación documental en curso/completadas. El código de la aplicación, las pruebas, los paquetes firmados y los recursos finales para tiendas aún no están entregados. No hay registro obligatorio, anuncios ni compras en el alcance del lanzamiento inicial.

Consulta el [análisis funcional](docs/FEATURES.md), la [arquitectura](docs/ARCHITECTURE.md), la [marca](docs/BRAND.md), las [direcciones visuales](docs/DESIGN.md), el [plan de QA y seguridad](docs/QA_SECURITY.md), el [borrador de privacidad](docs/PRIVACY.md) y la [ficha para tiendas](docs/STORE_LISTING.md). El [registro del equipo y las fases](docs/TEAM.md) identifica responsables y pendientes.

## Stack previsto

- Flutter para iOS y Android.
- Riverpod para estado y dependencias.
- Hive CE cifrado para entrenamientos e historial locales.
- Español e inglés; datos locales y uso sin conexión.
- Motor de intervalos basado en reloj monotónico nativo; los ticks solo actualizan la pantalla.

El alcance de reloj inteligente y salud se mantiene opcional y no se anuncia hasta que exista implementación probada. Las sesiones en segundo plano usan capacidades nativas sujetas a las reglas del sistema operativo; en iOS, Live Activities y notificaciones no ejecutan el motor Flutter.

## Requisitos de desarrollo previstos

- Flutter 3.50 estable y Dart incluido.
- Android Studio con Android SDK API 36 y JDK 17 para compilar Android.
- macOS con una versión vigente de Xcode para compilar, firmar y probar iOS.

Al incorporar el scaffold Flutter, las comprobaciones y compilaciones serán:

```sh
flutter pub get
flutter analyze
flutter test
flutter test integration_test
flutter build appbundle --release
```

Para iOS, desde macOS y con el Team ID/certificados configurados:

```sh
flutter build ipa --release
```

En este entorno Windows se puede preparar Android, pero no ejecutar Xcode ni crear un archivo IPA. Para generar un IPA firmado hará falta un Mac y credenciales del equipo Apple. El AAB final necesitará la clave de publicación acordada y guardada fuera de Git.

## Alcance de la primera versión

Temporizador con preparación, trabajo, descanso, rondas y series; controles de pausa, reanudación, reinicio y salto; edición/duplicado/borrado/búsqueda de entrenamientos; seis plantillas originales; sonidos, voz y háptica configurables; historial con resumen semanal; temas claro/oscuro; onboarding breve.

No se guardan datos en un servidor. La política de privacidad y los formularios de Apple/Google siguen siendo borradores hasta contrastarlos con las dependencias y el artefacto final.
