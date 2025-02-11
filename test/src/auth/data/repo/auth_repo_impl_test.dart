import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/data/repo/auth_repo_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRemoteDataSrc extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSrc;
  late AuthRepoImpl repoImpl;

  setUp(() {
    remoteDataSrc = MockAuthRemoteDataSrc();
    repoImpl = AuthRepoImpl(remoteDataSrc);
    registerFallbackValue(UpdateUserAction.displayName);
  });

  const tException =
      ServerException(message: 'Unknown Error Occured', statusCode: 500);

  group('forgotPassword', () {
    const tEmail = 'test mail';
    test(
        'should call [remoteDataSource.forgotPassword] and and return Right(null) on success',
        () async {
      // arrange
      when(() => remoteDataSrc.forgotPassword(any()))
          .thenAnswer((_) async => Future.value());
      // act
      final result = await repoImpl.forgotPassword(tEmail);
      //     assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => remoteDataSrc.forgotPassword(tEmail)).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test('should throw [ServerException] on failure', () async {
      when(() => remoteDataSrc.forgotPassword(tEmail)).thenThrow(tException);

      final result = await repoImpl.forgotPassword(tEmail);

      expect(
          result,
          equals(Left(ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode))));

      verify(() => remoteDataSrc.forgotPassword(tEmail)).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });

  group('signIn', () {
    const tEmail = 'test mail';
    const tPassword = 'test password';
    final tUserModel = LocalUserModel.empty();
    test(
        'should call [remoteDataSource.signIn] and and return LocalUserModel on success',
        () async {
      // arrange
      when(() => remoteDataSrc.signIn(email: tEmail, password: tPassword))
          .thenAnswer((_) async => tUserModel);
      // act
      final result = await repoImpl.signIn(email: tEmail, password: tPassword);
      //     assert
      expect(result, equals(Right(tUserModel)));
      verify(() => remoteDataSrc.signIn(email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test('should throw [ServerException] on failure', () async {
      when(() => remoteDataSrc.signIn(email: tEmail, password: tPassword))
          .thenThrow(tException);

      final result = await repoImpl.signIn(email: tEmail, password: tPassword);

      expect(
          result,
          equals(Left(ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode))));

      verify(() => remoteDataSrc.signIn(email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });

  group('signUp', () {
    const tEmail = 'test mail';
    const tPassword = 'test password';
    const tFullName = 'test name';

    test('should call [AuthRemote.signUp] and return Right(null)', () async {
      when(() => remoteDataSrc.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName)).thenAnswer((_) async => const Right(null));

      final result = await repoImpl.signUp(
          email: tEmail, password: tPassword, fullName: tFullName);

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => remoteDataSrc.signUp(
          email: tEmail, password: tPassword, fullName: tFullName)).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test('should throw [ServerException] on failure', () async {
      when(() => remoteDataSrc.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName))
          .thenThrow(tException);

      final result = await repoImpl.signUp(
          email: tEmail, password: tPassword, fullName: tFullName);
      expect(
          result,
          equals(Left(ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode))));

      verify(() =>remoteDataSrc.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName))
          .called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });

  group('updateUser', () {
    final testCases = {
      UpdateUserAction.displayName: 'New Name',
      UpdateUserAction.email: 'newemail@example.com',
      UpdateUserAction.password: 'newSecurePassword123',
      UpdateUserAction.bio: 'This is my new bio.',
      UpdateUserAction.profilePic: 'https://example.com/new-pic.jpg',
    };

    testCases.forEach((action, userData) {
      test(
        'should call updateUser with action $action and return Right(null) on success',
            () async {
          when(() => remoteDataSrc.updateUser(
              action: any(named: 'action'), userData: any(named: 'userData')))
              .thenAnswer((_) async => Future.value());

          final result = await repoImpl.updateUser(action: action, userData: userData);

          expect(result, equals(const Right<dynamic, void>(null)));

          verify(() => remoteDataSrc.updateUser(action: action, userData: userData))
              .called(1);
          verifyNoMoreInteractions(remoteDataSrc);
        },
      );

      test('should return ServerFailure on exception when updating $action', () async {
        when(() => remoteDataSrc.updateUser(
            action: any(named: 'action'), userData: any(named: 'userData')))
            .thenThrow(ServerException(message: 'Update Failed', statusCode: 400));

        final result = await repoImpl.updateUser(action: action, userData: userData);

        expect(
            result,
            equals(Left(
                ServerFailure(message: 'Update Failed', statusCode: 400))));

        verify(() => remoteDataSrc.updateUser(action: action, userData: userData))
            .called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      });
    });
  });
}
