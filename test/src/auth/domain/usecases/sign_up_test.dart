import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignUp usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
    registerFallbackValue(SignUpParams(email: '', password: '', fullName: ''));
  });

  const tEmail = 'test@email.com';
  const tPassword = 'test_password';
  const tFullName = 'mohit';

  test('should call the [AuthRepo]', () async {
    when(
      () => repo.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(const SignUpParams(
      email: tEmail,
      password: tPassword,
      fullName: tFullName,
    ));

    expect(result,  Right<dynamic, void>(null));
    verify(() => repo.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        )).called(1);
    verifyNoMoreInteractions(repo);
  });
}
