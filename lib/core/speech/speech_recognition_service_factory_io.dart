import 'dart:async';
import '../logging/app_logger.dart';
import '../result/result.dart';
import 'speech_recognition_service.dart';

final class NoopSpeechRecognitionService implements SpeechRecognitionService {
  @override
  bool get isSupported => false;

  @override
  bool get isListening => false;

  @override
  Stream<String> get textStream => const Stream.empty();

  @override
  Future<Result<bool>> initialize({String language = 'en-US'}) async {
    return const Result.success(false);
  }

  @override
  Future<Result<void>> startListening() async {
    return const Result.success(null);
  }

  @override
  Future<Result<void>> stopListening() async {
    return const Result.success(null);
  }

  @override
  Future<void> dispose() async {}
}

SpeechRecognitionService buildPlatformSpeechRecognitionService({
  required AppLogger logger,
}) {
  return NoopSpeechRecognitionService();
}
