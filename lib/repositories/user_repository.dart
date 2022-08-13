import 'package:test_assignment/exceptions/auth_exceptions.dart';
import 'package:test_assignment/models/user_model.dart';
import 'package:test_assignment/services/user_service.dart';

class UserRepository {
  UserService service;

  UserRepository(this.service);

  UserModel getLoggedUser() {
    final user = service.getLoggedInUser();
    if (user == null) {
      throw AuthExceptions.unauthenticated();
    } else {
      return user;
    }
  }

  Future<UserModel> login(String username, String password) async {
    try {
      final user = await service.login(username: username, password: password);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signup(String username, String password) async {
    final user = await service.signup(username, password);
    return user;
  }

  Future<void> logout() async {
    await service.logout();
  }
}
