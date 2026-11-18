# Tempo Workout Timer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build an offline-first Flutter workout timer for iOS and Android with routines, interval sessions, configurable cues, history, settings, onboarding, and store-ready project configuration.

**Architecture:** Riverpod 3 owns app state and dependency injection; a pure Dart timer engine consumes an injected monotonic clock and validated workout plan. Hive CE stores encrypted workout/session records, preferences stay in SharedPreferences, and narrowly scoped native adapters provide screen-off timing and platform surfaces.

**Tech Stack:** Flutter 3.50/Dart 3.14, Riverpod 3, Hive CE, SharedPreferences, `flutter_secure_storage`, native Kotlin/Swift method channels, Flutter localization, widget/unit/integration tests.

**Spec:** `docs/FEATURES.md`, `docs/ARCHITECTURE.md`, `docs/DESIGN.md`, `docs/QA_SECURITY.md`, `docs/PRIVACY.md`, `docs/STORE_LISTING.md`.

## Global Constraints

- Flutter is the shared iOS/Android framework; use Riverpod for state and Hive CE for workout/session persistence.
- The app works offline and has no required account, backend, advertising SDK, or purchase in version 1.
- iOS deployment target is 16.0 or higher; Android `minSdk` is 24 and `targetSdk` is 36 for the current Play submission requirement.
- Timer elapsed time comes from a monotonic clock that includes device sleep: Android `SystemClock.elapsedRealtimeNanos()` and iOS `mach_continuous_time()`. UI tickers only repaint.
- Keep reference research clean-room. Do not include Timer Plus assets, copy, code, audio, name, or screen composition.
- Spanish and English are supported; use scalable text, semantic controls, high contrast, and large touch targets.
- HealthKit, Health Connect, Apple Watch, Wear OS, and optional support purchases are not launch requirements for the first build unless their native targets and device tests are completed; never claim they work when they are absent.
- Keep signing credentials and keystores outside Git. The workspace is Windows; iOS simulator/archive/signing requires macOS and Xcode.

## Review Focus

- Device sleep or a wall-clock adjustment must not make a running session lose or add elapsed time. Pin with `timer_engine_counts_sleep_between_updates` and native clock bridge checks.
- Several phase boundaries crossed while the app is suspended must result in one correct current phase and no delayed burst of cues. Pin with `timer_engine_catches_up_across_multiple_boundaries` and `timer_controller_emits_no_stale_cues_on_resume`.
- Pause, restart, skip-last-phase, zero-rest, and end-of-plan must not duplicate or omit a workout history entry. Pin with `timer_engine_pause_resume_preserves_elapsed`, `timer_engine_skip_advances_one_phase`, and `session_repository_records_completion_once`.
- Encrypted local storage must not silently replace existing data if a key is missing or invalid. Pin with `workout_repository_keeps_existing_box_when_key_is_unavailable`.
- 200% text, dark mode, and VoiceOver/TalkBack must keep all primary actions reachable and distinguishable. Pin with `timer_screen_scales_without_hiding_actions` and `timer_screen_exposes_semantic_control_labels`.

---

### Task 1: Create the Flutter app scaffold and quality baseline

**Files:**
- Create/copy Flutter scaffold files: `pubspec.yaml`, `analysis_options.yaml`, `.metadata`, `android/**`, `ios/**`, `lib/main.dart`, `test/**`, `integration_test/**`.
- Modify: `.gitignore`, `README.md` only for build commands and package metadata.
- Test: `test/app_smoke_test.dart`.

**Interfaces:**
- Produces the Flutter app target `tempo_workout_timer`, package namespace `com.saretech.tempo`, iOS bundle placeholder `com.saretech.tempo`.
- Establishes app entrypoint `lib/main.dart` and test command baseline.

- [ ] Generate a temporary Flutter 3.50 iOS/Android app scaffold and copy only generated app files, preserving project docs and `assets/branding/`.
- [ ] Write `app_smoke_test.dart` asserting that app startup exposes the Tempo home heading and the primary “Entrenamientos” action.
- [ ] Run `flutter test test/app_smoke_test.dart` and record the expected failure before the home screen exists.
- [ ] Implement a minimal `ProviderScope` app entry and home shell that makes the test pass.
- [ ] Run `flutter analyze` and the smoke test; resolve all project-owned warnings and failures.

### Task 2: Workout model, validation, presets, and timer engine

**Files:**
- Create: `lib/features/workouts/domain/workout_plan.dart`, `lib/features/workouts/domain/workout_validation.dart`, `lib/features/workouts/data/workout_templates.dart`.
- Create: `lib/core/clock/monotonic_clock.dart`, `lib/features/timer/domain/timer_phase.dart`, `lib/features/timer/domain/timer_snapshot.dart`, `lib/features/timer/domain/timer_engine.dart`.
- Test: `test/features/workouts/domain/workout_validation_test.dart`, `test/features/workouts/data/workout_templates_test.dart`, `test/features/timer/domain/timer_engine_test.dart`.

**Interfaces:**
- `WorkoutBlock({required String id, required String name, required int workSeconds, int restAfterSeconds = 0})`.
- `WorkoutPlan({required String id, required String name, WorkoutMode mode = WorkoutMode.intervals, required List<WorkoutBlock> blocks, int preparationSeconds = 5, int rounds = 1, int sets = 1, int restBetweenRoundsSeconds = 0, int restBetweenSetsSeconds = 0, int cooldownSeconds = 0, DateTime? createdAt, DateTime? updatedAt, DateTime? lastUsedAt, bool isBuiltIn = false})`; modes are `intervals` and count-up `stopwatch`.
- `MonotonicClock.nowMicroseconds() -> int`; `FakeMonotonicClock` implements this contract in tests.
- `TimerEngine({required WorkoutPlan plan, required MonotonicClock clock})`; public operations: `start()`, `pause()`, `resume()`, `restart()`, `skipPhase()`, `advance()`, `snapshot`.
- `TimerPhase.kind` is `preparation`, `work`, `rest`, `roundRest`, `setRest`, `cooldown`, `stopwatch`, or `finished`; each phase carries `label`, `durationSeconds`, `roundNumber`, `setNumber`, and `blockIndex`. `TimerSnapshot` carries `status`, `phase`, nullable `phaseRemaining` (null only for stopwatch), `elapsed`, `completedWorkBlocks`, and newly crossed `events`.
- `TimerEngine.stop()` completes a freely running stopwatch or stops an interval session without marking it complete.
- `WorkoutTemplates.all` returns original templates: HIIT 20/10, Tabata 20/10 × 8, EMOM, Circuit, Free cardio stopwatch, Stretching.

- [ ] Write tests for template shape (including count-up Cardio libre), invalid durations/counts, empty interval plan, and immutable built-in templates.
- [ ] Run the focused test file and confirm failures on missing model/validation/template APIs.
- [ ] Implement model validation and the six deterministic templates.
- [ ] Write timer-engine tests for prepare/work/rest/round/set/cooldown/finish, count-up stopwatch, countdown cues, pause/resume, restart, stop/skip, zero rests, late frames, multiple crossed boundaries, and device-sleep elapsed time.
- [ ] Run focused tests and confirm failures before implementing engine behavior.
- [ ] Implement the pure Dart engine using `nowMicroseconds()`; ticks never decrement a stored seconds counter.
- [ ] Run all domain tests and confirm every phase transition and cue event is deterministic under the fake clock.

### Task 3: Native monotonic clock and active-session persistence

**Files:**
- Create: `lib/core/clock/platform_monotonic_clock.dart`, `android/app/src/main/kotlin/com/saretech/tempo/MonotonicClock.kt`, `ios/Runner/MonotonicClock.swift`.
- Create: `lib/features/timer/data/active_session_store.dart`, `lib/features/timer/application/timer_controller.dart`.
- Modify: Android `MainActivity.kt`, iOS `AppDelegate.swift` to register the narrow clock channel.
- Test: `test/features/timer/application/timer_controller_test.dart` and Android native clock test or instrumentation check.

**Interfaces:**
- `PlatformMonotonicClock` implements `MonotonicClock`; MethodChannel name is `com.saretech.tempo/clock`, method `nowMicroseconds`.
- Android uses `SystemClock.elapsedRealtimeNanos() ~/ 1000`; iOS converts `mach_continuous_time()` with `mach_timebase_info` to microseconds.
- `TimerController` exposes `state`, `start(WorkoutPlan)`, `pause()`, `resume()`, `restart()`, `skipPhase()`, `refresh()`, and `onLifecycleResume()`.
- Active snapshot stores the plan ID, engine elapsed microseconds, status, and monotonic checkpoint; an unresolvable device reboot/process interruption is marked interrupted rather than falsely completed.

- [ ] Write controller tests for start, pause/resume, skip, restart, lifecycle catch-up, and no stale cue replay.
- [ ] Implement clock and controller adapters while keeping platform-channel calls outside the timer engine.
- [ ] Persist checkpoints at user actions and phase changes; recover to running only when the monotonic checkpoint is still valid.
- [ ] Run Dart unit tests and Android tests; document iOS native verification as pending on this Windows host.

### Task 4: Offline storage, encryption, and repository tests

**Files:**
- Create: `lib/core/database/database_provider.dart`, `lib/core/database/key_store.dart`, `lib/features/workouts/data/workout_repository.dart`, `lib/features/history/domain/workout_session.dart`, `lib/features/history/data/session_repository.dart`.
- Modify: `pubspec.yaml` for Hive CE and secure storage packages.
- Test: `test/features/workouts/data/workout_repository_test.dart`, `test/features/history/data/session_repository_test.dart`.

**Interfaces:**
- `WorkoutRepository`: `list()`, `getById(id)`, `save(plan)`, `duplicate(id)`, `delete(id)`, `search(query)`, `sortByName()`, `sortByUpdatedAt()`.
- `WorkoutSession`: `id`, `workoutId`, `workoutName`, `startedAt`, `durationSeconds`, `completedRounds`, `completedSets`, `wasCompleted`.
- `SessionRepository`: `list()`, `recordCompleted(session)`, `delete(id)`, `clear()` and weekly totals.
- Store JSON-encoded values in Hive CE encrypted boxes; generate the 256-bit key once and store it via Keychain/Keystore backed secure storage. Never replace an encrypted file after key retrieval failure.

- [ ] Write repository tests for CRUD, duplicate IDs, sorting/search, encrypted reopen, deletion, and missing/wrong key.
- [ ] Run focused tests and verify intended failure before repository implementation.
- [ ] Implement encrypted Hive boxes and repository interfaces with in-memory test adapters only in test code.
- [ ] Run repository tests and check that deleting a workout does not mutate historical session snapshots.

### Task 5: Localization, theme system, settings, and onboarding

**Files:**
- Create: `lib/core/theme/app_theme.dart`, `lib/core/theme/tempo_tokens.dart`, `lib/core/localization/locale_controller.dart`, `lib/features/settings/domain/app_settings.dart`, `lib/features/settings/data/settings_repository.dart`, `lib/features/settings/presentation/settings_screen.dart`, `lib/features/onboarding/presentation/onboarding_screen.dart`, `lib/l10n/app_es.arb`, `lib/l10n/app_en.arb`.
- Modify: `pubspec.yaml` Flutter localization configuration and `lib/app/tempo_app.dart`.
- Test: `test/features/settings/settings_screen_test.dart`, `test/features/onboarding/onboarding_screen_test.dart`.

**Interfaces:**
- `AppSettings`: `locale`, `themeMode`, `metricUnits`, `soundEnabled`, `voiceEnabled`, `hapticsEnabled`, `keepScreenOn`, `backgroundCuesEnabled`.
- Settings persist locally in SharedPreferences; no health, notification, or exact-alarm permission is requested during onboarding.
- Theme uses “Pulso mineral” tokens from `docs/DESIGN.md`; controls have at least 56 dp targets and 12 dp spacing.

- [ ] Add widget tests for first-run onboarding, skip/complete behavior, Spanish/English switch, system locale, light/dark/auto, and each settings toggle.
- [ ] Run focused tests and confirm failure before building the settings/onboarding screens.
- [ ] Implement locale and theme providers, settings persistence, and skippable onboarding.
- [ ] Run widget tests, verify text scaling at 200%, and inspect primary semantic labels for VoiceOver/TalkBack.

### Task 6: Workout library, editor, search, and sorting

**Files:**
- Create: `lib/features/workouts/presentation/workout_list_screen.dart`, `lib/features/workouts/presentation/workout_editor_screen.dart`, `lib/features/workouts/presentation/workout_tile.dart`.
- Test: `test/features/workouts/presentation/workout_library_test.dart`.

**Interfaces:**
- UI consumes `WorkoutRepository` and `WorkoutTemplates`; it never writes Hive directly.
- Operations: create, edit, duplicate, delete, search by name, sort by name/last used.
- Built-in templates are copied before editing; delete requires clear confirmation.

- [ ] Write widget tests for template visibility, search/sort, create/edit/duplicate/delete, invalid values, and persistence across provider rebuild.
- [ ] Run focused tests and confirm failures before implementing the library UI.
- [ ] Implement library/editor screens in the “Pulso mineral” theme with scalable fields and large actions.
- [ ] Run library tests and verify no destructive change to built-in template definitions.

### Task 7: Timer experience, sound/voice/haptics, and weekly history

**Files:**
- Create: `lib/features/timer/presentation/timer_setup_screen.dart`, `lib/features/timer/presentation/active_timer_screen.dart`, `lib/core/audio/cue_player.dart`, `lib/core/audio/speech_cue.dart`, `assets/audio/cue_start.wav`, `assets/audio/cue_phase.wav`, `assets/audio/cue_finish.wav`.
- Create: `lib/features/history/presentation/history_screen.dart`, `lib/features/history/presentation/weekly_summary_chart.dart`.
- Modify: navigation routes and session record flow.
- Test: `test/features/timer/presentation/active_timer_screen_test.dart`, `test/features/history/presentation/history_screen_test.dart`.

**Interfaces:**
- Timer controls call `TimerController`; the visible clock renders `phaseRemaining` and does not schedule authoritative time through `Timer.periodic`.
- `CuePlayer` and `SpeechCue` follow `AppSettings` and may be replaced by no-op fakes in widget tests.
- History displays a list plus an accessible seven-day summary with text values available outside the chart.

- [ ] Write widget tests for countdown/phase labels, pause/resume/restart/skip, completion summary, enabled/disabled cue preferences, history, and weekly totals.
- [ ] Run focused tests and confirm failure before implementing the screens/audio adapters.
- [ ] Generate short original WAV cues; implement TTS in the system locale and haptics through Flutter platform feedback.
- [ ] Implement active timer and history screens with large controls, phase label + shape, and no rapid accessibility announcements.
- [ ] Run widget tests and record a screen capture from a running emulator if the Android emulator is available.

### Task 8: Native background surfaces and display-awake behavior

**Files:**
- Modify Android service/manifest and notification channel for an ongoing session; keep minSdk 24/targetSdk 36.
- Modify iOS local-notification setup, ActivityKit/WidgetKit targets, Live Activity attributes, App Group only if used, and Background Modes only for real audible playback.
- Modify: timer controller to schedule/cancel upcoming phase cues and wakelock lifecycle.
- Test: `integration_test/background_timer_test.dart`; native permission/notification checks on devices.

**Interfaces:**
- `BackgroundCueScheduler` schedules/cancels native phase-change cues and reports permission/capability state; it never owns elapsed-time truth.
- Android active-session notification displays phase, remaining time and pause/stop actions; service stops on pause/end.
- iOS Live Activity displays only minimal session fields; local notifications are best-effort. Never use silent background audio to keep Flutter running.
- `keepScreenOn` is opt-in and releases on pause/end/background.

- [ ] Write integration scenarios for notification denial, locked screen, pause, resume, skip, and stop.
- [ ] Implement Android notification/service using a Play-policy-valid foreground-service type; do not label it `health` or `mediaPlayback` without the required behavior.
- [ ] Implement iOS Live Activity/local cue scaffold and verify with Xcode on a Mac before claiming it complete.
- [ ] Run Android emulator integration checks and document any iOS/device-only checks not executable here.

### Task 9: Store assets, release configuration, verification, and final report

**Files:**
- Modify: Android release signing configuration and R8 rules, iOS bundle/project settings, `README.md`, `CHANGELOG.md`, `docs/TEAM.md`, `docs/PRIVACY.md`, `docs/STORE_LISTING.md`.
- Create: store screenshot layouts/captures under `assets/store/` and `docs/FINAL_REPORT.md`.
- Test: complete unit/widget/integration suites; `flutter analyze`; inspect Android manifest/permissions and built AAB.

**Interfaces:**
- Release signing reads only untracked local/CI credentials. No keystore, signing password, Team ID, certificate, or App Store Connect secret is committed.
- Store privacy declarations match the built dependency tree and artifact, not this plan alone.
- `docs/FINAL_REPORT.md` separates implemented, pending, blocked, and measured behavior.

- [ ] Write the final install/build/test instructions and platform-specific permissions based on implemented code.
- [ ] Run `flutter pub get`, `flutter analyze`, `flutter test`, and `flutter test integration_test`; report all results by command.
- [ ] Build an Android debug app and release AAB if signing configuration is available; inspect target SDK, permissions, R8 output, and signature.
- [ ] On a Mac with Xcode, archive iOS, test simulator/device, and verify bundle signing; this cannot be completed on Windows.
- [ ] Generate store screenshots from the implemented app at current store sizes; verify the icon is 1024×1024 and opaque.
- [ ] Update the privacy policy and store declarations from the final dependency/permission audit.
- [ ] Write the final report with function coverage, tests/builds, unresolved brand and platform dependencies, risks, and the GitHub branch/commit.

