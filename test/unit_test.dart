import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_assignment/bloc/user_bloc/user_bloc.dart';
import 'package:test_assignment/exceptions/auth_exceptions.dart';
import 'package:test_assignment/models/user_model.dart';
import 'package:test_assignment/repositories/user_repository.dart';
import 'package:test_assignment/services/user_service.dart';

Future<void> main() async {

  late UserService _service;

  setUp(() async {
    await setUpTestHive();
    if(!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
      Hive.registerAdapter<UserModel>(UserModelAdapter());
    }
    await Hive.openBox<UserModel>('users_list');
    await Hive.openBox<UserModel>('logged_user');
    _service = UserService();
  });

  group('testing authentication', () {
    test('Test wrong creds', () {
      expect(_service.login(username: '123', password: '123'), throwsA(isA<AuthExceptions>()));
    });

    test('Test user signup',() async {
      final loggedUser = _service.signup('123', '123');
      expect(loggedUser, isNotNull);
    });

    test('Test duplicate signup creds', () {
      expect(_service.signup('123', '123'), throwsA(isA<AuthExceptions>()));
    });

    test('Test login with new created user', () {
      final loggedUser = _service.login(username: '123', password: '123');
      expect(loggedUser, isNotNull);
    });

    unawaited(tearDownTestHive());
  });
}
