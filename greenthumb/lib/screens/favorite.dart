import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenthumb/screens/plans.dart';

class FavoritesPage extends StatefulWidget {
  final String userid;

  const FavoritesPage({Key? key, required this.userid}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _favoritesStream;

  @override
  void initState() {
    super.initState();
    _favoritesStream = FirebaseFirestore.instance
        .collection('plants')
        .where('userID', isEqualTo: widget.userid)
        .where('isFavorite', isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorite Plants'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _favoritesStream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
                snapshot.data!.docs;
            if (documents.isEmpty) {
              return Center(child: Text('No favorite plants found'));
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot<Map<String, dynamic>> document =
                    documents[index];
                final data = document.data()!;
                String? imageDataString = data['image'];

                if (imageDataString != null) {
                  Uint8List imageBytes = base64Decode(imageDataString);

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: MemoryImage(imageBytes),
                      ),
                      title: Text(
                        data['name'],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(data['type']),
                    ),
                  );
                } else {
                  return Card(
                    child: ListTile(
                      title: Text(
                        data['name'],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(data['type']),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
