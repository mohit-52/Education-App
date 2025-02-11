import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignIn usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignIn(repo);
    registerFallbackValue(SignInParams(email: '', password: ''));
  });

  const tUser = LocalUser.empty();
  const tEmail = 'test mail';
  const tPassword = 'test password';

  test('should return [LocalUser] from [AuthRepo]', () async {
    when(() => repo.signIn(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => const Right(tUser));

    final result = await usecase(
        SignInParams(password: tPassword, email: tEmail));

    expect(result, const Right<dynamic, LocalUser>(tUser));

    verify(() => repo.signIn(email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
