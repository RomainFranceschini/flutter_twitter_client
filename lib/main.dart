import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';
import 'package:twitter_client/ui/pages/home_page.dart';
import 'package:twitter_client/ui/pages/login_page.dart';

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

  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/login',
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
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
