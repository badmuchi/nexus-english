import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import '../logging/app_logger.dart';
import '../result/result.dart';
import 'speech_recognition_service.dart';

@JS('window')
external JSObject get _window;

@JS()
extension type _SpeechRecognitionInstance._(JSObject _) implements JSObject {
  external set lang(String value);
  external set continuous(bool value);
  external set interimResults(bool value);
  external set maxAlternatives(int value);
  external void start();
  external void stop();
  external void abort();
  external set onresult(JSFunction? value);
  external set onerror(JSFunction? value);
  external set onend(JSFunction? value);
}

final class WebSpeechRecognitionService implements SpeechRecognitionService {
  static const String _tag = 'WebSpeechRecognitionService';

  final AppLogger _logger;
  final StreamController<String> _textController = StreamController<String>.broadcast();

  _SpeechRecognitionInstance? _recognition;
  bool _isListening = false;
  bool _isSupported = false;
  String _currentLanguage = 'en-US';

  WebSpeechRecognitionService({required AppLogger logger}) : _logger = logger {
    _checkSupport();
  }

  void _checkSupport() {
    try {
      final ctor = _window['SpeechRecognition'] ?? _window['webkitSpeechRecognition'];
      _isSupported = ctor != null;
    } on Object catch (e) {
      _logger.warning(_tag, 'Failed to inspect SpeechRecognition support: $e');
      _isSupported = false;
    }
  }

  @override
  bool get isSupported => _isSupported;

  @override
  bool get isListening => _isListening;

  @override
  Stream<String> get textStream => _textController.stream;

  @override
  Future<Result<bool>> initialize({String language = 'en-US'}) async {
    _currentLanguage = language;
    _checkSupport();

    if (!_isSupported) {
      _logger.info(_tag, 'SpeechRecognition is not available on this browser');
      return const Result.success(false);
    }

    try {
      final ctor = _window['SpeechRecognition'] ?? _window['webkitSpeechRecognition'];
      if (ctor == null) {
        _isSupported = false;
        return const Result.success(false);
      }

      final instance = (ctor as JSFunction).callAsConstructor<JSObject>();
      final rec = _SpeechRecognitionInstance._(instance);

      rec.lang = _currentLanguage;
      rec.continuous = true;
      rec.interimResults = true;
      rec.maxAlternatives = 1;

      rec.onresult = ((JSObject event) {
        try {
          final results = event['results'] as JSObject?;
          if (results == null) return;

          final length = (results['length'] as JSNumber).toDartInt;
          final buffer = StringBuffer();

          for (var i = 0; i < length; i++) {
            final item = results['$i'] as JSObject?;
            if (item != null) {
              final alt = item['0'] as JSObject?;
              if (alt != null) {
                final transcript = (alt['transcript'] as JSString?)?.toDart;
                if (transcript != null) {
                  buffer.write('$transcript ');
                }
              }
            }
          }

          final text = buffer.toString().trim();
          if (text.isNotEmpty) {
            _textController.add(text);
          }
        } on Object catch (e) {
          _logger.warning(_tag, 'Error parsing SpeechRecognition event: $e');
        }
      }).toJS;

      rec.onerror = ((JSObject event) {
        final error = (event['error'] as JSString?)?.toDart ?? 'unknown';
        _logger.warning(_tag, 'SpeechRecognition error: $error');
        if (error != 'no-speech') {
          _isListening = false;
        }
      }).toJS;

      rec.onend = (() {
        _logger.info(_tag, 'SpeechRecognition session ended');
        _isListening = false;
      }).toJS;

      _recognition = rec;
      return const Result.success(true);
    } on Object catch (e, st) {
      _logger.error(_tag, 'Failed to initialize WebSpeechRecognition: $e', e, st);
      return Result.failure(e, st);
    }
  }

  @override
  Future<Result<void>> startListening() async {
    if (_recognition == null) {
      final initRes = await initialize(language: _currentLanguage);
      if (initRes.isFailure || (initRes.getOrNull() == false)) {
        return const Result.failure('SpeechRecognition not initialized');
      }
    }

    try {
      if (_isListening) {
        _recognition?.stop();
      }
      _recognition?.start();
      _isListening = true;
      _logger.info(_tag, 'Started listening in $_currentLanguage');
      return const Result.success(null);
    } on Object catch (e, st) {
      _logger.warning(_tag, 'Failed to start listening: $e');
      _isListening = false;
      return Result.failure(e, st);
    }
  }

  @override
  Future<Result<void>> stopListening() async {
    try {
      _recognition?.stop();
      _isListening = false;
      _logger.info(_tag, 'Stopped listening');
      return const Result.success(null);
    } on Object catch (e, st) {
      _logger.warning(_tag, 'Failed to stop listening: $e');
      return Result.failure(e, st);
    }
  }

  @override
  Future<void> dispose() async {
    try {
      _recognition?.abort();
      _recognition = null;
      _isListening = false;
      await _textController.close();
    } catch (_) {}
  }
}
