part of 'user_bloc.dart';

abstract class UserState {
  final UserModel? user;

  const UserState({this.user});

  List<Object?> get props => [];
}

class LoggedInUserState extends UserState {
  @override
  final UserModel user;

  LoggedInUserState(this.user) : super(user: user);

  @override
  List<Object?> get props => [];
}

class LoggedOutUserState extends UserState {
  LoggedOutUserState() : super(user: null);

  @override
  List<Object?> get props => [];
}

class InitialUserState extends UserState {
  @override
  final UserModel? user;

  InitialUserState({this.user}) : super(user: user);

  @override
  List<Object?> get props => [];
}

class ErrorUserState extends UserState {
  ErrorUserState(this.error);

  String error;

  @override
  List<Object?> get props => [];
}

class LoadingState extends UserState {
  LoadingState();

  @override
  List<Object?> get props => [];
}
