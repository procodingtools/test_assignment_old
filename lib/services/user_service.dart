import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_assignment/exceptions/auth_exceptions.dart';
import 'package:test_assignment/models/user_model.dart';

class UserService {
  late Box<UserModel> _usersBox;
  late Box<UserModel> _loggedInUserBox;

  UserService() {
    _usersBox = Hive.box('users_list');
    _loggedInUserBox = Hive.box('logged_user');
  }

  UserModel? getLoggedInUser() {
    if (_loggedInUserBox.isEmpty) {
      return null;
    }
    return _loggedInUserBox.getAt(0);
  }

  Future<UserModel> login(
      {required String username, required String password}) async {
    // Getting existing users list
    final users = _usersBox.values;

    // Simulating await time
    await Future.delayed(const Duration(seconds: 1));

    try {
      UserModel user = users.firstWhere(
          (user) => user.username == username && user.password == password);
      await _loggedInUserBox.clear();
      user = user.clone();
      _loggedInUserBox.add(user);
      return user;
    } catch (e) {
      throw AuthExceptions.wrongCredentials();
    }
  }

  Future<UserModel> signup(String username, String password) async {
    final users = _usersBox.values;
    try {
      users.firstWhere((user) => user.username == username);
      throw AuthExceptions.existedUser();
    } catch (e) {
      if (e is AuthExceptions) {
        rethrow;
      }
    }

    final user = UserModel(username: username, password: password);
    _usersBox.add(user);
    _loggedInUserBox.add(user.clone());

    // Simulate request delay
    await Future.delayed(const Duration(seconds: 1));
    return user;
  }

  Future<void> logout() async {
    await _loggedInUserBox.clear();
  }

}
