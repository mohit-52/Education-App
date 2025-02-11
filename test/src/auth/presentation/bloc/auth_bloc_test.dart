import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignUpParams = SignUpParams.empty();
  const tUpdateParams = UpdateUserParams.empty();
  const tSignInParams = SignInParams.empty();

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
    );
  });

  setUpAll(() {
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tUpdateParams);
  });

  tearDown(() => authBloc.close());

  test('initialState should be [AuthInitial]', () {
    expect(authBloc.state, const AuthInitial());
  });
  final tServerFailure = ServerFailure(
      message: 'user-not-found',
      statusCode: 'There is no user record to this identifier');
  group('SignInEvent', () {
    const tUser = LocalUserModel.empty();

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedIn] when [SignInEvent] is aaded',
      build: () {
        when(() => signIn(any())).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInEvent(
        email: tSignInParams.email,
        password: tSignInParams.password,
      )),
      expect: () => [const AuthLoading(), const SignedIn(tUser)],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signIn fails',
      build: () {
        when(() => signIn(any())).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInEvent(
        email: tSignInParams.email,
        password: tSignInParams.password,
      )),
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('signUpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedUp] when SignUpEvent is added',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.fullName)),
      expect: () => [AuthLoading(), SignedUp()],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when SignUpEvent is added and fails',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.fullName)),
      expect: () => [AuthLoading(), AuthError(tServerFailure.message)],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('forgotPasswordEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, ForgotPasswordSent] when ForgotPasswordEvent is added',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent('email')),
      expect: () => [AuthLoading(), ForgotPasswordSent()],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when ForgotPasswordEvent is added and fails',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent('email')),
      expect: () => [AuthLoading(), AuthError(tServerFailure.message)],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('updateUserEvent', (){
    blocTest<AuthBloc, AuthState>(      'should emit [AuthLoading, UserUpdated] when UpdateUserEvent is added',
        build: (){
      when(()=> updateUser(any())).thenAnswer((_)async => const Right((null)));
      return authBloc;
        },
    act:(bloc) => bloc.add(UpdateUserEvent(action: tUpdateParams.action, userData: tUpdateParams.userData)) ,
    expect: ()=> [AuthLoading(), UserUpdated()],
    verify: (_){
      verify(()=> updateUser(tUpdateParams)).called(1);
      verifyNoMoreInteractions(updateUser);
    },
    );

    blocTest<AuthBloc, AuthState>('should emit [AuthLoading, AuthError] when UpdateUserEvent is added and fails',
      build: (){
        when(()=> updateUser(any())).thenAnswer((_)async => Left(tServerFailure));
        return authBloc;
      },
      act:(bloc) => bloc.add(UpdateUserEvent(action: tUpdateParams.action, userData: tUpdateParams.userData)) ,
      expect: () => [AuthLoading(), AuthError(tServerFailure.message)],
      verify: (_){
        verify(()=> updateUser(tUpdateParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
