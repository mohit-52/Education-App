import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late UpdateUser usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = UpdateUser(repo);

    // Register fallback values
    registerFallbackValue(UpdateUserAction.displayName);
    registerFallbackValue('');
  });

  test('should call updateUser from [AuthRepo] with different actions', () async {
    final testCases = [
      const UpdateUserParams(
          action: UpdateUserAction.displayName, userData: 'New Name'),
      const UpdateUserParams(
          action: UpdateUserAction.email, userData: 'newemail@example.com'),
      const UpdateUserParams(
          action: UpdateUserAction.password, userData: 'newSecurePassword123'),
      const UpdateUserParams(
          action: UpdateUserAction.bio, userData: 'This is my new bio.'),
      const UpdateUserParams(
          action: UpdateUserAction.profilePic,
          userData: 'https://example.com/new-pic.jpg'),
    ];

    for (var params in testCases) {
      when(() => repo.updateUser(
              action: any(named: 'action'), userData: any(named: 'userData')))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(params);
      
      expect(result, const Right<dynamic, void>(null));

      verify(() =>
              repo.updateUser(action: params.action, userData: params.userData))
          .called(1);
      verifyNoMoreInteractions(repo);
    }
  });
}
