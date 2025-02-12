part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      // checks if user is first timer or not
      final prefs = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          if (prefs.getBool(kFirstTimerKey) ?? true) {
            return BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen(),
            );
          } else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;
            final localUser = LocalUserModel(
                uid: user.uid,
                email: user.email ?? '',
                points: 0,
                fullName: user.displayName ?? '');
            context.userProvider.initUser(localUser);
            return const DashBoard();
          }
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignInScreen(),
          );
        },
        settings: settings,
      );

    case SignInScreen.routeName:
      return _pageBuilder(
          (_) => BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const SignInScreen(),
              ),
          settings: settings);

    case SignUpScreen.routeName:
      return _pageBuilder(
          (_) => BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const SignUpScreen(),
              ),
          settings: settings);

    case DashBoard.routeName:
      return _pageBuilder((_) => const DashBoard(), settings: settings);

    case ForgotPasswordScreen.routeName:
      return _pageBuilder(
  (_)=>BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: ForgotPasswordScreen(),
        ),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
    Widget Function(BuildContext context) page,
    {required RouteSettings settings}) {
  return PageRouteBuilder(
      settings: settings,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      pageBuilder: (context, _, __) => page(context));
}
