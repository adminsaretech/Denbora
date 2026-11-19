# Política de privacidad / Privacy policy

**Versión:** borrador de trabajo, 19 de noviembre de 2026
**Aplicación:** Tempo: Workout Timer (nombre provisional)  
**Estado:** no publicar hasta completar los campos del responsable y contrastar el texto con el binario y sus dependencias.

## Español

### Quién es responsable

**Responsable:** [nombre legal del desarrollador o empresa]  
**Contacto de privacidad:** [correo de privacidad]  
**Contacto de soporte:** [correo o página de soporte]  
**URL pública de esta política:** [URL HTTPS definitiva]

Estos datos son obligatorios antes de distribuir la aplicación. La política deberá estar disponible en una URL pública, activa y no geobloqueada, y también desde la aplicación.

### Qué hace la aplicación con los datos

El diseño de la primera versión no requiere cuenta ni servidor. Las rutinas que crea la persona usuaria, los ajustes de la aplicación y el resumen local de las sesiones (fecha, duración y rondas completadas) se guardan en el almacenamiento privado de la aplicación en el dispositivo para que Tempo pueda mostrarlos y utilizarlos sin conexión.

La aplicación no incluye backend, cuenta, analítica, publicidad ni compras. La app no envía entrenamientos ni historial a SareTech. Cuando se activan los avisos de voz, frases cortas y genéricas de fase/cuenta atrás se entregan al servicio TTS instalado en el dispositivo; ese proveedor y la configuración del sistema pueden tener su propio tratamiento de datos o síntesis en red. Tempo no graba audio ni solicita micrófono. Antes de publicar, verificar en dispositivos si el servicio TTS elegido procesa texto fuera del dispositivo y ajustar las declaraciones de tienda.

### Funciones del dispositivo

- La versión actual no solicita permiso de notificaciones ni presenta avisos persistentes en segundo plano; esa función nativa está pendiente.
- Los avisos hablados usan frases genéricas con la voz del sistema. El proveedor TTS instalado puede procesarlas según sus propios ajustes; Tempo no graba audio ni necesita acceder al micrófono.
- El uso de vibración y de mantener la pantalla activa se limita a la sesión visible solicitada. El wakelock no mantiene el proceso ejecutándose en segundo plano.
- La primera versión no solicita acceso a HealthKit, Health Connect, ubicación, contactos, cámara o fotos.

Las rutinas e historial se eliminarán desde los controles de borrado incluidos en la aplicación o al desinstalarla, según el comportamiento del sistema operativo. Tempo no mantiene una copia propia en la nube. La política de copias de seguridad del dispositivo depende de iOS o Android y de la configuración elegida por cada persona; antes del lanzamiento se debe fijar si la base de datos se excluye de esas copias.

### Salud y relojes

La integración con Apple Health/HealthKit, Health Connect/Google Fit, Apple Watch y Wear OS no forma parte de esta versión. Si se activa en una versión futura, esta sección se actualizará antes del lanzamiento para describir los datos exactos, el permiso opcional, el destino, el periodo de conservación y cómo retirar el permiso. La aplicación no utilizará datos de salud para publicidad.

### Seguridad, conservación y derechos

Entrenamientos, sesiones y sesión activa se guardan en una base Hive CE cifrada con AES-256-CBC; su clave aleatoria se guarda mediante Keychain/Android secure storage. AES-CBC no autentica los registros. Ajustes de presentación se guardan en preferencias locales normales. La copia de seguridad y restauración de esos archivos debe verificarse en cada plataforma antes de publicar.

No hay datos almacenados en servidores de Tempo ni un periodo de retención del servidor. Se pueden borrar entrenamientos personalizados; el historial todavía no incluye controles de borrado y debe añadirse una acción para eliminar todos los datos locales antes del lanzamiento. Para ejercer derechos o hacer una consulta, se podrá contactar al responsable cuando se completen los datos indicados arriba.

### Cambios

Publicaremos una nueva versión de esta política si cambia el tratamiento de datos. La fecha de entrada en vigor se actualizará en ese momento.

## English

### Who is responsible

**Controller:** [developer's legal name or company]  
**Privacy contact:** [privacy email]  
**Support contact:** [support email or page]  
**Public policy URL:** [final HTTPS URL]

These details must be completed before distribution. This policy must be hosted at an active, public, non-geofenced URL and be accessible from inside the app.

### How the app handles data

The first-release design requires no account or server. Workouts created by the user, app settings and a local session summary (date, duration and completed rounds) are stored in the app's private device storage so Tempo can display them and work offline.

The app includes no backend, account, analytics, advertising or purchases. It does not send workouts or history to SareTech. When voice cues are enabled, short generic phase/countdown phrases are passed to the system TTS engine installed on the device. That provider and the device settings may process speech under their own terms or synthesize it over a network. Tempo does not record audio or request microphone access. Before publication, verify on devices whether the selected TTS engine sends text off-device and update store disclosures as needed.

### Device features

- The current build does not request notification permission or show persistent background notices; that native feature is pending.
- Spoken cues use generic wording through the installed system TTS engine. Its provider may process text according to its own settings; Tempo does not record audio or need microphone access.
- Vibration and keeping the display awake are limited to the visible session. The screen wakelock does not keep the app process running in the background.
- The first release does not request access to HealthKit, Health Connect, location, contacts, camera or photos.

Workouts and history can be removed through the app's delete controls or by uninstalling it, subject to operating-system behavior. Tempo does not keep its own cloud copy. Device backup behavior depends on iOS or Android and the user's settings; before release, decide whether the database is excluded from these backups.

### Health and watches

Apple Health/HealthKit, Health Connect/Google Fit, Apple Watch and Wear OS integration are not part of this release. If a later version enables them, this section will be updated before launch with the precise data, optional permission, destination, retention period and permission-revocation steps. Health data will not be used for advertising.

### Security, retention and user rights

Workouts, sessions and the active-session snapshot are stored in a Hive CE database encrypted with AES-256-CBC; a random key is stored through Keychain/Android secure storage. AES-CBC does not authenticate records. Display preferences are kept in ordinary local preferences. Verify backup and restore behavior on each platform before publication.

Tempo has no server-side session-data store and no server retention period. Users can delete custom workouts; history does not yet offer delete controls. Add a clear-all-local-data action before release. Users can contact the controller about personal data once the details above are completed.

### Changes

We will publish a revised policy if our data practices change and update the effective date.

## Store disclosure notes (not a submitted declaration)

- **Apple App Privacy:** If the release and all third-party SDKs transmit no user data off-device, Apple's guidance says device-only processing is not “collected”; the likely answer is “No, we do not collect data from this app.” Reassess if any analytics, diagnostics, health, speech or account service transmits data. [Apple App Privacy details](https://developer.apple.com/app-store/app-privacy-details/), [App Store Connect privacy workflow](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy).
- **Google Play Data safety:** Every app on closed, open or production tracks must complete the form and provide a privacy-policy link, including apps that collect no data. The form must include third-party SDK behavior and match the policy. [Google Play Data safety](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en), [User Data policy](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en).
- No ATT or UMP consent is needed for the planned no-ad, no-tracking release. If advertising or tracking is added later, reassess consent and disclose the SDK behavior before enabling it.

## Pre-publication verification

- [ ] Replace all bracketed controller, support and URL fields.
- [ ] Publish this text as a plain web page on a stable HTTPS address; link it from the app and both stores.
- [ ] Confirm the app has a delete-all-local-data action and that uninstall/backup behavior matches this text.
- [ ] Inspect dependencies, permissions and release network traffic for undeclared collection or trackers.
- [ ] Confirm whether the database and encryption key are backed up, and update the wording accordingly.
- [ ] Reassess all disclosures before enabling health, watch, analytics, support-purchase or advertising features.
