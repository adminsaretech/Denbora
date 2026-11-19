# Tempo architecture

**Status:** design baseline with the current Flutter foundation implemented. This document distinguishes app-owned behavior from native OS work that still needs implementation and device/store validation.

## Implementation snapshot — 19 November 2026

Implemented in the current branch: Riverpod shell, encrypted Hive CE repositories, platform monotonic clock source, timer state machine/controller, workout CRUD and templates, timer and history screens, ES/EN settings/onboarding, original WAV cues, system TTS, haptics, and opt-in screen wakelock. Android sets minSdk 24 and targetSdk 36; iOS sets iOS 16 and bundle ID `com.saretech.tempo`.

Not implemented yet: Android foreground service/ongoing notification, iOS local notification/ActivityKit Live Activity, health/watch integrations, release signing keys/configuration, and store-ready real-device screenshots. `flutter test` and `flutter analyze` run on Windows; Xcode signing, simulator and device checks require macOS.

## Decisions

| Area | Choice | Reason |
|---|---|---|
| Client | Flutter, one iOS/Android codebase | Required by the product brief; current stable docs list Flutter 3.50.0 (11 Nov 2026). |
| State and dependency injection | Riverpod 3 | Explicitly testable providers fit the timer engine, repository boundaries, and independently optional platform services. |
| Local persistence | Hive CE with encrypted boxes | Small offline workout and session data set; built-in AES-256-CBC encryption; no service or account required. |
| Settings | SharedPreferences only for non-sensitive display preferences | Keep preferences separate from workout/session records. Do not place a database key in preferences. |
| Localization | Flutter `gen_l10n`, `es` and `en` ARB files | Use system locale on first launch, with a setting to override it. |
| Timer | Pure Dart elapsed-time state machine behind an injected `MonotonicClock`; Android uses `SystemClock.elapsedRealtimeNanos()` and iOS uses `mach_continuous_time()` | Both platform clocks include device sleep. UI refresh ticks never determine elapsed time and cannot accumulate drift. |
| Native background UX | Platform adapters: Android ongoing notification/service, iOS local notifications and ActivityKit Live Activity | Native surfaces show the session while Flutter UI is not foregrounded; OS policies still bound execution. |

Use Flutter 3.50 stable as the baseline for initial implementation and commit `pubspec.lock`. Recheck the stable channel and current store submission requirements before release. Riverpod 3.5.0 and Hive CE 2.23.3 are the current package versions when this design was written; prefer compatible current stable releases when resolving dependencies instead of copying these version numbers blindly. ([Flutter release notes](https://docs.flutter.dev/release/whats-new), [flutter_riverpod](https://pub.dev/packages/flutter_riverpod), [hive_ce](https://pub.dev/packages/hive_ce)).

## Dependency boundaries

The domain must not import Flutter widgets, Hive, notification plugins, or platform-channel code. Repositories and adapters sit outside the domain and are injected at the feature boundary.

```text
lib/
  app/                         App shell, router, theme selection
  core/
    clock/                     MonotonicClock, fake clock, elapsed-time rules
    database/                  Hive CE setup, encryption key, type adapters
    localization/              locale controller and generated strings
    notifications/             notification port and platform adapters
    audio/                     sound and system TTS ports
    platform/                  lifecycle bridge, wakelock, native capability checks
    theme/                     color, type, spacing, accessibility tokens
    widgets/                   shared large controls and semantic helpers
  features/
    timer/
      domain/                  workout plan projection, TimerEngine, TimerState
      application/             Riverpod controllers and commands
      data/                     timer cue scheduling and active-session recovery
      presentation/             timer setup and in-session screens
    workouts/
      domain/                   WorkoutPlan, interval blocks, validation rules
      data/                     Hive repository and original starter templates
      presentation/              list, search, create, edit, duplicate, delete
    history/
      domain/                   WorkoutSession, weekly aggregation
      data/                     session repository
      presentation/              session list and weekly chart
    settings/
      domain/                   typed preferences
      data/                     settings repository
      presentation/              language, theme, sounds, haptics, display options
    onboarding/
      presentation/              first-run, skippable explanation of permissions
  l10n/                         app_es.arb, app_en.arb
test/                            unit, repository, and widget tests
integration_test/                end-to-end flows on simulator/emulator
ios/                             Xcode app and WidgetKit/ActivityKit extension
android/                         app target and foreground-service implementation
```

The initial package set should be limited to `flutter_riverpod`, `hive_ce`, `hive_ce_flutter`, `flutter_secure_storage`, `flutter_local_notifications`, `flutter_tts`, and a small sound playback package if native notification sounds do not cover the foreground case. Add `wakelock_plus` only for the explicit “keep display awake” setting; acquire it only while the workout is visible/active and release it on pause, finish, or background. Use Flutter's own localization and animation APIs where possible. Add Health Connect, HealthKit, Watch, or purchase plugins only when those features enter scope.

## Timer model and precision

Represent a workout as a validated sequence: preparation countdown, work/rest blocks, repetitions, rounds/sets, optional between-set rest, and optional cooldown. Keep these rules in a pure Dart `TimerEngine` that accepts an injected monotonic clock. Platform implementations return an integer monotonic timestamp over a narrow method channel: Android `SystemClock.elapsedRealtimeNanos()` and iOS `mach_continuous_time()` converted with `mach_timebase_info`. A `Stopwatch` is useful in deterministic Dart-only tests and as a foreground fallback, but is not the source for screen-off time unless device tests establish that it includes suspend on the supported OS versions.

The running engine records the monotonic elapsed offset at start/resume and derives the current phase from elapsed duration and the workout sequence. Pausing freezes the elapsed offset; resuming starts a new monotonic segment. Skipping advances the sequence cursor and resets the phase origin. Restart returns to the first countdown state. At completion, persist the actual elapsed duration and the number of work phases completed.

Use the injected platform monotonic clock as the source of elapsed time. A Flutter `Ticker` may request display rebuilds while the screen is visible, but every frame reads elapsed time from the clock; no `Timer.periodic` decrement loop is authoritative. On lifecycle resume, recompute the phase from elapsed time and emit every newly crossed phase event once. Inject a fake clock in unit tests to cover pause/resume, skips, long suspension, multiple boundaries crossed in one frame, and precision tolerance. ([Android `elapsedRealtimeNanos`](https://developer.android.com/reference/android/os/SystemClock#elapsedRealtimeNanos()), [Apple `mach_continuous_time`](https://developer.apple.com/documentation/driverkit/mach_continuous_time), [Dart `Stopwatch`](https://api.dart.dev/dart-core/Stopwatch-class.html), [Flutter `Ticker`](https://api.flutter.dev/flutter/scheduler/Ticker-class.html)).

Persist a recoverable active-session snapshot at state changes and phase boundaries. A process restart cannot restore a previous process's in-memory monotonic stopwatch. If the process is killed, mark the session interrupted unless a native adapter can validate a continuing OS session; do not silently claim a completed workout based on a changed wall clock.

## Background behavior and platform constraints

“Screen off” support has two layers: the clock model must catch up accurately whenever it gets CPU time again, and native mechanisms must deliver useful cues while the app is suspended. Neither Live Activities nor a notification is a background Dart runtime.

| Platform | First implementation | Constraint and fallback |
|---|---|---|
| Android | User-started ongoing session with a visible persistent notification and a native foreground service. Keep the authoritative deadline in elapsed-realtime time; schedule only the next phase cue, then reschedule on delivery. Stop the service on pause/end. | API 34+ requires a valid foreground-service type. `health` requires sensor/health permissions the basic timer does not need; do not declare it just to keep a countdown alive. If no other declared service type fits, `specialUse` requires a clear manifest subtype and Google Play review. Exact alarms require the “Alarms & reminders” special access on Android 12+ and should be requested only if the precise user-noticeable interval cues justify it. If unavailable, preserve the deadline and show best-effort notification timing; explain this in settings. |
| iOS | Schedule local sound/voice notifications for imminent cues where allowed, cancel/rebuild them on pause/skip, and show current phase/deadline in a Live Activity on supported iOS 16.1+ devices. Use actual audio playback for sound/voice cues. | iOS normally suspends background apps; enabling Background Modes > Audio is only for audible playback, not silent keep-alive. Live Activities display data but do not run the Flutter engine. iOS retains at most 64 pending local notifications, so long plans/three-second countdowns need a rolling schedule and foreground fallback. If notifications are disabled or the process is terminated, reliable audible cues cannot be promised. |

The Android Play target for new submissions is API 36 from 31 August 2026. iOS deployment minimum is 16.0; Live Activities require a supported OS/device and are available beginning with iOS 16.1. The app should remain usable without either background extension. ([Android target API requirement](https://developer.android.com/google/play/requirements/target-sdk), [Android foreground service types](https://developer.android.com/develop/background-work/services/fgs/service-types), [Android alarm scheduling](https://developer.android.com/develop/background-work/services/alarms), [Apple background execution modes](https://developer.apple.com/documentation/xcode/configuring-background-execution-modes), [Apple Live Activities](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities), [Apple notification plugin limitations](https://pub.dev/packages/flutter_local_notifications)).

Do not play an inaudible looping audio track to bypass iOS suspension. The background audio entitlement must match the product’s real sound and voice use. Measure battery draw before enabling longer service or wakelock behavior by default.

## Native features and permissions

- **Notifications:** request only when a user starts a session or enables background cues. Android 13+ has a runtime notification permission. Offer a clear in-app explanation and a degraded no-notification path.
- **Audio/TTS:** use short original cue sounds and the operating system’s speech voice for the selected/system language. Audio is optional, respects the device’s audio focus, and can be configured per cue.
- **Haptics:** call native vibration only when enabled; do not request a separate dangerous permission for standard haptic feedback on supported devices.
- **Display awake:** off by default and active only during the session; user may opt out or use system screen behavior.
- **Health data:** exclude HealthKit and Health Connect from the first functional build unless a concrete export feature is approved. If added, request write-only workout/session data first and explain the purpose before the system prompt; request read permissions only for an implemented feature. Never require account sign-in. Google Fit APIs are scheduled to be supported only through the end of 2026, so a new Android integration should use Health Connect instead. ([Apple HealthKit permissions](https://developer.apple.com/documentation/healthkit/authorizing-access-to-health-data), [Android Health Connect](https://developer.android.com/health-and-fitness/health-connect), [Google Fit migration guidance](https://developer.android.com/health-and-fitness/health-connect/migration/fit)).
- **Apple Watch / Wear OS:** separate companion targets are a later project phase. The first release keeps workout setup and execution on the phone. Do not list watch support in store metadata until a watch app and device test exist.
- **iOS Live Activity:** add a WidgetKit extension and App Group only when implementing the native feature. Share only a minimal session identifier, phase label, and end time; write through the app/extension boundary and end the activity on pause/finish. Dynamic Island is available only on supported iPhone hardware. ([ActivityKit setup](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities)).
- **Android foreground session:** use a notification channel with controls where supported. Store service state in native code only as a small elapsed-realtime deadline/session snapshot; never persist duplicate workout database data in the service.

## Privacy and local data

No backend or account is required. Workouts, history, and user-entered labels remain on-device. Encrypt Hive boxes that hold workout/history data with `HiveAesCipher`; create the random 256-bit database key once and protect it with iOS Keychain / Android Keystore via `flutter_secure_storage`. Exclude secrets and health records from logs, analytics, crash reports, and backups. If the key is unavailable, do not silently create a replacement database over the existing encrypted file; show a recovery/error path.

Store only non-sensitive presentation settings in preferences. The app has no ad SDK, tracker, or analytics dependency in the launch scope. If a future optional Health integration is enabled, data remains optional and permission-scoped; document each data type, use, deletion path, and store declaration before shipping it.

Hive CE documents built-in AES-256-CBC with PKCS7 padding. This cipher does not authenticate records; do not treat it as tamper detection or a replacement for Android/iOS filesystem protection and careful key lifecycle management. If future scope stores clinical records or other highly sensitive health data, revisit the persistence layer and use authenticated encryption before implementing that feature. ([Hive AES cipher reference](https://pub.dev/documentation/hive_ce/latest/hive_ce/HiveAesCipher-class.html), [Apple HealthKit privacy](https://developer.apple.com/documentation/healthkit/)).

## Build and release environment

### iOS

- Build on macOS with current App Store submission-compatible Xcode; current Xcode release notes list Xcode 26.6. It requires macOS Sequoia 15.6 or later. The current Windows workspace cannot create or run an Xcode archive/simulator build.
- Set iOS deployment target to 16.0. Use an Apple Developer Team ID and signing certificate supplied by the account owner; do not commit signing files or credentials.
- Add Background Modes > Audio only for real cue playback. Add ActivityKit/WidgetKit extension and App Group only when the Live Activity implementation exists. Add HealthKit capability and purpose strings only after the integration is implemented.
- Local check on a Mac: `flutter doctor -v`, `flutter pub get`, `flutter analyze`, `flutter test`, `flutter test integration_test`, then `flutter build ipa --release` after configuring the bundle ID and signing team. Run simulator tests through Xcode and verify sound, lock screen, interruptions, notification denial, and process termination on a physical iPhone.

### Android

- Set `minSdk` to 24 and `targetSdk` to 36. Use current Android Studio/Android SDK Build Tools. Include R8/ProGuard rules only for plugins that need them; keep release minification enabled and verify native service/plugin names after shrinking.
- Configure release signing through Gradle properties/environment variables or an untracked local properties file. Keep the keystore and passwords out of Git. If producing a signed AAB, document where the owner stores the key and verify the artifact signature.
- Local build: install Flutter stable and Android Studio SDK, accept SDK licenses, set up the release signing values, then run `flutter doctor -v`, `flutter pub get`, `flutter analyze`, `flutter test`, `flutter test integration_test`, and `flutter build appbundle --release`.
- Test on API 24 and a current API 36 emulator/device, including notification permission denial, exact-alarm access denial, battery saver/Doze, screen-off session, pause/resume, app force-stop, and app upgrade with existing encrypted data.

The Android API target follows the current Play requirement; Xcode 26.6/macOS requirements are drawn from Apple's current release notes. ([Google Play target API requirement](https://developer.android.com/google/play/requirements/target-sdk), [Xcode 26.6 release notes](https://developer.apple.com/documentation/xcode-release-notes)).

## Test seams

- Inject `MonotonicClock`, cue scheduler, repositories, and platform capability adapters through Riverpod providers.
- Unit tests cover duration math, all sequence transitions, no duplicate cues after resume, deterministic pause/restart/skip behavior, and many phase crossings during one missed UI frame.
- Repository tests cover encrypted Hive open/read/write, schema migration, missing/wrong-key behavior, and deletion.
- Widget tests cover accessible labels, text scaling, high-contrast themes, large pause/skip controls, Spanish/English strings, and permission-denied states.
- Integration tests cover create/edit/duplicate/delete, built-in templates, session/history, settings persistence, background/resume, and notifications on real simulator/emulator configurations.

## Current scope boundary

This document is a design and build contract, not proof that native background services, health data, watches, Live Activities, store signing, or store compliance have been implemented. The user brief requires those optional integrations to be explained; each must be marked implemented only after native code, device tests, permission flows, and policy review are complete.
