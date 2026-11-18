# Store listing draft

**Status:** Draft for the first free release. The product name is provisional pending brand review. Copy below describes the requested v1 feature set; publish only after each claim is confirmed in the release build. No ad, purchase, subscription, watch app, or Health integration is included in this v1 copy.

## Product metadata

| Field | Spanish (Spain) | English |
|---|---|---|
| App name | Tempo: Workout Timer | Tempo: Workout Timer |
| App Store subtitle (30 characters max) | Intervalos a tu ritmo | Intervals at your pace |
| Google Play short description (80 characters max) | HIIT, Tabata y circuitos con intervalos, rondas y descansos claros | HIIT, Tabata and circuits with clear intervals, rounds and rest |

The names fit the current 30-character App Store and Google Play app-name limits. App Store subtitles are limited to 30 characters; Play short descriptions are limited to 80. [Apple metadata reference](https://developer.apple.com/help/app-store-connect/reference/app-information/app-and-compliance-information), [Google Play listing setup](https://support.google.com/googleplay/android-developer/answer/9859152?hl=en).

## App Store keywords

Keywords are comma-separated, do not repeat words already present in the name, and must stay within Apple's 100-byte limit. These suggestions intentionally omit competing app names and third-party marks. [Apple product-page guidance](https://developer.apple.com/app-store/product-page/).

- **ES:** `intervalos,hiit,tabata,circuito,cronómetro,descanso,rondas,series,emom,entrenar`
- **EN:** `interval,hiit,tabata,circuit,stopwatch,rest,rounds,sets,emom,training`

Recheck byte counts in App Store Connect after selecting the final localized name and subtitle.

## Long description — español

Tempo convierte una rutina en una secuencia fácil de seguir. Define el tiempo de preparación, trabajo y descanso, el número de rondas y las pausas entre bloques. Durante la sesión puedes pausar, reanudar, reiniciar o avanzar al siguiente intervalo.

**Organiza tu entrenamiento**

- Crea, edita, duplica, busca y ordena tus rutinas.
- Empieza con plantillas para HIIT 20/10, Tabata, EMOM, circuito, cardio libre y estiramientos.
- Elige avisos de sonido, voz y vibración para saber cuándo cambia cada fase.
- Revisa tus sesiones anteriores y el resumen semanal.
- Ajusta el idioma, el tema y las preferencias de pantalla.

Usa Tempo sin crear una cuenta. En esta primera versión, las rutinas y el historial se guardan en el dispositivo. La aplicación no incluye anuncios, compras ni suscripciones.

Tempo es un temporizador de entrenamiento; no ofrece consejo médico ni sustituye la orientación de un profesional.

## Long description — English

Tempo turns a workout into a sequence that is easy to follow. Set preparation, work and rest intervals, round counts and breaks between blocks. During a session, pause, resume, restart or move to the next interval.

**Plan your training**

- Create, edit, duplicate, search and sort your workouts.
- Start from templates for HIIT 20/10, Tabata, EMOM, circuits, free cardio and stretching.
- Choose sound, voice and vibration cues for phase changes.
- Review past sessions and a weekly summary.
- Adjust language, theme and screen preferences.

Use Tempo without creating an account. In this first release, workouts and history are stored on your device. The app includes no ads, purchases or subscriptions.

Tempo is a workout timer. It does not provide medical advice or replace guidance from a qualified professional.

## Screenshot plan

Use captures of the real app UI after the layouts are final. Keep the first three focused on the timer and controls; do not reuse any reference-app screenshot, device frame, logo or artwork. Localize text overlays and provide contextual alt text.

1. **Timer:** “Tu sesión, clara de un vistazo” / “Your session, clear at a glance”. Show work/rest phase, countdown and large pause/skip controls.
2. **Workout editor:** “Ajusta tiempos y rondas” / “Set your intervals and rounds”. Show work, rest, preparation and round settings.
3. **Templates:** “Empieza con una plantilla” / “Start from a template”. Show the original HIIT, Tabata and EMOM templates.
4. **History:** “Sigue tu ritmo semanal” / “See your weekly rhythm”. Show local history and a weekly chart with sample data.

### Current asset requirements to prepare

- **Apple app icon:** 1024 × 1024 px opaque PNG master, no transparency; prepare platform icon assets through the Xcode asset catalog. The Apple HIG defines a square 1024 px iOS/iPadOS icon. [Apple icon guidance](https://developer.apple.com/design/human-interface-guidelines/app-icons/).
- **App Store screenshots:** at least one screenshot for an iPhone with Dynamic Island at a required medium display size; current accepted portrait sizes include 1179 × 2556 and 1206 × 2622 px. If the app is submitted as supporting iPad, also provide at least one 13-inch iPad screenshot (2048 × 2732 or 2064 × 2752 px). Upload up to 10 screenshots per device size; no alpha channel. [Apple screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/).
- **Google Play icon:** 512 × 512 px PNG, maximum 1 MB. Google accepts alpha, but the supplied master will remain opaque as requested. [Play preview-asset requirements](https://support.google.com/googleplay/android-developer/answer/9866151?hl=en).
- **Google Play feature graphic:** 1024 × 500 px JPEG or 24-bit PNG, no alpha.
- **Google Play phone screenshots:** at least two screenshots across device types are required to publish; prepare four real 1080 × 1920 px portrait PNGs (9:16) to meet the recommendation threshold. Maximum eight per supported device type. No alpha; show the app itself and avoid small text or store-ranking/price claims. [Play screenshot guidance](https://support.google.com/googleplay/android-developer/answer/9866151?hl=en).

**Still to produce:** final 1024 px master icon, store-specific icon exports, 4 Spanish and 4 English captures, Play feature graphic, 13-inch iPad capture if iPad is enabled. These assets must come from Tempo's own UI and original artwork.

## Publication data disclosures — draft, not submitted

### Apple App Privacy

If the final binary and every included SDK keep all routine, settings and history data on-device, send no data to a server, and include no analytics/advertising SDK, the likely App Store Connect response is **“No, we do not collect data from this app.”** Apple says data processed only on-device is not “collected” for this label. This is a conditional recommendation, not an attestation; review the complete dependency list and network behavior before submission. If health, analytics, diagnostics, crash reporting, or a third-party speech service is added, redo the assessment. [Manage app privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy), [Apple App Privacy details](https://developer.apple.com/app-store/app-privacy-details/).

### Google Play Data safety

The Play Console Data safety form is required for apps on published test and production tracks, including apps that collect no user data; a privacy-policy URL is also required. If the final build has no off-device user-data transmission, no sharing, and no SDK collection, declare that no data is collected or shared. Audit third-party SDKs and actual permissions first; this draft is not a completed Play Console declaration. [Data safety section requirements](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en).

## Store review checklist

- [ ] Confirm the final name with brand review and perform formal trademark clearance before account/domain registration.
- [ ] Replace provisional app name and package identity consistently.
- [ ] Ensure screenshots, descriptions, privacy labels and version notes match the submitted binary; Apple requires accurate metadata and real in-app screenshots. [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/).
- [ ] Publish an active, public, non-PDF privacy-policy URL; include the link in the app and both console listings. Add a real privacy contact and publisher identity.
- [ ] Complete Apple privacy details and Google Data safety based on the exact release build and all SDKs.
- [ ] Confirm notification, health and background permissions are optional, requested in context, and explained.
- [ ] Confirm store listing does not promise Apple Watch, Wear OS, HealthKit, Health Connect, Live Activities or screen-off audio unless shipped and tested on each platform.
- [ ] Confirm no advertising identifiers, ad SDKs, account sign-in, hidden purchase screen or analytics endpoint is present in v1.
- [ ] Build and sign release artifacts with account-owned signing identities; exercise review flows on real devices.

### Later optional support purchase

The initial listing above remains fully free. If a later version adds the proposed €2.99 annual “Invita una cerveza al creador” support option, revisit its product type before implementation. Apple permits IAP tips, but an auto-renewable subscription must provide ongoing value; a bare recurring tip may not satisfy that rule. Google Play currently treats a 100%-to-creator tip with no digital benefit as a peer-to-peer payment outside Play Billing, although use of Play Billing remains an available implementation choice. If any purchase is enabled, disclose price and terms clearly, use platform purchase APIs, offer restore/management paths where applicable, and leave all timer functions available to non-payers. [Apple payment guidelines](https://developer.apple.com/app-store/review/guidelines/#payments), [Google Play payments policy](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en), [Google policy explanation](https://support.google.com/googleplay/android-developer/answer/10281818?hl=en).

## Source review record

Pages checked 18 November 2026: [App Store reference listing](https://apps.apple.com/es/app/timer-plus-workouts-timer/id1279716547), [Google Play reference listing](https://play.google.com/store/apps/details?id=com.vgfit.timerplus&hl=es), and the official store documentation linked above. The public listings were inspected using REA's documented browser-scenario workflow. REA evidence IDs: `ev_f52e45112a17f40d036d76b6bc8b3cf4617c0a500dadf43c37f5882ce7e03b6c` (App Store), `ev_d3a90ca68da6d9f836fac4bd2f71a62594aa6c7f8401e6fb696a9192a10e37d2` (Google Play). Only public storefront pages were observed; no app package or binary was acquired.
