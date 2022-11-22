import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';
import 'package:twitter_client/repositories/token_repository.dart';
import 'package:twitter_client/ui/pages/home_page.dart';
import 'package:twitter_client/ui/pages/login_page.dart';

import 'bloc/auth_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final twitter = TwitterApi(
    bearerToken:
        'AAAAAAAAAAAAAAAAAAAAADlLjgEAAAAAkXLxd1EhiYLnwymSIFQiZjQJ67c%3Dxp9G95ndZdw8VmNUoV2QLgOlPYniLPpdsTCG8I5D2rRn2ZD56k',
  );

  runApp(
    RepositoryProvider(
      create: (context) => TokenRepository(),
      child: BlocProvider(
        create: (context) => AuthCubit(
          RepositoryProvider.of<TokenRepository>(context),
        ),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // StreamSubscription? _subscription;
  late final GoRouter _router;

  @override
  void initState() {
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) async {
        final loggingIn = state.subloc == '/login';
        final bloc = context.read<AuthCubit>();

        if (bloc.state is AuthInitial) {
          await bloc.restoreTokenFromCache();

          /*final completer = Completer();
          _awaitAuthBloc(bloc, completer);
          await completer.future;*/
        }

        final authState = bloc.state;
        final signedIn =
            authState is SignedInState && authState.token.isNotExpired;

        // if the user is not logged in, they need to login
        if (!signedIn) return loggingIn ? null : '/login';

        // if the user is logged in but still on the login page, send them to
        // the home page
        if (loggingIn) return '/';

        // no need to redirect at all
        return null;
      },
    );
    super.initState();
  }

  /*@override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }*/

  /*void _awaitAuthBloc(AuthCubit bloc, Completer completer) {
    _subscription = bloc.stream.listen((state) {
      if (state is! AuthInitial) {
        completer.complete();
        _subscription?.cancel();
        _subscription = null;
      }
    });
  }*/

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Twitter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}
