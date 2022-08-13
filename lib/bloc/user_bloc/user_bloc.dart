import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/exceptions/auth_exceptions.dart';
import 'package:test_assignment/models/user_model.dart';
import 'package:test_assignment/repositories/user_repository.dart';

part 'user_state.dart';


class UserCubit extends Cubit<UserState> {
  UserCubit(this._repository): super(InitialUserState());

  final UserRepository _repository;

  Future<void> login(String username, String password) async {
    emit(LoadingState());
    try {
      final user = await _repository.login(username, password);
      emit(LoggedInUserState(user));
    } on AuthExceptions catch(e) {
      emit(ErrorUserState(e.message));
    }
  }

  Future<void> signup(String username, String password) async {
    emit(LoadingState());
    try {
      final user = await _repository.signup(username, password);
      emit(LoggedInUserState(user));
    } on AuthExceptions catch(e) {
      emit(ErrorUserState(e.message));
    }
  }

  UserModel? getLoggedInUser() {
    try {
      final user = _repository.getLoggedUser();
      emit(LoggedInUserState(user));
      return user;
    } on AuthExceptions catch(e) {
      emit(ErrorUserState(e.message));
    }
    return null;
   }

   Future<void> logout() async {
    await _repository.logout();
    emit(LoggedOutUserState());
   }



}