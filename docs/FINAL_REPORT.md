# Informe final — Tempo: Workout Timer

**Fecha:** 19 de noviembre de 2026  
**Repositorio:** https://github.com/adminsaretech/Denbora  
**Rama de trabajo:** `codex/tempo-v1`  
**Estado:** código y builds Android disponibles; publicación aún no lista.

## Cobertura funcional

| Función | Estado | Notas |
|---|---|---|
| Temporizador por intervalos | Implementada | Preparación, trabajo, descansos, rondas, series, cuenta atrás, pausa, reanudar, reiniciar y saltar. Usa reloj monotónico nativo; la UI solo refresca el estado. |
| Cronómetro libre | Implementada | Cuenta ascendente con las mismas acciones básicas de sesión. |
| Biblioteca de entrenamientos | Implementada | Alta, edición, duplicado, borrado confirmado, búsqueda y ordenación; las plantillas originales integradas no se modifican. |
| Plantillas | Implementadas | HIIT 20/10, Tabata 20/10 × 8, EMOM, circuito, cardio libre y estiramientos. |
| Avisos | Implementados en primer plano | Tonos WAV originales, síntesis TTS del sistema, cuenta atrás final y háptica configurables. La preferencia de avisos con pantalla apagada está deshabilitada y explica la limitación. |
| Historial | Implementado | Sesiones guardadas localmente y gráfico accesible de actividad de siete días. |
| Idioma, tema y onboarding | Implementados | Español inicial, inglés, claro/oscuro/sistema y primer inicio sin cuenta. |
| Persistencia offline | Implementada | Hive CE cifra entrenamientos, sesiones e instantánea activa; clave en almacenamiento seguro del sistema. Ajustes no sensibles en preferencias locales. |
| Funciones de pantalla apagada | Parciales | Se recupera el tiempo/fase al volver a primer plano y existe ajuste optativo de pantalla encendida. No hay notificación persistente Android, servicio de avisos nativos ni Live Activity iOS. |
| Salud y relojes | No implementadas | No hay HealthKit, Health Connect, Apple Watch ni Wear OS. |
| Monetización | No incluida | Sin registro, backend obligatorio, anuncios, compras ni suscripción. |

La referencia se analizó como usuario desde sus fichas públicas, capturas, descripción y reseñas. No se descargaron binarios ni se copiaron marca, diseño, código o recursos. Las funciones observadas y las historias de usuario están en [FEATURES.md](FEATURES.md).

## Verificación ejecutada

- `flutter analyze`: sin incidencias.
- `flutter test --reporter=compact`: 53/53 pruebas unitarias, de repositorio y widgets pasan.
- `flutter build apk --debug`: correcto. Artefacto local: `build/app/outputs/flutter-apk/app-debug.apk`.
- `flutter build appbundle --release --no-pub`: correcto con R8/ProGuard. Artefacto local: `build/app/outputs/bundle/release/app-release.aab` (50,5 MB).
- `jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab`: confirma que el AAB está **sin firmar**.
- El manifiesto Android de release declara `minSdk 24`/`targetSdk 36` y no añade permisos runtime solicitables; la búsqueda en dependencias no encontró SDKs de publicidad o analítica. El proveedor TTS del sistema puede aplicar su propio tratamiento/red.
- Se añadió `integration_test/tempo_smoke_test.dart`. Su ejecución con `flutter test integration_test/tempo_smoke_test.dart` no fue posible: el entorno solo detecta Windows/Chrome/Edge y ninguno es un dispositivo compatible para este target móvil.
- No hay Xcode en el entorno Windows; no se compiló, archivó ni firmó iOS. No se midieron arranque en frío, consumo de batería ni CPU con pantalla apagada.

El APK y el AAB están en el directorio `build/`, ignorado por Git; no se han incluido como binarios en el repositorio.

## Pendiente antes de publicar

1. Configurar el keystore de subida del titular en `android/upload-keystore.jks` y `android/key.properties` (plantilla: `android/key.properties.example`) y generar/verificar un AAB firmado. No subir secretos a Git.
2. En macOS, elegir el Apple Team ID y certificados del titular; compilar y probar el proyecto iOS en simulador/dispositivo y archivar la app. El bundle ID preparado es `com.saretech.tempo` y el deployment target es iOS 16.
3. Ejecutar el smoke test y recorridos de temporizador en Android emulado/físico e iOS; validar pausa, suspensión, permisos, audio, accesibilidad y reanudación.
4. Implementar notificación persistente/servicio Android y Live Activity/notificaciones iOS si se mantienen como requisitos de lanzamiento. Añadir Health/Watch solo con alcance y pruebas nativas definidos.
5. Crear capturas reales localizadas de ambas plataformas, revisar las fichas de tienda contra el binario final y completar los formularios de privacidad/datos.
6. Publicar la política de privacidad con responsable, contacto y URL legal reales. El borrador actual está en [PRIVACY.md](PRIVACY.md).
7. Verificar disponibilidad legal y de marca para “Tempo” en OEPM/EUIPO, tiendas y dominios antes de publicar.

## Riesgos y límites

- “Tempo” es nombre provisional y puede tener conflictos de marca o disponibilidad.
- Las fichas y declaraciones de privacidad son borradores hasta contrastarlas con el AAB/IPA definitivo y sus permisos/dependencias.
- Los avisos son fiables mientras la app está activa; el sistema operativo puede suspenderla y actualmente no existe un canal nativo de avisos en segundo plano.
- En Flutter 3.50, Gradle advierte que `flutter_tts` todavía aplica el Kotlin Gradle Plugin. Los builds Android actuales pasan, pero hay que revisar compatibilidad al actualizar Flutter.
- No se afirma compatibilidad ni aprobación de tienda, ni se presenta el AAB sin firmar como publicable.

## Próximos pasos

Con el titular, preparar la firma Android y Apple, ejecutar las pruebas en dispositivos reales y completar las extensiones nativas acordadas. Después, generar capturas de tienda, cerrar la política legal y revalidar privacidad, rendimiento y marcas antes de subir versiones firmadas.
