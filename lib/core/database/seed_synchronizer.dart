import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import '../logging/app_logger.dart';
import 'app_database.dart';

class SeedSynchronizer {
  final AppDatabase _db;
  final AppLogger _logger;

  SeedSynchronizer({
    required AppDatabase db,
    required AppLogger logger,
  })  : _db = db,
        _logger = logger;

  Future<void> syncAllSeeds() async {
    try {
      await Future.wait([
        _syncDictionary(),
        _syncGrammarVerbs(),
        _syncGrammarTopics(),
        _syncListening(),
        _syncDialogues(),
        _syncSrsCards(),
      ]);
      _logger.info('SeedSync', 'All initial seeds synchronized successfully.');
    } catch (e, st) {
      _logger.error('SeedSync', 'Failed to synchronize seed data', e, st);
    }
  }

  Future<void> _syncDictionary() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/dictionary_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
      for (final item in list) {
        await _db.insertOrUpdateDictionaryEntry(
          DictionaryEntriesCompanion(
            id: Value(item['id'] as String),
            word: Value(item['word'] as String),
            transcriptionIpa: Value(item['transcriptionIpa'] as String?),
            russianTranslation: Value(item['russianTranslation'] as String),
            partOfSpeech: Value(item['partOfSpeech'] as String? ?? 'noun'),
            level: Value(item['level'] as String? ?? 'A1'),
            exampleEnglish: Value(item['exampleEnglish'] as String?),
            exampleRussian: Value(item['exampleRussian'] as String?),
            audioUrl: Value(item['audioUrl'] as String?),
            isUserAdded: const Value(false),
            createdAt: Value(DateTime.now()),
          ),
        );
      }
    } catch (e, st) {
      _logger.warning('SeedSync', 'Dictionary seed error', e, st);
    }
  }

  Future<void> _syncGrammarVerbs() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/grammar_verbs_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
      for (final item in list) {
        await _db.insertOrUpdateVerb(
          GrammarVerbsCompanion(
            id: Value(item['id'] as String),
            v1Infinitive: Value(item['v1Infinitive'] as String),
            v2PastSimple: Value(item['v2PastSimple'] as String),
            v3PastParticiple: Value(item['v3PastParticiple'] as String),
            russianMeaning: Value(item['russianMeaning'] as String),
            level: Value(item['level'] as String? ?? 'A1'),
            examplesJson: Value(jsonEncode(item['examples'] ?? {})),
          ),
        );
      }
    } catch (e, st) {
      _logger.warning('SeedSync', 'Grammar verbs seed error', e, st);
    }
  }

  Future<void> _syncGrammarTopics() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/grammar_topics_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
      for (final item in list) {
        await _db.insertOrUpdateTopic(
          GrammarTopicsCompanion(
            id: Value(item['id'] as String),
            title: Value(item['title'] as String),
            level: Value(item['level'] as String? ?? 'A1'),
            category: Value(item['category'] as String? ?? 'Tenses'),
            explanation: Value(item['explanation'] as String),
            exercisesJson: Value(jsonEncode(item['exercises'] ?? [])),
          ),
        );
      }
    } catch (e, st) {
      _logger.warning('SeedSync', 'Grammar topics seed error', e, st);
    }
  }

  Future<void> _syncListening() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/listening_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
      for (final item in list) {
        await _db.insertOrUpdateListeningExercise(
          ListeningExercisesCompanion(
            id: Value(item['id'] as String),
            transcript: Value(item['transcript'] as String),
            russianTranslation: Value(item['russianTranslation'] as String),
            level: Value(item['level'] as String? ?? 'A1'),
            type: Value(item['type'] as String? ?? 'dictation'),
            optionsJson: Value(jsonEncode(item['options'] ?? {})),
            audioUrl: Value(item['audioUrl'] as String?),
          ),
        );
      }
    } catch (e, st) {
      _logger.warning('SeedSync', 'Listening seed error', e, st);
    }
  }

  Future<void> _syncDialogues() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/dialogues_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
      for (final item in list) {
        await _db.insertOrUpdateDialogueNode(
          DialogueNodesCompanion(
            id: Value(item['id'] as String),
            level: Value(item['level'] as String? ?? 'A1'),
            characterName: Value(item['characterName'] as String),
            lineEnglish: Value(item['lineEnglish'] as String),
            lineRussian: Value(item['lineRussian'] as String),
            audioPath: Value(item['audioPath'] as String?),
            optionsJson: Value(jsonEncode(item['options'] ?? [])),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    } catch (e, st) {
      _logger.warning('SeedSync', 'Dialogues seed error', e, st);
    }
  }

  Future<void> _syncSrsCards() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/srs_seed.json');
      final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
      for (final item in list) {
        await _db.insertOrUpdateSrsCard(
          SrsCardsCompanion(
            id: Value(item['id'] as String),
            frontEnglish: Value(item['frontEnglish'] as String),
            backRussian: Value(item['backRussian'] as String),
            transcriptionIpa: Value(item['transcriptionIpa'] as String?),
            level: Value(item['level'] as String? ?? 'A1'),
            category: Value(item['category'] as String? ?? 'general'),
            exampleSentence: Value(item['exampleSentence'] as String?),
            exampleTranslation: Value(item['exampleTranslation'] as String?),
            audioUrl: Value(item['audioUrl'] as String?),
            dueAt: Value(DateTime.now()),
          ),
        );
      }
    } catch (e, st) {
      _logger.warning('SeedSync', 'SRS seed error', e, st);
    }
  }
}
