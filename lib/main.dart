import 'dart:developer' as devtools show log;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_riverpod/state/auth/providers/is_logged_in_provier.dart';

import 'firebase_options.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Riverpod',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      home: Consumer(
        builder: (context, ref, child) {
          final isLoggedIn = ref.watch(isLoggedInProvider);

          if (isLoggedIn) {
            return const MainView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home view",
        ),
        actions: [
          //
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(
                  Icons.logout_rounded,
                ),
                onPressed: () async {
                  ref.read(authStateProvider.notifier).logOut();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login View",
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer(
            builder: (context, ref, child) {
              return TextButton(
                onPressed: () async {
                  await ref.read(authStateProvider.notifier).logInWithGoogle();
                  // final result = await const Authenticator().loginWithGoogle();
                  // result.log();
                },
                child: const Text(
                  "Sign in with Google",
                ),
              );
            },
          ),
          //

          //
          Consumer(
            builder: (context, ref, child) {
              return TextButton(
                onPressed: () async {
                  await ref
                      .read(authStateProvider.notifier)
                      .logInWithFacebook();
                  // final result = await const Authenticator().loginWithGoogle();
                  // result.log();
                },
                child: const Text(
                  "Sign in with Facebook",
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
