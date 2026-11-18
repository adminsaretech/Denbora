# Calidad y seguridad móvil

**Responsable:** agente de QA y seguridad  
**Estado:** plan de verificación; no constituye evidencia de que las pruebas se hayan ejecutado.  
**Revisión de plataformas:** 18 de noviembre de 2026.

## Alcance y criterio de salida

Tempo calcula entrenamientos localmente. No necesita cuenta, servidor, ubicación, contactos, cámara, micrófono ni acceso a sensores corporales para su alcance inicial. La integración con HealthKit o Health Connect se mantiene opcional y fuera de la ruta básica.

Una fase se considera validada cuando pasan las pruebas automatizadas aplicables, se revisan los manifiestos/permisos del artefacto y se completan las comprobaciones físicas identificadas como «dispositivo». Los resultados, dispositivo, versión del sistema, fecha y cualquier desviación deben anotarse junto al informe de entrega. No se debe presentar una comprobación de simulador como prueba de batería o de comportamiento de un dispositivo real.

## Matriz de pruebas automatizadas

| Área | Casos que deben cubrirse | Evidencia esperada |
|---|---|---|
| Máquina de estados | Preparación → trabajo → descanso → trabajo; fin de ronda, descanso entre series, enfriamiento y fin total. | Transiciones en el orden configurado; una sola notificación de evento por frontera. |
| Límites de duración | 1 segundo, duración mínima admitida, descansos de 0, varios ciclos, una ronda, varias series y la sesión más larga admitida. | Sin bucles infinitos, división por cero, ronda adicional ni salto silencioso de una fase no vacía. |
| Cuenta atrás y avisos | Inicio; segundos 3, 2 y 1; último segundo cuando la fase dura menos de 3 s; cambio de fase; final. | Cada aviso se emite una sola vez y solo cuando está habilitado. No hay cuenta atrás negativa. |
| Reloj monotónico | Avance normal, evento tardío del event loop, salto de varios límites de fase mientras la UI está suspendida y ajuste manual del reloj de pared hacia delante y atrás. | El tiempo transcurrido no depende de `DateTime.now()` ni acumula el retraso de cada tick; al recuperar ejecución se calcula el estado actual desde el reloj monotónico. |
| Pausa y reanudación | Pausar a mitad de trabajo/descanso, esperar, reanudar; pausar justo antes de una transición; repetir pausa/reanudación. | El tiempo en pausa no cuenta; no se pierde ni duplica tiempo; el estado previo se conserva. |
| Reinicio, detener y saltar | Reiniciar antes y durante; saltar una fase; saltar la última fase; detener y descartar; terminar naturalmente. | Reinicio vuelve a la configuración inicial; saltar avanza exactamente una fase; finalizar guarda como máximo una sesión completa y detener no guarda una falsa sesión completa. |
| Segundo plano y restauración | Enviar app a segundo plano, reanudar tras cruzar cero, varias fases y varias rondas; recrear el controlador desde estado guardado; simular proceso finalizado. | Al regresar se muestra el tiempo restante y la fase correctos. Se documenta la limitación si el proceso fue terminado; no se promete ejecución de audio mientras el SO no ejecuta la app. |
| Precisión | Reloj falso para pruebas deterministas y reloj real en pruebas de integración durante 10 minutos. | En pruebas unitarias, fronteras exactas según el reloj falso. En dispositivo, registrar retraso medido de pantalla/sonido; la latencia de audio del SO no es una garantía de tiempo real. |
| Persistencia e historial | Completar, interrumpir y reiniciar sesión; guardar duración, rondas completadas y fecha; cerrar y volver a abrir. | Sesiones completas aparecen una vez; incompletas se marcan o descartan conforme a la política; el resumen semanal coincide con los datos locales. |
| Plantillas y edición | Abrir las seis plantillas; crear, editar, duplicar, borrar, ordenar y buscar; nombres vacíos y duraciones inválidas. | Plantillas originales válidas; no se altera una plantilla integrada por editar su copia; validaciones comprensibles. |
| Sonido, voz y háptica | Cada combinación de sonido/voz/vibración activada y desactivada; TTS en español e inglés; interrupción por llamada/audio externo. | Preferencias respetadas; el foco de audio se libera al terminar, pausar o detener; la app no reproduce una ráfaga atrasada de avisos al volver. |
| Accesibilidad y localización | VoiceOver/TalkBack labels; foco de controles; tamaño de texto aumentado; español/inglés; tema claro/oscuro; contraste de estados. | Acciones distinguibles sin color únicamente; controles alcanzables y legibles; cadenas sin recorte en tamaños de texto grandes. |

### Pruebas de widgets

- Pantalla de inicio: estado sin entrenamientos y con entrenamientos; búsqueda, orden y navegación.
- Editor: validación de duraciones, rondas/series, crear, guardar, duplicar y borrar.
- Temporizador: trabajo/descanso, pausa/reanudación, reinicio, saltar, progreso y controles accesibles.
- Historial: lista vacía, sesión completa, resumen semanal y persistencia después de reconstruir la pantalla.
- Ajustes/onboarding: idioma, tema, sonido, voz, háptica, pantalla encendida, opciones de segundo plano y finalización sin cuenta.
- Escalado de texto, modo oscuro y etiquetas semánticas en todos los componentes principales.

### Pruebas de integración

1. Crear desde cada plantilla, iniciar, pausar, reanudar, saltar y terminar una sesión; confirmar el historial.
2. Ejecutar la prueba con el dispositivo bloqueado y después de una suspensión de al menos 60 s; validar la recuperación de fase y el aviso siguiente.
3. Denegar las notificaciones y confirmar que el usuario entiende la limitación y puede seguir usando el temporizador en primer plano.
4. Forzar cierre del proceso; verificar el comportamiento documentado al volver, sin duplicar sesiones ni avisos.
5. Desconectar red durante toda la prueba y comprobar que las funciones principales continúan disponibles.
6. Comprobar la instalación limpia y la actualización de una versión anterior con entrenamientos e historial ya guardados.

## Revisión manual en dispositivos

| Comprobación | Entorno | Resultado a registrar |
|---|---|---|
| Suspensión/bloqueo durante trabajo, descanso y cruce de varias fases | iPhone físico con iOS 16 o posterior; Android API 24 y una versión objetivo actual | Fase y tiempo al volver, sonidos audibles, interrupciones por llamada y por otra app de audio. |
| Ciclo de vida con batería restringida y proceso retirado | Android físico de al menos dos fabricantes, incluida una capa con gestión agresiva de batería | Restricciones de fabricante, aviso visible y recuperación al abrir la app. No generalizar desde un solo modelo. |
| Sonido, TTS y enfoque de audio | iPhone y Android físicos con y sin auriculares Bluetooth | Volumen/ruta, mezcla con música, interrupciones y liberación del audio al parar. |
| VoiceOver y TalkBack | Dispositivos físicos | Orden de lectura, etiquetas, anuncios de cambio de fase y controles grandes. |
| Rendimiento y consumo | Dispositivo Android de gama media y iPhone de referencia, cargas medidas repetibles | Arranque frío, CPU/reposo, memoria y batería con pantalla encendida/apagada. Guardar modelo, OS y número de repeticiones. |
| Permisos opcionales de salud | Solo cuando se implemente integración | Conceder, denegar, revocar y limitar permisos; la app sigue usable sin concederlos. |

El arranque en frío tiene como objetivo **menos de 2 segundos**. Medir al menos 10 arranques en un dispositivo definido, descartando la primera instalación si se informa como resultado aparte, y publicar mediana y peor caso. Para batería y CPU no se declara un umbral numérico hasta fijar dispositivos de referencia; comprobar que no hay sondeo continuo en segundo plano, trabajo periódico de alta frecuencia ni audio silencioso de mantenimiento. Usar Android Studio Profiler/Perfetto y Xcode Instruments/Energy Log, y comparar con el proceso detenido y con una sesión activa.

## Modelo de reloj y segundo plano

- El dominio recibe una interfaz de reloj monotónico inyectable. El reloj autoritativo debe incluir el tiempo de suspensión del dispositivo: Android documenta `SystemClock.elapsedRealtime()` para ese uso; en Apple, `mach_continuous_time()` incluye el sueño del sistema. La API pública de Dart describe `Stopwatch` como monotónico pero no promete que incluya la suspensión; no usarlo como única fuente para un temporizador con pantalla bloqueada hasta medir y confirmar ese comportamiento en cada plataforma. Un puente nativo puede proporcionar la base correcta. Los `Timer` de Dart son solo una señal para refrescar la UI, nunca la fuente única del tiempo.
- Las notificaciones visuales pueden refrescarse a una frecuencia moderada en primer plano. Las transiciones se derivan de marcas temporales monotónicas, no de contar ticks.
- En `resumed`, recalcular la fase y el restante desde el reloj monotónico y procesar las fronteras transcurridas sin emitir retroactivamente todos los sonidos omitidos.
- Un reinicio del dispositivo invalida la base monotónica; un cierre del proceso también puede requerir reconstruir el controlador. Diseñar y probar una recuperación explícita, registrando la incertidumbre antes de reanudar; nunca inferir precisión a partir del reloj civil sin indicar el cambio de reloj.
- Live Activities son una presentación externa del estado, no el motor del cronómetro. Apple documenta un máximo de 8 horas de actividad activa; manejar actividad no disponible, denegada, agotada o caducada.

## Privacidad, permisos y almacenamiento

### Permisos mínimos

| Capacidad | Política QA |
|---|---|
| Notificaciones | Solicitar solo al explicar avisos o notificación persistente. En Android 13+ tratar `POST_NOTIFICATIONS` como permiso en tiempo de ejecución; denegarlo no debe bloquear el cronómetro. Un servicio en primer plano Android requiere su notificación aunque el permiso no se haya concedido. |
| Audio | No solicita permiso de micrófono. Activar TTS/sonido solo tras la preferencia o acción de la persona. Gestionar interrupciones de audio y evitar la categoría de fondo si no se reproduce contenido audible. |
| Vibración/háptica | No solicita permiso sensible; ofrecer ajuste de usuario y respetar modo silencioso/ajustes de accesibilidad de la plataforma. |
| HealthKit / Health Connect | No pedir al iniciar ni para el temporizador básico. Si se implementan, explicar cada finalidad y pedir solo tipos necesarios justo antes de usarlos; denegación/revocación no bloquea el resto de la app. No leer ni escribir muestras de salud por defecto. |
| Otros | No declarar ubicación, sensores corporales, actividad física, contactos, cámara, micrófono, Bluetooth ni acceso a fotos en la primera versión sin un requisito concreto aprobado. |

### Datos y cifrado

- Almacenar localmente únicamente entrenamientos, ajustes e historial de sesiones. No incorporar nombre real, correo, identificadores de publicidad o datos biométricos.
- La duración y el título de una rutina pueden ser datos personales por contexto. Excluir la base de datos del backup en nube por defecto, o explicar claramente el backup si se habilita.
- Si se añade información de salud o un campo sensible, cifrar la base en reposo y guardar la clave en Keychain/Android Keystore, nunca junto a la base ni en preferencias normales. Añadir pruebas de apertura/cierre, clave ausente, restauración desde backup y rotación de clave.
- Al borrar un entrenamiento o el historial, comprobar eliminación efectiva de las entradas relacionadas; incluir una acción para borrar todos los datos locales.
- No enviar datos ni telemetría en la versión inicial. El inventario de dependencias debe confirmar ausencia de SDKs de analítica, anuncios, atribución o crash reporting no declarados.

## Auditoría de seguridad de la compilación

Antes de cada publicación:

1. Revisar el manifiesto Android, `Info.plist`, entitlements y permisos efectivos del AAB/IPA exportado, no solo los archivos fuente.
2. Generar e inspeccionar el árbol completo de dependencias (`flutter pub deps`) y sus licencias; registrar versión, responsable y uso de cada plugin nativo.
3. Buscar permisos declarados, SDKs con recogida de datos, tráfico de red, URLs, logs con títulos de rutinas y uso de almacenamiento externo. Eliminar cualquier SDK no usado.
4. Analizar dependencias y artefactos con el escáner disponible en CI; resolver vulnerabilidades críticas/altas o documentar una excepción con alcance, mitigación y vencimiento.
5. Confirmar que no hay secretos, contraseñas, claves privadas ni keystores en Git, assets, preferencias, logs o informes de prueba.
6. Revisar que datos de historial no aparezcan en notificaciones de bloqueo si el usuario desactivó vistas previas; limitar la notificación persistente al nombre/estado necesario.
7. Repetir comprobaciones de privacidad de Apple y Play con los SDK y permisos exactos del artefacto que se enviará.

## Riesgos y limitaciones de plataforma

- iOS suele suspender apps al pasar a segundo plano; los modos de segundo plano solo están permitidos para sus usos declarados. El modo Audio está pensado para reproducir audio audible. No mantener un bucle silencioso para evitar suspensión: puede drenar batería y no representa la función declarada. Probar el motor con el dispositivo bloqueado y enviar avisos nativos solo cuando el usuario los permita.
- La programación de notificaciones locales puede verse afectada por ajustes del sistema, Focus, volumen o permisos. Los sonidos/TTS de la app y las notificaciones son canales distintos; describir al usuario cuáles funcionan con la app suspendida.
- Android 14+ exige declarar el tipo y permiso de cada Foreground Service. Un timer no debe etiquetarse automáticamente como `mediaPlayback` o `health`: validar el tipo adecuado, la justificación y las reglas actuales de Play. `specialUse` puede requerir explicación y revisión de Play. Mantener la notificación mientras el servicio está activo y detenerlo al pausar/finalizar.
- No añadir permiso de alarmas exactas por defecto. Android las reserva para funciones que realmente requieran acciones exactas y visibles para el usuario; el motor en memoria/foreground no necesita un permiso de alarma exacta.
- Una Live Activity puede ayudar con visibilidad, pero no garantiza que el proceso Flutter se ejecute ni que se reproduzca sonido. Mantener una fuente de tiempo en la app y tratar la actividad como interfaz con ciclo de vida propio.
- Los umbrales de consumo y la precisión final dependen de modelo, estado de batería, audio, permisos, OS y políticas del fabricante. Declarar resultados solo tras medir.

## Referencias oficiales consultadas

- [Apple: modos de ejecución en segundo plano](https://developer.apple.com/documentation/xcode/configuring-background-execution-modes)
- [Apple: configuración de reproducción de audio](https://developer.apple.com/documentation/avfoundation/configuring-your-app-for-media-playback)
- [Apple: App Review Guidelines, sección 2.5.4](https://developer.apple.com/app-store/review/guidelines/#software-requirements)
- [Apple: mostrar datos en Live Activities](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities)
- [Apple: autorización de HealthKit](https://developer.apple.com/documentation/healthkit/authorizing-access-to-health-data)
- [Apple: referencia de `mach_continuous_time()`](https://developer.apple.com/documentation/driverkit/mach_continuous_time)
- [Dart: API de `Stopwatch`](https://api.dart.dev/dart-core/Stopwatch-class.html)
- [Android: tipos requeridos para servicios en primer plano](https://developer.android.com/about/versions/14/changes/fgs-types-required)
- [Android: reloj monotónico `elapsedRealtime()`](https://developer.android.com/reference/android/os/SystemClock)
- [Android: permiso de notificaciones en tiempo de ejecución](https://developer.android.com/develop/ui/compose/notifications/notification-permission)
- [Android: cuándo programar alarmas exactas](https://developer.android.com/develop/background-work/services/alarms)
- [Android: inicio e integración de Health Connect](https://developer.android.com/health-and-fitness/health-connect/get-started)
- [Android: requisitos actuales de target API para Google Play](https://developer.android.com/google/play/requirements/target-sdk)
