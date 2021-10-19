// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  auth.authStateChanges().listen((User? user) {
    if (user == null) {
      print('Utilisateur non connecté');
      runApp(const LoginTabBar());
    } else {
      print('Utilisateur connecté: ' + user.email!);
      runApp(const HomePage());
    }
  });
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Page de profil'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: ElevatedButton(
            child: const Text("Déconnexion"),
            onPressed: () {
              auth.signOut();
            },
          ),
        ),
      ),
    );
  }
}

class LoginTabBar extends StatelessWidget {
  const LoginTabBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Page de connexion'),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              loginToFirebase();
            },
            child: const Text("connexion"),
          ),
        ),
      ),
    );
  }

  void loginToFirebase() {
    try {
      auth
          .signInWithEmailAndPassword(
              email: 'liedell@orange.fr', password: '123mdp')
          .then((value) {
        print(value.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
