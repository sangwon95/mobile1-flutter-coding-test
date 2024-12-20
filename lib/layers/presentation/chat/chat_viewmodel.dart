import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../../domain/authorization.dart';
import '../../domain/domain.dart';

class ChatViewModel extends ChangeNotifier {
  /// 상태 변수
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';
  String _roomId = '';
  List<ChatMessage> _chatMessageList = [];
  List<ChatMessage> _rawMessageList = [];
  final _chatComposerController = TextEditingController();

  /// 상태 getter
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String get errorMessage => _errorMessage;
  List<ChatMessage> get chatMessageList => _chatMessageList;
  TextEditingController get chatComposerController => _chatComposerController;

  /// UseCase 인스턴스
  final FetchChatMessageUseCase _fetchChatMessageUseCase;
  final AddChatMessageUseCase _addChatMessageUseCase;
  final GetAllChatMessageUseCase _getAllChatMessageUseCase;

  ChatViewModel({
    FetchChatMessageUseCase? fetchChatMessageUseCase,
    AddChatMessageUseCase? addChatMessageUseCase,
    GetAllChatMessageUseCase? getAllChatMessageUseCase,
  })  : _fetchChatMessageUseCase = fetchChatMessageUseCase ?? locator(),
        _addChatMessageUseCase = addChatMessageUseCase ?? locator(),
        _getAllChatMessageUseCase = getAllChatMessageUseCase ?? locator();

  /// 방 ID 초기화
  initRoomId(String roomId) {
    _roomId = roomId;
  }

  /// 채팅 메시지 목록을 가져오는 함수
  Future<void> fetchChatMessageList() async {
    try {
      final localMessages = _getAllChatMessageUseCase.execute(); // 로컬 메시지 로드
      _rawMessageList = List.from(localMessages);

      if (localMessages.isNotEmpty) {
        _chatMessageList = List.from(
            Etc.filterMessagesByRoomId(localMessages, _roomId).reversed);
      } else {
        await _fetchAndStoreChatMessages(); // 로컬에 데이터가 없다면 API 호출
      }
    } catch (e) {
      _notifyError(AppStrings.unexpectedError);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 외부 API 호출하여 메시지 가져오고 로컬에 저장하는 함수
  Future<void> _fetchAndStoreChatMessages() async {
    final chatMessages = await _fetchChatMessageUseCase.execute();
    _rawMessageList = List.from(chatMessages);
    _chatMessageList =
        List.from(Etc.filterMessagesByRoomId(chatMessages, _roomId).reversed);

    if (_chatMessageList.isNotEmpty) {
      await _addChatMessageUseCase.execute(chatMessages);
    }
  }

  /// 메시지 전송 함수
  Future<void> sendMessage() async {
    try {
      final inputMessage = createChatMessage();

      await _addChatMessageUseCase.execute([inputMessage]); // 로컬 DB에 메시지 저장
      _chatMessageList.insert(0, inputMessage); // 새로운 메시지를 리스트에 추가

      chatComposerController.clear(); // 메시지 입력창 초기화
      notifyListeners();
    } catch (e) {
      _notifyError(AppStrings.unexpectedError);
    }
  }

  /// 새로운 채팅 메시지를 생성하는 함수
  createChatMessage() {
    return ChatMessage(
      roomId: _roomId,
      messageId: 'msg${_rawMessageList.length + 1}',
      sender: Authorization().userId,
      content: chatComposerController.text,
      timestamp: DateTime.now(),
    );
  }

  /// 실패 시 재시도 함수
  void onRetry() {
    _isLoading = true;
    _isError = false;
    _chatMessageList.clear();
    notifyListeners();

    fetchChatMessageList();
  }

  /// 오류 발생 시 오류 상태 및 메시지 업데이트
  void _notifyError(String errorMsg) {
    _isLoading = false;
    _isError = true;
    _errorMessage = errorMsg;
    notifyListeners();
  }

  @override
  void dispose() {
    _chatComposerController.dispose();
    super.dispose();
  }
}
