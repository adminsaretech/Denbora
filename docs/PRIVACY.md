# Política de privacidad / Privacy policy

**Versión:** borrador de trabajo, 18 de noviembre de 2026  
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

La aplicación no está diseñada para enviar esa información a SareTech ni a terceros, crear perfiles, medir publicidad, vender datos o mostrar anuncios. No incluye registro, analítica, publicidad ni compras en esta versión. Estas declaraciones se deben verificar contra el código, los manifiestos de permisos, las dependencias y una captura de tráfico de la compilación candidata antes de publicarla.

### Funciones del dispositivo

- Si la persona habilita notificaciones, el sistema puede mostrar avisos relacionados con una sesión activa. Tempo no usa un servidor de notificaciones remoto para ello.
- Los avisos hablados usan la voz instalada en el sistema operativo y frases genéricas de fase o cuenta atrás. Tempo no graba audio ni necesita acceder al micrófono.
- El uso de vibración y de mantener la pantalla activa se limita a la sesión solicitada.
- La primera versión no solicita acceso a HealthKit, Health Connect, ubicación, contactos, cámara o fotos.

Las rutinas e historial se eliminarán desde los controles de borrado incluidos en la aplicación o al desinstalarla, según el comportamiento del sistema operativo. Tempo no mantiene una copia propia en la nube. La política de copias de seguridad del dispositivo depende de iOS o Android y de la configuración elegida por cada persona; antes del lanzamiento se debe fijar si la base de datos se excluye de esas copias.

### Salud y relojes

La integración con Apple Health/HealthKit, Health Connect/Google Fit, Apple Watch y Wear OS no forma parte de esta versión. Si se activa en una versión futura, esta sección se actualizará antes del lanzamiento para describir los datos exactos, el permiso opcional, el destino, el periodo de conservación y cómo retirar el permiso. La aplicación no utilizará datos de salud para publicidad.

### Seguridad, conservación y derechos

Los datos de la sesión permanecen en el almacenamiento privado de la app. La implementación debe confirmar el cifrado en reposo cuando los datos personales/de ejercicio lo requieran y evitar incluir copias sin cifrar en respaldos. No se declara aquí un mecanismo de cifrado específico hasta verificarlo en la compilación de entrega.

No hay datos almacenados en servidores de Tempo ni un periodo de retención del servidor. La persona usuaria puede borrar los entrenamientos o el historial mediante la aplicación; el borrado de todos los datos locales debe estar disponible en Ajustes antes del lanzamiento. Si desea ejercer derechos sobre datos personales o hacer una consulta, podrá contactar al responsable mediante los datos indicados arriba una vez completados.

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

The app is not designed to send this information to SareTech or another party, build profiles, measure advertising, sell data or show ads. This release includes no sign-in, analytics, advertising or purchases. Verify these statements against the source, permission manifests, dependencies and a network capture from the release candidate before publication.

### Device features

- If the user enables notifications, the operating system may show session-related notices. Tempo does not use a remote push-notification server.
- Spoken cues use the voice installed in the operating system and generic phase or countdown wording. Tempo does not record audio or need microphone access.
- Vibration and keeping the display awake are limited to a session the user starts.
- The first release does not request access to HealthKit, Health Connect, location, contacts, camera or photos.

Workouts and history can be removed through the app's delete controls or by uninstalling it, subject to operating-system behavior. Tempo does not keep its own cloud copy. Device backup behavior depends on iOS or Android and the user's settings; before release, decide whether the database is excluded from these backups.

### Health and watches

Apple Health/HealthKit, Health Connect/Google Fit, Apple Watch and Wear OS integration are not part of this release. If a later version enables them, this section will be updated before launch with the precise data, optional permission, destination, retention period and permission-revocation steps. Health data will not be used for advertising.

### Security, retention and user rights

Session data stays in the app's private storage. Confirm at-rest encryption where personal or exercise data requires it, and prevent unencrypted copies from entering backups. This draft does not promise a specific encryption method until it is verified in the release build.

Tempo has no server-side session-data store and no server retention period. Users can delete workouts or history in the app; a clear-all-local-data control must be available in Settings before release. Once the controller details above are filled in, users can contact the controller to ask about their personal data or exercise their applicable rights.

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
