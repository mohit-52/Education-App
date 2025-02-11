import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/utils/typedef.dart';

import '../entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<void> forgotPassword(String email);

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultFuture<void> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  });
}
