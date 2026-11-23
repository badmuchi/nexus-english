import '../domain/entities/roleplay_scenario.dart';

class RoleplayData {
  static const List<RoleplayScenario> scenarios = [
    // 1. Job Interview at a Tech Startup
    RoleplayScenario(
      id: 'job_interview_tech',
      title: 'Собеседование в IT-стартап',
      titleEn: 'Tech Startup Job Interview',
      description: 'Ответьте на каверзные вопросы тимлида о вашем опыте, сложных багах и решении конфликтов.',
      cefrLevel: 'B2',
      category: RoleplayCategory.career,
      characterName: 'David Miller',
      characterRole: 'Lead Engineer @ Stripe London',
      characterAvatar: '👨‍💻',
      initialNodeId: 'node_1',
      nodes: {
        'node_1': RoleplayDialogueNode(
          id: 'node_1',
          characterSpeechEn: "Welcome! Thanks for taking the time to speak with us today. To kick things off, could you briefly walk me through your background and what drew you to our team?",
          characterSpeechRu: "Добро пожаловать! Спасибо, что уделили время. Для начала, не могли бы вы кратко рассказать о своем бэкграунде и о том, что привлекло вас в нашей команде?",
          userOptions: [
            RoleplayOption(
              textEn: "Sure! Over the past three years, I've focused on mobile architecture and scalable state management. I love your product's focus on developer velocity.",
              translationRu: "Конечно! Последние три года я фокусировался на мобильной архитектуре и масштабируемом стейт-менеджменте. Мне нравится акцент вашего продукта на скорости разработки.",
              naturalnessScore: 0.96,
              feedback: "Отличный ответ! Фразы 'focused on', 'developer velocity' звучат очень профессионально.",
              nativeAlternative: "I've been heavily immersed in mobile architecture, and your team's engineering culture really resonates with me.",
              nextNodeId: 'node_2_tech',
              xpReward: 25,
            ),
            RoleplayOption(
              textEn: "Hello. I work as programmer for 3 years. I want change job because I want more money and interesting tasks in your firm.",
              translationRu: "Здравствуйте. Я работаю программистом 3 года. Я хочу сменить работу, потому что хочу больше денег и интересные задачи в вашей фирме.",
              naturalnessScore: 0.50,
              feedback: "Прямолинейно и немного неестественно. 'firm' в IT обычно называют 'company/team', а вместо 'more money' лучше говорить 'competitive growth'.",
              nativeAlternative: "I'm looking for a new challenge with broader impact and career growth opportunities.",
              nextNodeId: 'node_2_tech',
              xpReward: 10,
            ),
          ],
        ),
        'node_2_tech': RoleplayDialogueNode(
          id: 'node_2_tech',
          characterSpeechEn: "That's great context. Tell me about a time when you encountered a critical production issue right before a deadline. How did you handle the pressure?",
          characterSpeechRu: "Отличный контекст. Расскажите о случае, когда вы столкнулись с критическим багом прямо перед дедлайном. Как вы справились с давлением?",
          userOptions: [
            RoleplayOption(
              textEn: "We had a race condition causing app crashes on startup. Instead of panicking, I isolated the failing thread, rolled back the release, and set up a regression test.",
              translationRu: "У нас была race condition, вызывавшая краши при старте. Вместо паники я изолировал сбойный поток, откатил релиз и настроил регрессионный тест.",
              naturalnessScore: 0.95,
              feedback: "Идеально! Четкая структура STAR (ситуация, действие, результат) и правильная терминология ('race condition', 'regression test').",
              nativeAlternative: "We triaged the crash immediately, executed a safe rollback, and shipped a verified hotfix within two hours.",
              nextNodeId: 'node_3_tech_end',
              xpReward: 30,
            ),
            RoleplayOption(
              textEn: "One time application was broken. I wrote to my boss that it is not my fault, and other developer did bad commit.",
              translationRu: "Один раз приложение сломалось. Я написал начальнику, что это не моя вина, и другой разработчик сделал плохой коммит.",
              naturalnessScore: 0.40,
              feedback: "Перекладывание вины на собеседовании — красный флаг. Важно показать командную ответственность.",
              nativeAlternative: "We collaborated across the team to trace the root cause and implemented a post-mortem to prevent it recurring.",
              nextNodeId: 'node_3_tech_end',
              xpReward: 5,
            ),
          ],
        ),
        'node_3_tech_end': RoleplayDialogueNode(
          id: 'node_3_tech_end',
          characterSpeechEn: "Appreciate your honesty. It seems like you'd be a great cultural fit here. Do you have any questions for me regarding our roadmap or tech stack?",
          characterSpeechRu: "Ценю вашу честность. Похоже, вы отлично впишетесь в нашу культуру. Есть ли у вас вопросы ко мне по роадмапу или технологическому стеку?",
          userOptions: [
            RoleplayOption(
              textEn: "Yes! What are the biggest technical debt challenges your engineering team is aiming to tackle in Q3?",
              translationRu: "Да! С какими главными вызовами техдолга ваша команда планирует разобраться в 3-м квартале?",
              naturalnessScore: 0.98,
              feedback: "Блестящий вопрос кандидатов уровня Senior! Демонстрирует стратегическое мышление.",
              nativeAlternative: "What does the typical feedback loop look like between product and engineering here?",
              nextNodeId: null,
              xpReward: 35,
            ),
          ],
          isEndingNode: true,
        ),
      },
    ),

    // 2. Specialty Coffee Shop in London
    RoleplayScenario(
      id: 'coffee_shop_soho',
      title: 'Заказ спешелти-кофе в Сохо',
      titleEn: 'Ordering Specialty Coffee in Soho',
      description: 'Попробуйте заказать авторский напиток, выбрать тип зерна и уточнить детали меню у приветливого бариста.',
      cefrLevel: 'A2',
      category: RoleplayCategory.everyday,
      characterName: 'Chloe',
      characterRole: 'Barista @ Monmouth Coffee',
      characterAvatar: '☕',
      initialNodeId: 'node_coffee_1',
      nodes: {
        'node_coffee_1': RoleplayDialogueNode(
          id: 'node_coffee_1',
          characterSpeechEn: "Morning! How's your day going? What can I get started for you today?",
          characterSpeechRu: "Доброе утро! Как проходит ваш день? Что для вас приготовить?",
          userOptions: [
            RoleplayOption(
              textEn: "Hi! Can I please get an oat flat white and an almond croissant to have here?",
              translationRu: "Привет! Можно мне, пожалуйста, овсяный флэт уайт и миндальный круассан здесь?",
              naturalnessScore: 0.97,
              feedback: "Очень натурально! Фраза 'to have here' (или 'for here') — именно так говорят в Великобритании.",
              nativeAlternative: "Good morning! Could I please have a large oat flat white to drink in?",
              nextNodeId: 'node_coffee_2',
              xpReward: 20,
            ),
            RoleplayOption(
              textEn: "Give me one coffee with milk and cake. I eat here.",
              translationRu: "Дайте мне один кофе с молоком и пирожное. Я ем здесь.",
              naturalnessScore: 0.45,
              feedback: "Звучит слишком резко и приказно. Англичане всегда смягчают заказ через 'Could I have' или 'Can I get'.",
              nativeAlternative: "May I have a flat white with oat milk, please?",
              nextNodeId: 'node_coffee_2',
              xpReward: 10,
            ),
          ],
        ),
        'node_coffee_2': RoleplayDialogueNode(
          id: 'node_coffee_2',
          characterSpeechEn: "Sure thing! For the espresso, we have a fruity Ethiopian single-origin or our signature chocolatey Brazilian blend. Which one do you prefer?",
          characterSpeechRu: "Без проблем! Для эспрессо у нас есть эфиопский моносорт с фруктовыми нотками или наш фирменный шоколадный бразильский бленд. Что предпочтете?",
          userOptions: [
            RoleplayOption(
              textEn: "I'll go with the Ethiopian single-origin, please. Does it pair well with oat milk?",
              translationRu: "Я выберу эфиопский моносорт, пожалуйста. Он хорошо сочетается с овсяным молоком?",
              naturalnessScore: 0.98,
              feedback: "Прекрасный выбор выражений: 'I'll go with...', 'pair well with'.",
              nativeAlternative: "Let's do the Ethiopian, please. I love fruity acidity.",
              nextNodeId: 'node_coffee_3_end',
              xpReward: 25,
            ),
            RoleplayOption(
              textEn: "Any is okay for me, I not care.",
              translationRu: "Любой сойдет, мне все равно.",
              naturalnessScore: 0.40,
              feedback: "Звучит немного пренебрежительно. Лучше сказать 'Surprise me!' или 'Whatever you recommend!'.",
              nativeAlternative: "Dealer's choice! What would you recommend?",
              nextNodeId: 'node_coffee_3_end',
              xpReward: 10,
            ),
          ],
        ),
        'node_coffee_3_end': RoleplayDialogueNode(
          id: 'node_coffee_3_end',
          characterSpeechEn: "It pairs wonderfully! That'll be £6.80 altogether. Are you paying by card or contactless?",
          characterSpeechRu: "Отлично сочетается! С вас £6.80 за все. Оплата картой или бесконтактно?",
          userOptions: [
            RoleplayOption(
              textEn: "Contactless with Apple Pay, please. Could I also grab the Wi-Fi password?",
              translationRu: "Бесконтактно через Apple Pay, пожалуйста. Можно мне также узнать пароль от Wi-Fi?",
              naturalnessScore: 0.96,
              feedback: "Отличная связка вопросов и естественное употребление 'grab the Wi-Fi password'.",
              nativeAlternative: "On my phone, please! And do you have guest Wi-Fi by any chance?",
              nextNodeId: null,
              xpReward: 25,
            ),
          ],
          isEndingNode: true,
        ),
      },
    ),

    // 3. Airport Customs & Lost Luggage
    RoleplayScenario(
      id: 'airport_lost_luggage',
      title: 'Утерянный багаж и таможня',
      titleEn: 'Lost Baggage & Border Inquiries',
      description: 'Ваш чемодан не прилетел на багажную ленту в Хитроу. Опишите багаж офицеру и оформите доставку.',
      cefrLevel: 'B1',
      category: RoleplayCategory.travel,
      characterName: 'Officer Bradley',
      characterRole: 'Baggage Services Officer @ LHR',
      characterAvatar: '👮‍♂️',
      initialNodeId: 'node_air_1',
      nodes: {
        'node_air_1': RoleplayDialogueNode(
          id: 'node_air_1',
          characterSpeechEn: "Good evening. Baggage Services desk. How can I assist you?",
          characterSpeechRu: "Добрый вечер. Стойка розыска багажа. Чем могу помочь?",
          userOptions: [
            RoleplayOption(
              textEn: "Hello. I just arrived on flight BA245 from Berlin, but my checked suitcase hasn't appeared on carousel 4.",
              translationRu: "Здравствуйте. Я только что прилетел рейсом BA245 из Берлина, но мой сданный чемодан не появился на ленте 4.",
              naturalnessScore: 0.95,
              feedback: "Четко и грамотно: указан номер рейса, 'checked suitcase' (сданный багаж), 'carousel' (багажная карусель).",
              nativeAlternative: "Good evening. It seems my luggage didn't make the transfer from flight BA245.",
              nextNodeId: 'node_air_2',
              xpReward: 25,
            ),
            RoleplayOption(
              textEn: "My bag is not there. You lost my bag! What I must do now?",
              translationRu: "Моей сумки там нет. Вы потеряли мою сумку! Что мне делать сейчас?",
              naturalnessScore: 0.50,
              feedback: "Слишком эмоционально и грамматическая ошибка ('What must I do' / 'What should I do').",
              nativeAlternative: "I've been waiting at carousel 4, but my suitcase seems to be missing.",
              nextNodeId: 'node_air_2',
              xpReward: 10,
            ),
          ],
        ),
        'node_air_2': RoleplayDialogueNode(
          id: 'node_air_2',
          characterSpeechEn: "I'm sorry to hear that. Do you have your baggage claim tag handy, and could you describe what your suitcase looks like?",
          characterSpeechRu: "Мне очень жаль. У вас под рукой багажная бирка, и не могли бы вы описать, как выглядит ваш чемодан?",
          userOptions: [
            RoleplayOption(
              textEn: "Here is the tag. It's a navy blue hard-shell Samsonite suitcase with a red luggage strap and four spinner wheels.",
              translationRu: "Вот бирка. Это темно-синий жесткий чемодан Samsonite с красным багажным ремнем и четырьмя колесиками.",
              naturalnessScore: 0.98,
              feedback: "Великолепное детальное описание: 'hard-shell', 'navy blue', 'luggage strap', 'spinner wheels'.",
              nativeAlternative: "Here's the receipt. It's medium-sized, dark navy with a prominent neon red tag.",
              nextNodeId: 'node_air_3_end',
              xpReward: 30,
            ),
          ],
        ),
        'node_air_3_end': RoleplayDialogueNode(
          id: 'node_air_3_end',
          characterSpeechEn: "Thanks. The system indicates it missed the connection in Frankfurt. It will arrive on the morning flight. Where should we deliver it?",
          characterSpeechRu: "Спасибо. Система показывает, что он пропустил пересадку во Франкфурте. Он прибудет утренним рейсом. Куда нам его доставить?",
          userOptions: [
            RoleplayOption(
              textEn: "Please deliver it to The Kensington Hotel, 109 Queen's Gate. Here is my local phone number for the courier.",
              translationRu: "Пожалуйста, доставьте его в отель The Kensington по адресу 109 Queen's Gate. Вот мой местный номер телефона для курьера.",
              naturalnessScore: 0.95,
              feedback: "Точно, вежливо и практично. Офицеру предоставлены все необходимые данные для службы доставки.",
              nativeAlternative: "Could you dispatch it to my hotel directly? Here's the address and my contact details.",
              nextNodeId: null,
              xpReward: 30,
            ),
          ],
          isEndingNode: true,
        ),
      },
    ),

    // 4. Annual Performance & Salary Review
    RoleplayScenario(
      id: 'salary_negotiation_b2',
      title: 'Переговоры о повышении зарплаты',
      titleEn: 'Performance & Compensation Review',
      description: 'Обсудите с менеджером результаты года, перевыполнение KPI и аргументируйте пересмотр оклада.',
      cefrLevel: 'B2',
      category: RoleplayCategory.business,
      characterName: 'Sarah Jenkins',
      characterRole: 'VP of Product',
      characterAvatar: '👩‍💼',
      initialNodeId: 'node_sal_1',
      nodes: {
        'node_sal_1': RoleplayDialogueNode(
          id: 'node_sal_1',
          characterSpeechEn: "Thanks for meeting today. You've had a solid year leading the mobile rewrite. How do you assess your own contribution over the past two quarters?",
          characterSpeechRu: "Спасибо за встречу. Вы отлично провели год, возглавляя переписывание мобильного приложения. Как вы сами оцениваете свой вклад за последние два квартала?",
          userOptions: [
            RoleplayOption(
              textEn: "I'm proud of our release. Beyond shipping on schedule, our crash-free rate improved to 99.8%, and onboarding conversion jumped by 22%.",
              translationRu: "Я горжусь нашим релизом. Помимо сдачи в срок, наш показатель стабильности вырос до 99.8%, а конверсия в онбординге подскочила на 22%.",
              naturalnessScore: 0.97,
              feedback: "Идеальный деловой тон: опора на метрики бизнеса и продуктовые результаты вместо эмоций.",
              nativeAlternative: "The numbers speak for themselves — we not only met our deliverables but significantly drove retention.",
              nextNodeId: 'node_sal_2',
              xpReward: 30,
            ),
            RoleplayOption(
              textEn: "I worked very hard, many hours every day. Other people do less work than me.",
              translationRu: "Я работал очень усердно, много часов каждый день. Другие люди делают меньше работы, чем я.",
              naturalnessScore: 0.45,
              feedback: "Жалобы на переработки и сравнение с коллегами в негативном ключе — слабая переговорная позиция.",
              nativeAlternative: "I consistently took on high-ownership initiatives that unblocked several teams.",
              nextNodeId: 'node_sal_2',
              xpReward: 10,
            ),
          ],
        ),
        'node_sal_2': RoleplayDialogueNode(
          id: 'node_sal_2',
          characterSpeechEn: "Those metrics are certainly impressive. Given that, what are your expectations regarding compensation adjustments for the upcoming cycle?",
          characterSpeechRu: "Эти показатели определенно впечатляют. Учитывая это, каковы ваши ожидания относительно корректировки компенсации на предстоящий цикл?",
          userOptions: [
            RoleplayOption(
              textEn: "Based on market benchmarks for Senior Mobile roles and my expanded scope of mentoring, I'd like to propose a 15% adjustment to my base salary.",
              translationRu: "Опираясь на рыночные бенчмарки для Senior Mobile ролей и мою расширившуюся зону менторства, я хотел бы предложить корректировку базового оклада на 15%.",
              naturalnessScore: 0.96,
              feedback: "Дипломатично, обоснованно и аргументированно: 'market benchmarks', 'expanded scope', 'base salary'.",
              nativeAlternative: "Reflecting the increased responsibilities and impact, a 15% increase would align my compensation with the market median.",
              nextNodeId: 'node_sal_3_end',
              xpReward: 35,
            ),
          ],
        ),
        'node_sal_3_end': RoleplayDialogueNode(
          id: 'node_sal_3_end',
          characterSpeechEn: "That's a very reasonable proposal with solid data behind it. I'll take this directly to HR and the executive committee, and I expect to have an update for you by Friday.",
          characterSpeechRu: "Это очень разумное предложение с надежными данными за ним. Я передам его в HR и комитет, и рассчитываю дать вам апдейт к пятнице.",
          userOptions: [
            RoleplayOption(
              textEn: "Thank you, Sarah. I appreciate your advocacy and look forward to hearing back from you.",
              translationRu: "Спасибо, Сара. Ценю вашу поддержку и буду ждать новостей.",
              naturalnessScore: 0.98,
              feedback: "Профессиональное завершение переговоров с выражением благодарности ('advocacy' — поддержка интересов).",
              nativeAlternative: "Much appreciated! Let's touch base at the end of the week.",
              nextNodeId: null,
              xpReward: 25,
            ),
          ],
          isEndingNode: true,
        ),
      },
    ),
  ];
}
