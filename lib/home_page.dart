import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Page de profil'),
          backgroundColor: Colors.amber,
        ),
        body: Column(
          children: const [
            SizedBox(height: 30),
            SizedBox(
              height: 300,
              child: UserInfo(),
            ),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(30),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        child: Text(
          "Déconnexion".toUpperCase(),
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          auth.signOut();
        },
      ),
    );
  }
}

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final User? currentUser = auth.currentUser;
  String userEmail = 'En cours de chargement';

  @override
  initState() {
    super.initState();
    if (currentUser!.email != null) {
      userEmail = currentUser!.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text(
            currentUser!.uid,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: const Text(
            'Identifiant Firebase',
            style: TextStyle(fontSize: 20),
          ),
        ),
        ListTile(
          title: Text(
            userEmail,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: const Text(
            'Adresse email',
            style: TextStyle(fontSize: 20),
          ),
        ),
        GetUserData(currentUser!.uid, 'pseudo', 'Pseudo'),
        GetUserData(currentUser!.uid, 'birthdate', 'Date de naissance'),
      ],
    );
  }
}

class GetUserData extends StatelessWidget {
  final String documentId;
  final String fieldName;
  final String fieldTitle;
  const GetUserData(this.documentId, this.fieldName, this.fieldTitle);
  @override
  Widget build(BuildContext context) {
    CollectionReference users = firestore.collection('Users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const ListTile(
              title: Text(
            'Un problème est survenu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(
              data[fieldName],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(
              fieldTitle,
              style: const TextStyle(fontSize: 20),
            ),
          );
        }
        return const ListTile(
            title: Text(
          'En cours de chargement',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ));
      },
    );
  }
}
