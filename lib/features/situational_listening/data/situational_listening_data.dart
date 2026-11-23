import '../domain/entities/listening_situation.dart';

class SituationalListeningData {
  static const List<ListeningSituation> situations = [
    ListeningSituation(
      id: 'sit_airport',
      title: 'Смена выхода на посадку в JFK',
      category: 'Путешествия',
      iconEmoji: '✈️',
      level: 'A2',
      fullDialogueText:
          'Attention all passengers on British Airways Flight 178 to London Heathrow. Please be advised that the departure gate has been changed from Gate B22 to Gate B34. Boarding will commence in approximately fifteen minutes, beginning with passengers requiring special assistance and first-class travelers. Please have your boarding passes and passports ready for inspection. We apologize for the inconvenience.',
      transcriptLines: [
        TranscriptLine(
          speaker: 'Announcer',
          textEn: 'Attention all passengers on British Airways Flight 178 to London Heathrow.',
          textRu: 'Внимание всем пассажирам рейса British Airways 178 в Лондон Хитроу.',
        ),
        TranscriptLine(
          speaker: 'Announcer',
          textEn: 'Please be advised that the departure gate has been changed from Gate B22 to Gate B34.',
          textRu: 'Пожалуйста, обратите внимание, что выход на посадку изменён с гейта B22 на гейт B34.',
        ),
        TranscriptLine(
          speaker: 'Announcer',
          textEn: 'Boarding will commence in approximately fifteen minutes, beginning with priority passengers.',
          textRu: 'Посадка начнется примерно через пятнадцать минут, начиная с приоритетных пассажиров.',
        ),
        TranscriptLine(
          speaker: 'Announcer',
          textEn: 'Please have your boarding passes and passports ready for inspection. We apologize for the inconvenience.',
          textRu: 'Пожалуйста, приготовьте посадочные талоны и паспорта для проверки. Приносим извинения за неудобства.',
        ),
      ],
      questions: [
        ComprehensionQuestion(
          questionEn: 'What is the new departure gate for Flight 178?',
          questionRu: 'Какой новый выход на посадку объявлен для рейса 178?',
          options: ['Gate B22', 'Gate B34', 'Gate A15', 'Gate C12'],
          correctIndex: 1,
          explanation: 'Диктор четко сказал: "gate has been changed from Gate B22 to Gate B34".',
        ),
        ComprehensionQuestion(
          questionEn: 'When will boarding begin?',
          questionRu: 'Через сколько начнется посадка на рейс?',
          options: ['In five minutes', 'In fifteen minutes', 'In thirty minutes', 'Immediately'],
          correctIndex: 1,
          explanation: 'В объявлении прозвучало: "Boarding will commence in approximately fifteen minutes".',
        ),
      ],
      keyVocabulary: [
        KeyVocabularyItem(english: 'departure gate', russian: 'выход на посадку'),
        KeyVocabularyItem(english: 'commence', russian: 'начинаться, стартовать'),
        KeyVocabularyItem(english: 'special assistance', russian: 'специальная помощь (для маломобильных)'),
        KeyVocabularyItem(english: 'inconvenience', russian: 'неудобство'),
      ],
    ),
    ListeningSituation(
      id: 'sit_standup',
      title: 'Daily Standup в международной IT-команде',
      category: 'Бизнес & IT',
      iconEmoji: '💻',
      level: 'B1',
      fullDialogueText:
          'Morning team! Quick update from my side. Yesterday I wrapped up the OAuth2 user authentication flow and merged the pull request. Today my main priority is tackling the database migration scripts. However, I am currently blocked because the staging Redis cache server is throwing timeout errors. Alex, could you please take a look at the firewall rules when you have a spare minute? Other than that, everything is on track for Friday deployment.',
      transcriptLines: [
        TranscriptLine(
          speaker: 'Developer',
          textEn: 'Morning team! Quick update from my side. Yesterday I wrapped up the OAuth2 authentication flow.',
          textRu: 'Доброе утро, команда! Краткий апдейт. Вчера я закончил поток аутентификации OAuth2.',
        ),
        TranscriptLine(
          speaker: 'Developer',
          textEn: 'Today my main priority is tackling the database migration scripts.',
          textRu: 'Сегодня мой главный приоритет — работа над скриптами миграции базы данных.',
        ),
        TranscriptLine(
          speaker: 'Developer',
          textEn: 'However, I am currently blocked because the staging Redis cache server is throwing timeout errors.',
          textRu: 'Однако сейчас я заблокирован, так как тестовый сервер Redis кэша выдает ошибки таймаута.',
        ),
        TranscriptLine(
          speaker: 'Developer',
          textEn: 'Alex, could you please take a look at the firewall rules? Everything else is on track for Friday.',
          textRu: 'Алекс, не мог бы ты глянуть правила файрвола? В остальном всё по плану к релизу в пятницу.',
        ),
      ],
      questions: [
        ComprehensionQuestion(
          questionEn: 'What is blocking the developer today?',
          questionRu: 'Что блокирует разработчика сегодня?',
          options: [
            'Missing database credentials',
            'Redis cache server timeout errors',
            'Unmerged pull request',
            'Postponed Friday release',
          ],
          correctIndex: 1,
          explanation: 'Разработчик сообщил: "blocked because the staging Redis cache server is throwing timeout errors".',
        ),
        ComprehensionQuestion(
          questionEn: 'What did the developer finish yesterday?',
          questionRu: 'Что разработчик завершил вчера?',
          options: [
            'Database schema migrations',
            'Firewall configuration',
            'OAuth2 user authentication flow',
            'Friday deployment pipeline',
          ],
          correctIndex: 2,
          explanation: 'Фраза: "Yesterday I wrapped up the OAuth2 user authentication flow".',
        ),
      ],
      keyVocabulary: [
        KeyVocabularyItem(english: 'wrap up', russian: 'успешно закончить, завершить'),
        KeyVocabularyItem(english: 'tackle', russian: 'браться за решение сложной задачи'),
        KeyVocabularyItem(english: 'currently blocked', russian: 'нахожусь в блоке / заблокирован'),
        KeyVocabularyItem(english: 'on track', russian: 'идёт по плану, в графике'),
      ],
    ),
    ListeningSituation(
      id: 'sit_hotel',
      title: 'Консьерж в отеле Лондона',
      category: 'Отель',
      iconEmoji: '🏨',
      level: 'A2',
      fullDialogueText:
          'Good morning sir! Welcome to the Royal Kensington. Your executive double room on the fourth floor is ready. Complimentary buffet breakfast is served every morning from seven to ten thirty in the Westminster Dining Room. If you wish to visit the British Museum today, I strongly recommend taking the Piccadilly line from South Kensington tube station, which is just a three-minute walk to the right of our main entrance. Here is your electronic key card. Enjoy your stay!',
      transcriptLines: [
        TranscriptLine(
          speaker: 'Concierge',
          textEn: 'Good morning sir! Welcome to the Royal Kensington. Your executive double room on the fourth floor is ready.',
          textRu: 'Доброе утро, сэр! Добро пожаловать в Royal Kensington. Ваш номер executive на 4-м этаже готов.',
        ),
        TranscriptLine(
          speaker: 'Concierge',
          textEn: 'Complimentary buffet breakfast is served every morning from seven to ten thirty in the Westminster Room.',
          textRu: 'Бесплатный завтрак "шведский стол" подается каждое утро с 7:00 до 10:30 в зале Вестминстер.',
        ),
        TranscriptLine(
          speaker: 'Concierge',
          textEn: 'To visit the British Museum, take the Piccadilly line from South Kensington station, just three minutes away.',
          textRu: 'Чтобы посетить Британский музей, садитесь на ветку Piccadilly на станции South Kensington в трех минутах ходьбы.',
        ),
        TranscriptLine(
          speaker: 'Concierge',
          textEn: 'Here is your electronic key card. Enjoy your stay!',
          textRu: 'Вот ваша электронная ключ-карта. Приятного отдыха!',
        ),
      ],
      questions: [
        ComprehensionQuestion(
          questionEn: 'Until what time is breakfast served in the morning?',
          questionRu: 'До скольки подается завтрак по утрам?',
          options: ['9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM'],
          correctIndex: 2,
          explanation: 'Консьерж сказал: "from seven to ten thirty" (с 7:00 до 10:30).',
        ),
        ComprehensionQuestion(
          questionEn: 'Which subway line did the concierge recommend for the museum?',
          questionRu: 'Какую ветку метро консьерж порекомендовал для поездки в музей?',
          options: ['Central line', 'Piccadilly line', 'District line', 'Jubilee line'],
          correctIndex: 1,
          explanation: 'Консьерж порекомендовал: "taking the Piccadilly line from South Kensington tube station".',
        ),
      ],
      keyVocabulary: [
        KeyVocabularyItem(english: 'complimentary', russian: 'бесплатный, в качестве комплимента'),
        KeyVocabularyItem(english: 'buffet breakfast', russian: 'завтрак "шведский стол"'),
        KeyVocabularyItem(english: 'tube station', russian: 'станция метро (в Лондоне)'),
        KeyVocabularyItem(english: 'enjoy your stay', russian: 'приятного пребывания/отдыха'),
      ],
    ),
    ListeningSituation(
      id: 'sit_cafe',
      title: 'Сложный заказ кофе в Нью-Йорке',
      category: 'Еда & Быт',
      iconEmoji: '☕',
      level: 'A2',
      fullDialogueText:
          'Hi there! Can I get an iced oat milk latte with two shots of decaf espresso, please? And could you add one pump of sugar-free caramel syrup? Also, I brought my own reusable cup, so could you pour it in here? Great, and can I tap with Apple Pay? Thanks so much, keep the change!',
      transcriptLines: [
        TranscriptLine(
          speaker: 'Customer',
          textEn: 'Hi there! Can I get an iced oat milk latte with two shots of decaf espresso, please?',
          textRu: 'Привет! Можно мне айс-латте на овсяном молоке с двумя шотами декаф-эспрессо, пожалуйста?',
        ),
        TranscriptLine(
          speaker: 'Customer',
          textEn: 'And could you add one pump of sugar-free caramel syrup?',
          textRu: 'И не могли бы вы добавить одну порцию карамельного сиропа без сахара?',
        ),
        TranscriptLine(
          speaker: 'Customer',
          textEn: 'Also, I brought my own reusable cup, so could you pour it in here?',
          textRu: 'Также я принес свою многоразовую кружку, налейте сюда, пожалуйста?',
        ),
        TranscriptLine(
          speaker: 'Customer',
          textEn: 'Great, and can I tap with Apple Pay? Thanks so much, keep the change!',
          textRu: 'Отлично, можно приложить Apple Pay? Большое спасибо, сдачи не надо!',
        ),
      ],
      questions: [
        ComprehensionQuestion(
          questionEn: 'What kind of coffee did the customer order?',
          questionRu: 'Какой кофе заказал клиент?',
          options: [
            'Hot whole milk cappuccino',
            'Iced oat milk latte with decaf espresso',
            'Regular black drip coffee',
            'Iced caramel macchiato with extra sugar',
          ],
          correctIndex: 1,
          explanation: 'Клиент заказал: "iced oat milk latte with two shots of decaf espresso".',
        ),
        ComprehensionQuestion(
          questionEn: 'What does "keep the change" mean?',
          questionRu: 'Что означает фраза "keep the change"?',
          options: [
            'Верните мне сдачу',
            'Оставьте сдачу себе (чаевые)',
            'Поменяйте мне купюру',
            'Оплачу мелкой монетой',
          ],
          correctIndex: 1,
          explanation: '"Keep the change" — устойчивое выражение "сдачи не надо / оставьте сдачу себе".',
        ),
      ],
      keyVocabulary: [
        KeyVocabularyItem(english: 'decaf espresso', russian: 'эспрессо без кофеина'),
        KeyVocabularyItem(english: 'sugar-free syrup', russian: 'сироп без сахара'),
        KeyVocabularyItem(english: 'reusable cup', russian: 'многоразовый стакан/кружка'),
        KeyVocabularyItem(english: 'keep the change', russian: 'сдачи не надо (чаевые)'),
      ],
    ),
    ListeningSituation(
      id: 'sit_taxi',
      title: 'Поездка на желтом такси в Манхэттен',
      category: 'Транспорт',
      iconEmoji: '🚕',
      level: 'B1',
      fullDialogueText:
          'Driver: Hey buddy, where to? Passenger: Hi, please take me to 45th Street near Times Square. Could we take the Queensboro Bridge or FDR Drive? The highway looked completely gridlocked on Google Maps. Driver: Yeah, good call. There is road construction on the Midtown Tunnel, so traffic is backed up for two miles. FDR will be much faster. Passenger: Awesome. By the way, does your meter accept contactless cards? Driver: Sure thing, just tap the terminal in the back whenever we arrive.',
      transcriptLines: [
        TranscriptLine(
          speaker: 'Driver',
          textEn: 'Hey buddy, where to?',
          textRu: 'Привет, дружище, куда едем?',
        ),
        TranscriptLine(
          speaker: 'Passenger',
          textEn: 'Please take me to 45th Street near Times Square. Can we take the FDR Drive?',
          textRu: 'Пожалуйста, на 45-ю улицу возле Таймс-сквер. Можем поехать по FDR Драйв?',
        ),
        TranscriptLine(
          speaker: 'Driver',
          textEn: 'Good call. There is road construction on the Midtown Tunnel, traffic is backed up.',
          textRu: 'Отличная мысль. На тоннеле дорожные работы, пробка на две мили.',
        ),
        TranscriptLine(
          speaker: 'Passenger',
          textEn: 'Awesome. By the way, does your meter accept contactless cards?',
          textRu: 'Супер. Кстати, ваш терминал принимает бесконтактные карты?',
        ),
        TranscriptLine(
          speaker: 'Driver',
          textEn: 'Sure thing, just tap the terminal in the back whenever we arrive.',
          textRu: 'Конечно, просто приложи к терминалу сзади, когда приедем.',
        ),
      ],
      questions: [
        ComprehensionQuestion(
          questionEn: 'Why did the passenger want to avoid the Midtown Tunnel?',
          questionRu: 'Почему пассажир хотел избежать тоннеля Мидтаун?',
          options: [
            'It is too expensive',
            'There is road construction and heavy traffic jam',
            'The tunnel is completely closed for the night',
            'The driver does not know the way',
          ],
          correctIndex: 1,
          explanation: 'Водитель подтвердил: "There is road construction on the Midtown Tunnel, traffic is backed up".',
        ),
        ComprehensionQuestion(
          questionEn: 'What does "good call" mean?',
          questionRu: 'Что означает разговорное выражение "good call"?',
          options: [
            'Хороший телефонный звонок',
            'Отличное решение / верная мысль',
            'Срочный вызов',
            'Громкий голос',
          ],
          correctIndex: 1,
          explanation: '"Good call" в американском сленге означает "отличная идея / верное решение".',
        ),
      ],
      keyVocabulary: [
        KeyVocabularyItem(english: 'good call', russian: 'отличная мысль / верное решение'),
        KeyVocabularyItem(english: 'gridlocked', russian: 'парализованный пробками'),
        KeyVocabularyItem(english: 'traffic backed up', russian: 'пробка растянулась'),
        KeyVocabularyItem(english: 'contactless card', russian: 'бесконтактная карта'),
      ],
    ),
  ];
}
