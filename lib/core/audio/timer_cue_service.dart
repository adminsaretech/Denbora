import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../features/settings/domain/app_settings.dart';
import '../../features/timer/domain/timer_phase.dart';
import '../../features/timer/domain/timer_snapshot.dart';

/// Plays only original, bundled tones and asks the device TTS engine to speak.
class TimerCueService {
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  bool _skipInitialPhaseCue = false;
  String? _configuredLanguage;
  int _speechSequence = 0;
  Future<void> _speechChain = Future<void>.value();

  void handle(TimerEvent event, AppSettings settings) {
    if (event.kind == TimerEventKind.started) _skipInitialPhaseCue = true;

    final asset = _assetFor(event);
    if (settings.soundEnabled && asset != null) {
      unawaited(
        _player
            .play(
              AssetSource(asset),
              ctx: AudioContextConfig(
                focus: AudioContextConfigFocus.mixWithOthers,
              ).build(),
            )
            .catchError((_) {}),
      );
    }

    if (!settings.voiceEnabled) return;
    final phrase = _phraseFor(event);
    if (phrase != null) _queueSpeech(phrase);
  }

  String? _assetFor(TimerEvent event) => switch (event.kind) {
    TimerEventKind.started => 'audio/tempo-start.wav',
    TimerEventKind.phaseChanged =>
      _skipInitialPhaseCue
          ? _consumeInitialPhaseCue()
          : 'audio/tempo-transition.wav',
    TimerEventKind.countdown => 'audio/tempo-countdown.wav',
    TimerEventKind.completed => 'audio/tempo-finish.wav',
    TimerEventKind.resumed ||
    TimerEventKind.skipped ||
    TimerEventKind.stopped => null,
  };

  String? _consumeInitialPhaseCue() {
    _skipInitialPhaseCue = false;
    return null;
  }

  String? _phraseFor(TimerEvent event) {
    final spanish = Platform.localeName.toLowerCase().startsWith('es');
    return switch (event.kind) {
      TimerEventKind.started => null,
      TimerEventKind.phaseChanged => _phasePhrase(event.phase.kind, spanish),
      TimerEventKind.countdown => '${event.countdownSeconds}',
      TimerEventKind.completed =>
        spanish ? 'Sesión completada' : 'Workout complete',
      TimerEventKind.resumed ||
      TimerEventKind.skipped ||
      TimerEventKind.stopped => null,
    };
  }

  String _phasePhrase(TimerPhaseKind kind, bool spanish) => switch (kind) {
    TimerPhaseKind.preparation => spanish ? 'Prepárate' : 'Get ready',
    TimerPhaseKind.work => spanish ? 'Trabajo' : 'Work',
    TimerPhaseKind.rest ||
    TimerPhaseKind.roundRest ||
    TimerPhaseKind.setRest => spanish ? 'Descanso' : 'Rest',
    TimerPhaseKind.cooldown => spanish ? 'Vuelta a la calma' : 'Cool down',
    TimerPhaseKind.stopwatch => spanish ? 'Cronómetro' : 'Stopwatch',
    TimerPhaseKind.finished => spanish ? 'Terminado' : 'Finished',
  };

  void _queueSpeech(String phrase) {
    final sequence = ++_speechSequence;
    _speechChain = _speechChain.then((_) async {
      try {
        if (sequence != _speechSequence) return;
        await _tts.stop();
        final language = _systemLanguageTag();
        if (Platform.isIOS && _configuredLanguage == null) {
          await _tts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient, [
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ], IosTextToSpeechAudioMode.voicePrompt);
        }
        if (_configuredLanguage != language) {
          await _tts.setLanguage(language);
          await _tts.setSpeechRate(0.48);
          _configuredLanguage = language;
        }
        if (sequence == _speechSequence) await _tts.speak(phrase);
      } on Object {
        // Some devices have no installed voice for their system language.
      }
    });
  }

  String _systemLanguageTag() {
    final locale = Platform.localeName.replaceAll('_', '-');
    return RegExp(r'^[a-zA-Z]{2,3}(-|$)').hasMatch(locale) ? locale : 'en-US';
  }

  void dispose() {
    unawaited(_player.dispose());
    unawaited(_tts.stop());
  }
}
