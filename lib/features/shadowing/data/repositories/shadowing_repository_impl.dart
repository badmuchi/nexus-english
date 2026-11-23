import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/shadowing_phrase.dart';
import '../../domain/repositories/shadowing_repository.dart';
import '../models/shadowing_phrase_model.dart';

class ShadowingRepositoryImpl implements ShadowingRepository {
  final AssetBundle? _bundle;
  final AppLogger _logger;

  ShadowingRepositoryImpl({
    AssetBundle? bundle,
    AppLogger logger = const DeveloperAppLogger(),
  })  : _bundle = bundle,
        _logger = logger;

  static const List<Map<String, dynamic>> _fallbackPhrases = [
    {
      'id': 'sh_cafe_order',
      'textEnglish': 'Could I please get a large cappuccino with oat milk to go?',
      'translationRussian': 'Можно мне, пожалуйста, большой капучино на овсяном молоке с собой?',
      'level': 'A1',
      'topic': 'Daily Life',
      'tips': "Сделайте связку звуков (linking) между 'could I' [kʊdaɪ] и подчеркните вежливую интонацию.",
      'audioPath': 'assets/audio/shadowing/sh_cafe_order.mp3',
    },
    {
      'id': 'sh_directions',
      'textEnglish': 'Excuse me, could you tell me how to get to the nearest subway station?',
      'translationRussian': 'Извините, вы не подскажете, как добраться до ближайшей станции метро?',
      'level': 'A1',
      'topic': 'Travel',
      'tips': "Ударение падает на 'excuse', 'subway' и 'station'. Интонация в конце мягко идет вверх.",
      'audioPath': 'assets/audio/shadowing/sh_directions.mp3',
    },
    {
      'id': 'sh_weather_smalltalk',
      'textEnglish': "It looks like it's going to rain this afternoon, doesn't it?",
      'translationRussian': 'Похоже, сегодня днем пойдет дождь, не так ли?',
      'level': 'A2',
      'topic': 'Small Talk',
      'tips': "Обратите внимание на разделительный вопрос (tag question): 'doesn't it' звучит с нисходящей интонацией.",
      'audioPath': 'assets/audio/shadowing/sh_weather_smalltalk.mp3',
    },
    {
      'id': 'sh_restaurant_bill',
      'textEnglish': 'Everything was absolutely delicious, could we get the check, please?',
      'translationRussian': 'Все было потрясающе вкусно, можно нам счет, пожалуйста?',
      'level': 'A2',
      'topic': 'Daily Life',
      'tips': "Слово 'delicious' произносите с четким звуком [ʃ], не растягивайте гласные.",
      'audioPath': 'assets/audio/shadowing/sh_restaurant_bill.mp3',
    },
    {
      'id': 'sh_meeting_intro',
      'textEnglish': "Thanks for joining everyone. Let's quickly review the sprint objectives before moving forward.",
      'translationRussian': 'Спасибо всем, что подключились. Давайте быстро пробежимся по целям спринта, прежде чем двигаться дальше.',
      'level': 'B1',
      'topic': 'Business & Tech',
      'tips': "Энергичный деловой темп. Обратите внимание на связку 'let's quickly' и редукцию в 'before'.",
      'audioPath': 'assets/audio/shadowing/sh_meeting_intro.mp3',
    },
    {
      'id': 'sh_tech_architecture',
      'textEnglish': 'We need to ensure our database schema migrations are completely backward compatible.',
      'translationRussian': 'Нам нужно убедиться, что миграции схемы базы данных полностью обратно совместимы.',
      'level': 'B1',
      'topic': 'Business & Tech',
      'tips': "Слова 'backward compatible' произносите слитно, ударение на 'com-PA-tible'.",
      'audioPath': 'assets/audio/shadowing/sh_tech_architecture.mp3',
    },
    {
      'id': 'sh_debate_opinion',
      'textEnglish': 'From my perspective, cutting corners on test coverage will inevitably cause critical bugs in production.',
      'translationRussian': 'С моей точки зрения, экономия на тестовом покрытии неизбежно приведет к критическим багам в проде.',
      'level': 'B2',
      'topic': 'Debates & Arguments',
      'tips': "Выделите логическое ударение на 'inevitably' [ɪnˈevɪtəbli] и 'critical'.",
      'audioPath': 'assets/audio/shadowing/sh_debate_opinion.mp3',
    },
    {
      'id': 'sh_diplomatic_disagree',
      'textEnglish': 'I definitely see your point, but we have to take the performance bottlenecks into account.',
      'translationRussian': 'Я определенно понимаю вашу мысль, но мы обязаны принять во внимание узкие места в производительности.',
      'level': 'B2',
      'topic': 'Debates & Arguments',
      'tips': "Дипломатичная интонация: мягкое начало с 'definitely', затем уверенный переход на 'take into account'.",
      'audioPath': 'assets/audio/shadowing/sh_diplomatic_disagree.mp3',
    },
  ];

  @override
  Future<Result<List<ShadowingPhrase>>> getPhrases({
    String? level,
    String? topic,
  }) async {
    try {
      List<Map<String, dynamic>> list;
      try {
        final bundle = _bundle ?? rootBundle;
        final jsonStr = await bundle.loadString('assets/seed/shadowing_seed.json');
        list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
      } catch (e) {
        _logger.warning('ShadowingRepo', 'Using fallback seed data: $e');
        list = _fallbackPhrases;
      }

      final results = <ShadowingPhrase>[];

      for (final raw in list) {
        final phrase = ShadowingPhraseModel.fromJson(raw);

        if (level != null && level.isNotEmpty && level != 'all') {
          if (phrase.level.toLowerCase() != level.toLowerCase()) {
            continue;
          }
        }

        if (topic != null && topic.isNotEmpty && topic != 'all') {
          if (phrase.topic.toLowerCase() != topic.toLowerCase()) {
            continue;
          }
        }

        results.add(phrase);
      }

      return Result.success(results);
    } catch (e) {
      _logger.error('ShadowingRepo', 'Error retrieving shadowing phrases: $e');
      final fallbackResults = _fallbackPhrases
          .map(ShadowingPhraseModel.fromJson)
          .where((phrase) =>
              (level == null || level.isEmpty || level == 'all' || phrase.level.toLowerCase() == level.toLowerCase()) &&
              (topic == null || topic.isEmpty || topic == 'all' || phrase.topic.toLowerCase() == topic.toLowerCase()))
          .toList();
      return Result.success(fallbackResults);
    }
  }

  @override
  Future<Result<void>> logAttempt({
    required String phraseId,
    required int score,
  }) async {
    _logger.info('Shadowing', 'Attempt logged for phrase $phraseId with score $score');
    return const Result.success(null);
  }
}
