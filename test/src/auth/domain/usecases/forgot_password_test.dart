import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late ForgotPassword usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = ForgotPassword(repo);
  });

  final tEmail = 'abc@gmail.com';

  test('should call the [AuthRepo.forgotPassword]', () async {
    // ASSERT
    when(() => repo.forgotPassword(any()))
        .thenAnswer((_) async => const Right(null));

    // ACT

    final result = await usecase(tEmail);

    // Assert
    expect(result, equals(const Right<dynamic, void>(null)));
    verify(()=>repo.forgotPassword(any())).called(1);
    verifyNoMoreInteractions(repo);
  });
}
