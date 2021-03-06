import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FutureBuilderTest extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc('nQXwYp7BXnN4McLLw7nXKCEfWE52').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}

class StreamBuilderTest extends StatelessWidget {

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('user').where('role', isEqualTo: 'manager').snapshots();

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final docs = snapshot.data!.docs;
        return Text("Complete");
      },
    );
  }
}