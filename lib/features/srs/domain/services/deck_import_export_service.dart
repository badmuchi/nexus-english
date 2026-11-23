import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../../../../core/database/app_database.dart';

class ImportedCardCandidate extends Equatable {
  final String frontEnglish;
  final String backRussian;
  final String? exampleSentence;
  final String level;

  const ImportedCardCandidate({
    required this.frontEnglish,
    required this.backRussian,
    this.exampleSentence,
    this.level = 'A2',
  });

  @override
  List<Object?> get props => [frontEnglish, backRussian, exampleSentence, level];
}

class DeckImportExportService {
  static final RegExp _cyrillicRegex = RegExp(r'[\u0400-\u04FF]');
  static final RegExp _latinRegex = RegExp(r'[a-zA-Z]');
  static final RegExp _htmlTagRegex = RegExp(r'<[^>]*>');
  static final RegExp _ankiSoundRegex = RegExp(r'\[sound:[^\]]*\]');

  /// Интеллектуальный парсер текста в карточки (TSV, CSV, JSON, простой список).
  List<ImportedCardCandidate> parseRawText(String rawText, {String defaultLevel = 'A2'}) {
    final text = rawText.trim();
    if (text.isEmpty) return const [];

    // 1. Попытка распарсить как JSON
    if ((text.startsWith('[') && text.endsWith(']')) ||
        (text.startsWith('{') && text.endsWith('}'))) {
      try {
        final parsed = jsonDecode(text);
        if (parsed is List) {
          final list = <ImportedCardCandidate>[];
          for (final item in parsed) {
            if (item is Map) {
              final front = (item['front'] ?? item['english'] ?? item['word'] ?? item['term'] ?? '')
                  .toString()
                  .trim();
              final back = (item['back'] ?? item['russian'] ?? item['translation'] ?? item['meaning'] ?? '')
                  .toString()
                  .trim();
              final example = item['example']?.toString().trim();
              final lvl = (item['level']?.toString().trim().toUpperCase()) ?? defaultLevel;

              if (front.isNotEmpty && back.isNotEmpty) {
                list.add(_normalizeCandidate(front, back, example, lvl));
              }
            }
          }
          if (list.isNotEmpty) return list;
        }
      } catch (_) {
        // Fallback на строчный парсинг
      }
    }

    // 2. Строчный парсинг (TSV / CSV / Разделители: -, —, :, =)
    final lines = text.split('\n');
    final results = <ImportedCardCandidate>[];

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue; // Пропуск комментариев Anki

      // Очистка от HTML и тегов звука Anki
      line = line.replaceAll(_htmlTagRegex, ' ').replaceAll(_ankiSoundRegex, '').trim();

      String? front;
      String? back;
      String? example;

      if (line.contains('\t')) {
        // TSV
        final parts = line.split('\t').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
        if (parts.length >= 2) {
          front = parts[0];
          back = parts[1];
          if (parts.length >= 3) example = parts[2];
        }
      } else if (line.contains(' — ')) {
        final parts = line.split(' — ');
        front = parts[0].trim();
        back = parts.sublist(1).join(' — ').trim();
      } else if (line.contains(' - ')) {
        final parts = line.split(' - ');
        front = parts[0].trim();
        back = parts.sublist(1).join(' - ').trim();
      } else if (line.contains(' : ')) {
        final parts = line.split(' : ');
        front = parts[0].trim();
        back = parts.sublist(1).join(' : ').trim();
      } else if (line.contains('=')) {
        final parts = line.split('=');
        front = parts[0].trim();
        back = parts.sublist(1).join('=').trim();
      } else if (line.contains(';')) {
        final parts = line.split(';').map((p) => p.trim()).toList();
        if (parts.length >= 2) {
          front = parts[0];
          back = parts[1];
          if (parts.length >= 3) example = parts[2];
        }
      } else if (line.contains(',')) {
        final parts = line.split(',').map((p) => p.trim()).toList();
        if (parts.length >= 2) {
          front = parts[0];
          back = parts.sublist(1).join(', ').trim();
        }
      }

      if (front != null && back != null && front.isNotEmpty && back.isNotEmpty) {
        results.add(_normalizeCandidate(front, back, example, defaultLevel));
      }
    }

    // Дедупликация по английскому слову
    final uniqueMap = <String, ImportedCardCandidate>{};
    for (final c in results) {
      uniqueMap[c.frontEnglish.toLowerCase()] = c;
    }

    return uniqueMap.values.toList();
  }

  ImportedCardCandidate _normalizeCandidate(
    String frontRaw,
    String backRaw,
    String? exampleRaw,
    String level,
  ) {
    var front = frontRaw.trim();
    var back = backRaw.trim();

    // Авто-реверс: если пользователь вставил "яблоко - apple", делаем front = apple, back = яблоко
    final frontHasCyrillic = _cyrillicRegex.hasMatch(front);
    final backHasLatin = _latinRegex.hasMatch(back);

    if (frontHasCyrillic && backHasLatin && !_latinRegex.hasMatch(front)) {
      final tmp = front;
      front = back;
      back = tmp;
    }

    // Нормализация кавычек
    if (front.startsWith('"') && front.endsWith('"') && front.length >= 2) {
      front = front.substring(1, front.length - 1).trim();
    }
    if (back.startsWith('"') && back.endsWith('"') && back.length >= 2) {
      back = back.substring(1, back.length - 1).trim();
    }

    return ImportedCardCandidate(
      frontEnglish: front,
      backRussian: back,
      exampleSentence: exampleRaw?.trim(),
      level: level.toUpperCase(),
    );
  }

  /// Экспорт в формат Anki TSV (Tab-separated values)
  String exportToAnkiTsv(List<SrsCardRow> cards) {
    final buffer = StringBuffer();
    buffer.writeln('#separator:tab');
    buffer.writeln('#html:false');
    buffer.writeln('#tags:nexus_english');

    for (final card in cards) {
      final front = card.frontEnglish.replaceAll('\t', ' ').replaceAll('\n', ' ');
      final back = card.backRussian.replaceAll('\t', ' ').replaceAll('\n', '<br>');
      final example = (card.exampleSentence ?? '').replaceAll('\t', ' ').replaceAll('\n', ' ');
      buffer.writeln('$front\t$back\t$example\t${card.level}');
    }

    return buffer.toString();
  }

  /// Экспорт в JSON
  String exportToJson(List<SrsCardRow> cards) {
    final list = cards.map((c) => {
          'id': c.id,
          'front': c.frontEnglish,
          'back': c.backRussian,
          'level': c.level,
          'category': c.category,
          'exampleSentence': c.exampleSentence,
          'exampleTranslation': c.exampleTranslation,
          'fsrsState': c.fsrsState,
          'stability': c.stability,
          'difficulty': c.difficulty,
          'reps': c.reps,
          'lapses': c.lapses,
          'dueAt': c.dueAt.toIso8601String(),
        }).toList();

    return const JsonEncoder.withIndent('  ').convert(list);
  }

  /// Экспорт в CSV
  String exportToCsv(List<SrsCardRow> cards) {
    final buffer = StringBuffer();
    buffer.writeln('"Front (English)","Back (Russian)","Example","Level"');

    for (final card in cards) {
      final front = card.frontEnglish.replaceAll('"', '""');
      final back = card.backRussian.replaceAll('"', '""');
      final example = (card.exampleSentence ?? '').replaceAll('"', '""');
      buffer.writeln('"$front","$back","$example","${card.level}"');
    }

    return buffer.toString();
  }
}
