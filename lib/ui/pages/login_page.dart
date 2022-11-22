import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_client/bloc/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _signInWithTwitter,
              child: const Text('Login'),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is SigningIn) {
                  return const CircularProgressIndicator();
                } else if (state is SignInError) {
                  return Text(state.error.toString());
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithTwitter() async {
    final router = GoRouter.of(context);
    final bloc = context.read<AuthCubit>();

    await bloc.signInWithTwitter();

    if (bloc.state is SignedInState) {
      router.go('/');
    }
  }
}
