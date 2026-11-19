# Tempo: Workout Timer

Temporizador offline para intervalos, HIIT, Tabata, circuitos, rondas y series. El nombre Tempo es provisional; todavía necesita verificación formal de marca antes de publicar.

## Estado actual

La app Flutter ya incluye planes originales, editor y biblioteca local, motor monotónico de intervalos, cronómetro libre, pausa/reinicio/salto, avisos sonoros originales, voz del sistema, vibración, pantalla activa opcional, onboarding, ajustes ES/EN e historial con resumen semanal.

Las notificaciones persistentes y la ejecución nativa en segundo plano, Live Activities/Dynamic Island, Apple Watch/Wear OS, HealthKit/Health Connect y exportaciones de salud aún no están implementadas. El código está preparado para continuar esas fases, pero no se deben prometer en una ficha de tienda todavía. Este entorno Windows no incluye Xcode, Team ID, cuentas de tienda ni una clave Android de publicación; por tanto, no hay IPA ni AAB de release firmado.

## Requisitos

- Flutter 3.50 y Dart 3.14.
- Android Studio, Android SDK API 36 y JDK 17 para Android. `minSdk 24`, `targetSdk 36`.
- macOS con Xcode compatible con App Store Connect para compilar y probar iOS. El proyecto fija iOS 16.0 o superior.

## Estructura

- `lib/features/timer`: controlador, temporizador y pantalla de sesión.
- `lib/features/workouts`: modelo, validación, seis plantillas originales, repositorio, lista/editor.
- `lib/features/history`: sesiones locales, resumen semanal y pantalla de historial.
- `lib/features/settings` y `lib/features/onboarding`: ajustes y bienvenida sin cuenta.
- `lib/core`: reloj monotónico nativo, base local cifrada, audio/TTS, localización y tema.
- `test/`: pruebas unitarias, de repositorio y de widgets.
- `integration_test/`: recorrido de primer inicio y entrada a la app; falta ejecutarlo en simuladores/dispositivos iOS y Android.

## Preparar y verificar

Desde la raíz del repositorio:

```sh
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

El motor deriva el tiempo desde el reloj monotónico del dispositivo; los ticks de la UI solo actualizan la pantalla. Workouts, ajustes e historial se almacenan en el dispositivo. La base local de sesiones y entrenamientos usa Hive CE cifrado con una clave guardada por el sistema seguro.

### Android

1. Instala Android Studio, SDK Platform 36 y JDK 17; ejecuta `flutter doctor -v` y acepta las licencias del SDK.
2. Abre el proyecto en Android Studio o ejecuta `flutter pub get` y `flutter test` desde la raíz.
3. Genera el APK de desarrollo con `flutter build apk --debug`; el resultado aparece en `build/app/outputs/flutter-apk/app-debug.apk`.
4. Para preparar la firma, crea un keystore (`keytool -genkeypair -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`), copia `android/key.properties.example` como `android/key.properties` y rellena sus valores. El keystore y el archivo de propiedades están ignorados por Git.
5. Genera el paquete con `flutter build appbundle --release`. Gradle activa R8/ProGuard y usa la firma del titular si existe `android/key.properties`; sin esa configuración el AAB queda sin firmar y no se puede subir a Google Play. Conserva una copia de seguridad de la clave.
6. Prueba al menos en API 24 y en un dispositivo/emulador API 36. No se detectó ningún emulador/dispositivo Android conectado en el entorno de trabajo; las pruebas de bloqueo de pantalla, sonido, batería y notificaciones nativas siguen pendientes.
7. Con un dispositivo conectado, ejecuta `flutter test integration_test/tempo_smoke_test.dart -d <device-id>` para validar el flujo básico de primer inicio.

`applicationId`: `com.saretech.tempo`. Nunca guardes keystore, contraseñas o claves en el repositorio.

### iOS

1. En macOS, instala Flutter estable y Xcode compatible; ejecuta `flutter doctor -v`.
2. Abre `ios/Runner.xcworkspace` en Xcode, confirma iOS Deployment Target 16.0, el bundle ID `com.saretech.tempo` y selecciona el Team ID/certificado del titular en Signing & Capabilities.
3. Ejecuta `flutter pub get`, `flutter analyze` y `flutter test`; prueba el proyecto en simulador y dispositivo.
4. Genera el archivo de tienda con `flutter build ipa --release` después de configurar firma y validar las capacidades reales.

La integración nativa actual incluye el muestreo monotónico (`mach_continuous_time`) y requiere compilación de Xcode para verificar. Live Activities, App Groups y HealthKit no deben habilitarse en Xcode hasta que su código esté implementado.

## Diseño, referencia y privacidad

El análisis de Timer+ se realizó únicamente con sus páginas públicas de App Store/Google Play, capturas y reseñas. No se descargaron ni inspeccionaron binarios o recursos. La identidad Tempo, las plantillas, el icono y los sonidos son originales. La app inicial no tiene registro, backend obligatorio, anuncios, compras ni suscripciones.

Consulta [FEATURES.md](docs/FEATURES.md), [ARCHITECTURE.md](docs/ARCHITECTURE.md), [DESIGN.md](docs/DESIGN.md), [PRIVACY.md](docs/PRIVACY.md), [QA_SECURITY.md](docs/QA_SECURITY.md), [STORE_LISTING.md](docs/STORE_LISTING.md), [BRAND.md](docs/BRAND.md), el [registro de agentes y fases](docs/TEAM.md) y el [informe final](docs/FINAL_REPORT.md).

La política de privacidad, las declaraciones Apple/Google, capturas de tienda y textos de ficha siguen en borrador hasta auditar la compilación final. La URL pública de privacidad y los datos legales del titular faltan.
