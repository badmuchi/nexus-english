import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_english_app/core/result/result.dart';
import 'package:nexus_english_app/features/conversation/domain/entities/dialogue_node.dart';
import 'package:nexus_english_app/features/conversation/domain/usecases/get_dialogue_node_by_id_use_case.dart';
import 'package:nexus_english_app/features/conversation/domain/usecases/get_dialogue_nodes_use_case.dart';
import 'package:nexus_english_app/features/conversation/domain/usecases/log_dialogue_choice_use_case.dart';
import 'package:nexus_english_app/features/conversation/presentation/cubit/conversation_bloc.dart';
import 'package:nexus_english_app/features/conversation/presentation/cubit/conversation_event.dart';
import 'package:nexus_english_app/features/conversation/presentation/cubit/conversation_state.dart';

class MockGetDialogueNodesUseCase extends Mock
    implements GetDialogueNodesUseCase {}

class MockGetDialogueNodeByIdUseCase extends Mock
    implements GetDialogueNodeByIdUseCase {}

class MockLogDialogueChoiceUseCase extends Mock
    implements LogDialogueChoiceUseCase {}

void main() {
  late MockGetDialogueNodesUseCase mockGetNodesUseCase;
  late MockGetDialogueNodeByIdUseCase mockGetNodeByIdUseCase;
  late MockLogDialogueChoiceUseCase mockLogChoiceUseCase;

  const testOption = DialogueOption(
    id: 'opt_tea',
    labelEnglish: 'Just an Earl Grey tea to go, please.',
    labelRussian: 'Просто чай Эрл Грей с собой, пожалуйста.',
    targetNodeId: 'node_cafe_2',
  );

  const testNode1 = DialogueNode(
    id: 'node_cafe_1',
    level: 'A1',
    characterName: 'Barista',
    lineEnglish: 'Good morning! What can I get for you today?',
    lineRussian: 'Доброе утро! Что для вас приготовить?',
    options: [testOption],
  );

  const testNode2 = DialogueNode(
    id: 'node_cafe_2',
    level: 'A1',
    characterName: 'Barista',
    lineEnglish: 'Sure thing! Would you like a slice of lemon?',
    lineRussian: 'Без проблем! Добавить дольку лимона?',
    options: [],
  );

  setUp(() {
    mockGetNodesUseCase = MockGetDialogueNodesUseCase();
    mockGetNodeByIdUseCase = MockGetDialogueNodeByIdUseCase();
    mockLogChoiceUseCase = MockLogDialogueChoiceUseCase();
  });

  group('ConversationBloc Tests', () {
    blocTest<ConversationBloc, ConversationState>(
      'emits [loading, success] when LoadInitialDialogueEvent succeeds',
      build: () {
        when(() => mockGetNodesUseCase(levelFilter: any(named: 'levelFilter')))
            .thenAnswer((_) async => const Result.success([testNode1]));
        return ConversationBloc(
          getDialogueNodesUseCase: mockGetNodesUseCase,
          getDialogueNodeByIdUseCase: mockGetNodeByIdUseCase,
          logDialogueChoiceUseCase: mockLogChoiceUseCase,
        );
      },
      act: (bloc) => bloc.add(const LoadInitialDialogueEvent()),
      expect: () => [
        const ConversationState(status: ConversationStatus.loading),
        const ConversationState(
          status: ConversationStatus.success,
          allNodes: [testNode1],
          currentNode: testNode1,
          selectedLevel: 'A1',
          currentScenarioId: 'node_cafe_1',
          history: [
            DialogueHistoryItem(
              speaker: 'Barista',
              english: 'Good morning! What can I get for you today?',
              russian: 'Доброе утро! Что для вас приготовить?',
              isUser: false,
            ),
          ],
        ),
      ],
    );

    blocTest<ConversationBloc, ConversationState>(
      'appends user response and fetches next node on SelectDialogueOptionEvent',
      build: () {
        when(() => mockLogChoiceUseCase(
              nodeId: any(named: 'nodeId'),
              selectedOptionId: any(named: 'selectedOptionId'),
            )).thenAnswer((_) async => const Result.success(null));
        when(() => mockGetNodeByIdUseCase('node_cafe_2'))
            .thenAnswer((_) async => const Result.success(testNode2));
        return ConversationBloc(
          getDialogueNodesUseCase: mockGetNodesUseCase,
          getDialogueNodeByIdUseCase: mockGetNodeByIdUseCase,
          logDialogueChoiceUseCase: mockLogChoiceUseCase,
        );
      },
      seed: () => const ConversationState(
        status: ConversationStatus.success,
        allNodes: [testNode1],
        currentNode: testNode1,
        history: [
          DialogueHistoryItem(
            speaker: 'Barista',
            english: 'Good morning! What can I get for you today?',
            russian: 'Доброе утро! Что для вас приготовить?',
            isUser: false,
          ),
        ],
      ),
      act: (bloc) => bloc.add(const SelectDialogueOptionEvent(testOption)),
      expect: () => [
        const ConversationState(
          status: ConversationStatus.success,
          allNodes: [testNode1],
          currentNode: testNode1,
          isWaitingNextReply: true,
          history: [
            DialogueHistoryItem(
              speaker: 'Barista',
              english: 'Good morning! What can I get for you today?',
              russian: 'Доброе утро! Что для вас приготовить?',
              isUser: false,
            ),
            DialogueHistoryItem(
              speaker: 'You',
              english: 'Just an Earl Grey tea to go, please.',
              russian: 'Просто чай Эрл Грей с собой, пожалуйста.',
              isUser: true,
            ),
          ],
        ),
        const ConversationState(
          status: ConversationStatus.success,
          allNodes: [testNode1],
          currentNode: testNode2,
          isWaitingNextReply: false,
          history: [
            DialogueHistoryItem(
              speaker: 'Barista',
              english: 'Good morning! What can I get for you today?',
              russian: 'Доброе утро! Что для вас приготовить?',
              isUser: false,
            ),
            DialogueHistoryItem(
              speaker: 'You',
              english: 'Just an Earl Grey tea to go, please.',
              russian: 'Просто чай Эрл Грей с собой, пожалуйста.',
              isUser: true,
            ),
            DialogueHistoryItem(
              speaker: 'Barista',
              english: 'Sure thing! Would you like a slice of lemon?',
              russian: 'Без проблем! Добавить дольку лимона?',
              isUser: false,
            ),
          ],
        ),
      ],
      verify: (_) {
        verify(() => mockLogChoiceUseCase(
              nodeId: 'node_cafe_1',
              selectedOptionId: 'opt_tea',
            )).called(1);
      },
    );
    const testNodeB1 = DialogueNode(
      id: 'node_interview_1',
      level: 'B1',
      characterName: 'Sarah (HR Lead)',
      lineEnglish: 'Hi Alex, great to meet you!',
      lineRussian: 'Привет, Алекс, приятно познакомиться!',
      options: [],
    );

    blocTest<ConversationBloc, ConversationState>(
      'switches scenario correctly and updates level on SelectScenarioEvent',
      build: () {
        when(() => mockGetNodeByIdUseCase('node_interview_1'))
            .thenAnswer((_) async => const Result.success(testNodeB1));
        when(() => mockGetNodesUseCase(levelFilter: any(named: 'levelFilter')))
            .thenAnswer((_) async => const Result.success([testNode1, testNodeB1]));
        return ConversationBloc(
          getDialogueNodesUseCase: mockGetNodesUseCase,
          getDialogueNodeByIdUseCase: mockGetNodeByIdUseCase,
          logDialogueChoiceUseCase: mockLogChoiceUseCase,
        );
      },
      seed: () => const ConversationState(
        status: ConversationStatus.success,
        allNodes: [testNode1],
        currentNode: testNode1,
        selectedLevel: 'A1',
        currentScenarioId: 'node_cafe_1',
      ),
      act: (bloc) => bloc.add(const SelectScenarioEvent('node_interview_1')),
      expect: () => [
        const ConversationState(
          status: ConversationStatus.loading,
          allNodes: [testNode1],
          currentNode: testNode1,
          selectedLevel: 'A1',
          currentScenarioId: 'node_cafe_1',
        ),
        const ConversationState(
          status: ConversationStatus.success,
          allNodes: [testNode1, testNodeB1],
          currentNode: testNodeB1,
          selectedLevel: 'B1',
          currentScenarioId: 'node_interview_1',
          history: [
            DialogueHistoryItem(
              speaker: 'Sarah (HR Lead)',
              english: 'Hi Alex, great to meet you!',
              russian: 'Привет, Алекс, приятно познакомиться!',
              isUser: false,
            ),
          ],
        ),
      ],
    );

    blocTest<ConversationBloc, ConversationState>(
      'resets dialogue to the current scenario on ResetDialogueEvent',
      build: () {
        when(() => mockGetNodeByIdUseCase('node_interview_1'))
            .thenAnswer((_) async => const Result.success(testNodeB1));
        when(() => mockGetNodesUseCase(levelFilter: any(named: 'levelFilter')))
            .thenAnswer((_) async => const Result.success([testNodeB1]));
        return ConversationBloc(
          getDialogueNodesUseCase: mockGetNodesUseCase,
          getDialogueNodeByIdUseCase: mockGetNodeByIdUseCase,
          logDialogueChoiceUseCase: mockLogChoiceUseCase,
        );
      },
      seed: () => const ConversationState(
        status: ConversationStatus.success,
        allNodes: [testNodeB1],
        currentNode: testNodeB1,
        selectedLevel: 'B1',
        currentScenarioId: 'node_interview_1',
      ),
      act: (bloc) => bloc.add(const ResetDialogueEvent()),
      expect: () => [
        const ConversationState(
          status: ConversationStatus.loading,
          allNodes: [testNodeB1],
          currentNode: testNodeB1,
          selectedLevel: 'B1',
          currentScenarioId: 'node_interview_1',
        ),
        const ConversationState(
          status: ConversationStatus.success,
          allNodes: [testNodeB1],
          currentNode: testNodeB1,
          selectedLevel: 'B1',
          currentScenarioId: 'node_interview_1',
          history: [
            DialogueHistoryItem(
              speaker: 'Sarah (HR Lead)',
              english: 'Hi Alex, great to meet you!',
              russian: 'Привет, Алекс, приятно познакомиться!',
              isUser: false,
            ),
          ],
        ),
      ],
    );
  });
}
