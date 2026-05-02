import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_feild.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignupPage());
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailConroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailConroller.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    AuthFeild(controller: nameController, hintText: 'Name'),
                    SizedBox(height: 15),
                    AuthFeild(controller: emailConroller, hintText: 'Email'),
                    SizedBox(height: 15),
                    AuthFeild(
                      controller: passwordController,
                      hintText: 'Password',
                      isObsecureText: true,
                    ),
                    SizedBox(height: 20),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        } else if (state is AuthSucess) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            BlogPage.route(),
                            (route) => false,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return AuthGradientButton(
                          buttonText: "Sign Up",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthSignUp(
                                  email: emailConroller.text.trim(),
                                  password: passwordController.text.trim(),
                                  name: nameController.text.trim(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, LoginPage.route());
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppPallete.gradient2,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
