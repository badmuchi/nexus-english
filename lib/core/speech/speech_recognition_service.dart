import 'dart:async';
import '../logging/app_logger.dart';
import '../result/result.dart';
import 'speech_recognition_service_factory_io.dart'
    if (dart.library.js_interop) 'speech_recognition_service_factory_web.dart'
    as platform_factory;

abstract interface class SpeechRecognitionService {
  bool get isSupported;
  bool get isListening;
  Stream<String> get textStream;

  Future<Result<bool>> initialize({String language = 'en-US'});
  Future<Result<void>> startListening();
  Future<Result<void>> stopListening();
  Future<void> dispose();
}

SpeechRecognitionService createPlatformSpeechRecognitionService({
  required AppLogger logger,
}) {
  return platform_factory.buildPlatformSpeechRecognitionService(logger: logger);
}
