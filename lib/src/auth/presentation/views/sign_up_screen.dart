import 'package:education_app/src/auth/presentation/views/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/app/provider/user_provider.dart';
import '../../../../core/common/widgets/RoundedButton.dart';
import '../../../../core/common/widgets/gradient_background.dart';
import '../../../../core/res/fonts.dart';
import '../../../../core/res/media_res.dart';
import '../../../../core/utils/core_utils.dart';
import '../../../dashboard/presentation/views/dashboard.dart';
import '../../data/models/user_model.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(listener: (__, state) {
        if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is SignedUp) {
          context.read<AuthBloc>().add(SignInEvent(
              email: emailController.text.trim(),
              password: passwordController.text.trim()));
        } else if (state is SignedIn) {
          context.read<UserProvider>().initUser(state.user as LocalUserModel);
          Navigator.pushReplacementNamed(context, DashBoard.routeName);
        }
      }, builder: (context, state) {
        return GradientBackground(
          image: MediaRes.authGradientBackground,
          child: SafeArea(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const Text(
                    'Easy to learn, discover more skills',
                    style: TextStyle(
                      fontFamily: Fonts.aeonik,
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Sign up for an account',
                    style: TextStyle(fontSize: 14),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, SignInScreen.routeName);
                        },
                        child: const Text('Already have an account')),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SignUpForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    confirmPasswordController:
                    confirmPasswordController,
                    formKey: formKey, fullNameController: fullNameController,

                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(height: 30),
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    RoundedButton(
                        label: 'Sign Up',
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(SignUpEvent(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  name: fullNameController.text.trim(),
                                ));
                          }
                        })
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
