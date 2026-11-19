# Equipo y fases

Registro de los agentes, sus entregas y las comprobaciones realizadas. Los nombres describen roles, no personas. Un documento de diseño o una compilación debug no equivale a un artefacto firmado ni a una aprobación de tienda.

## Responsabilidades de agentes

| Rol/agente | Trabajo coordinado | Entrega / estado |
|---|---|---|
| REA e ingeniería funcional | Analizó como usuario las páginas públicas, capturas y reseñas de Timer+; sin descargar ni inspeccionar IPA/APK, código o recursos. | Evidencia y criterios en [FEATURES.md](FEATURES.md); completado. |
| Arquitectura | Propuso stack y límites nativos; registró el reloj monotónico, almacenamiento local y restricciones de segundo plano. | [ARCHITECTURE.md](ARCHITECTURE.md); el núcleo Flutter está implementado, los servicios de plataforma siguen pendientes. |
| UI/UX y marca | Propuso tres direcciones visuales, accesibilidad, paleta Pulso mineral e identidad original. | [BRAND.md](BRAND.md), [DESIGN.md](DESIGN.md), SVG y PNG opaco original de 1024 × 1024; el nombre Tempo es provisional. |
| QA y seguridad | Definió estrategia de pruebas, permisos y auditoría de artefactos. | [QA_SECURITY.md](QA_SECURITY.md); 53 pruebas automatizadas pasan y `flutter analyze` está limpio. Pruebas en dispositivos y rendimiento no ejecutados. |
| Tiendas y privacidad | Preparó textos, metadatos, capturas requeridas y borradores de privacidad/datos. | [STORE_LISTING.md](STORE_LISTING.md), [PRIVACY.md](PRIVACY.md); listados y formularios deben contrastarse con el release final. |
| Documentación | Preparó README, changelog y registro de fases. | [README.md](../README.md), [CHANGELOG.md](../CHANGELOG.md) y este documento; actualización continua. |
| Ingeniería principal | Coordinó interfaces y fases; implementó modelo, reloj, persistencia cifrada, pantallas y pruebas. | Rama `codex/tempo-v1`, subida al repositorio indicado por el usuario. |

## Estado por fase

| Fase | Entrega | Estado |
|---|---|---|
| 0. Marca y diseño | Tres direcciones originales; Pulso mineral elegido; logo, icono 1024 × 1024 y tipografía Manrope con licencia incluida. | Integrados en la app; iconos de plataforma generados. Pendiente clearance oficial de OEPM/EUIPO, disponibilidad en tiendas/dominios y validación visual en dispositivos. |
| 1. Análisis funcional | Lista de capacidades observables, límites de evidencia, historias y criterios de aceptación. | Validada el 18-11-2026 con fichas públicas es-ES. Las integraciones de reloj/salud que no aparecieron en Play se marcan como no confirmadas. |
| 2. Arquitectura | Flutter, Riverpod, Hive CE cifrado, reloj monotónico nativo y límites de segundo plano. | Núcleo implementado: `lib/core`, dominio del temporizador y repositorios. Notificación persistente Android y Live Activity iOS aún no implementadas. |
| 3. UI/UX | Modo claro/oscuro, Manrope, controles grandes, idioma ES/EN, textos escalables y semántica. | Integrados en onboarding, ajustes, biblioteca, editor, temporizador e historial. Aún falta auditoría VoiceOver/TalkBack en dispositivos. |
| 4. Implementación | Plantillas, editor, CRUD, temporizador, ajustes, onboarding, avisos e historial semanal. | Implementado parcialmente. El temporizador de primer plano, seis plantillas originales, cronómetro libre, tonos WAV originales, TTS del sistema, háptica y wakelock están en la rama. Los avisos en segundo plano y funciones de reloj/salud siguen pendientes. |
| 5. QA y seguridad | Pruebas de motor, repositorios, widgets y revisión de permisos. | 53 pruebas unitarias/widget pasan y `flutter analyze` está limpio. Hay un smoke test de integración para primer inicio; no se pudo ejecutar porque no hay dispositivo Android/iOS soportado conectado. Faltan auditoría de red del artefacto, batería/CPU y arranque frío. |
| 6. Entornos | Android API 24–36; iOS 16; configuración de build y firma. | APK debug y AAB release compilan; `jarsigner` confirma que el AAB está sin firma. Android `minSdk 24`/`targetSdk 36`; NDK 28.2; R8/ProGuard y lectura opcional de `android/key.properties`. Xcode fija deployment target 16 y bundle `com.saretech.tempo`. Falta verificación de Xcode, Team ID/certificados y keystore del titular. |
| 7. Tiendas y privacidad | Fichas ES/EN, palabras clave, icono y checklist. | Borradores entregados. Falta generar capturas reales localizadas, feature graphic, URL pública de privacidad, datos legales del titular y declaraciones contra el binario final. |

## Evidencia REA

- App Store: `ev_f52e45112a17f40d036d76b6bc8b3cf4617c0a500dadf43c37f5882ce7e03b6c`.
- Google Play: `ev_d3a90ca68da6d9f836fac4bd2f71a62594aa6c7f8401e6fb696a9192a10e37d2`.
- Método: navegador Chromium 157 con idioma `es-ES`, páginas públicas de tiendas y captura de DOM/accesibilidad/pantalla. No se guardaron arte promocionales ni recursos originales.

## Validación y límites conocidos

1. Los tests usan reloj falso para validar precisión determinista; el temporizador usa la base nativa Android `elapsedRealtimeNanos` / iOS `mach_continuous_time`, y recalcula al volver a primer plano.
2. Hive cifra la base con AES-256 y guarda la clave mediante almacenamiento seguro del SO; preferencias visuales no se consideran datos sensibles.
3. La versión actual no implementa notificación persistente Android, Live Activities/Dynamic Island, HealthKit/Health Connect, Apple Watch ni Wear OS. No activar permisos o capacidades de tienda por estas funciones.
4. La carpeta de trabajo es Windows y no tiene Xcode. Se necesita un Mac para compilar/probar iOS y la firma requiere el Team ID y certificados del titular. El AAB de tienda necesita una clave de publicación del titular guardada fuera de Git.
5. Nombre, política pública, declaraciones Apple/Google, capturas de tienda y firma se revisan contra el artefacto definitivo antes de enviar.
