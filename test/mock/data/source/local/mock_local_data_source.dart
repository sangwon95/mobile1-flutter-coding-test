// Mocks generated by Mockito 5.4.4 from annotations
// in mobile1_flutter_coding_test/test/layers/data/source/repository/chat_repository_imp_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mobile1_flutter_coding_test/layers/data/data.dart' as _i2;
import 'package:mobile1_flutter_coding_test/layers/domain/model/chat_message.dart'
    as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [LocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalDataSource extends _i1.Mock implements _i2.LocalDataSource {
  MockLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> addMessage(_i4.ChatMessage? message) => (super.noSuchMethod(
        Invocation.method(
          #addMessage,
          [message],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> addMessages(List<_i4.ChatMessage>? messages) =>
      (super.noSuchMethod(
        Invocation.method(
          #addMessages,
          [messages],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  List<_i2.ChatMessageDAO> getAllMessages() => (super.noSuchMethod(
        Invocation.method(
          #getAllMessages,
          [],
        ),
        returnValue: <_i2.ChatMessageDAO>[],
      ) as List<_i2.ChatMessageDAO>);
}
