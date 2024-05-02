import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:greenthumb/model/model.dart';
import 'package:greenthumb/screens/add_plans.dart';
import 'package:greenthumb/screens/details.dart';
import 'package:greenthumb/screens/login.dart';
import 'package:greenthumb/screens/plans.dart';

import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  final String userid;

  const HomePage({Key? key, required this.userid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _plantStream;

  @override
  void initState() {
    super.initState();
    _plantStream = FirebaseFirestore.instance
        .collection('plants')
        .where('userID', isEqualTo: widget.userid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Plant> _plantList = Plant.plantList;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Welcome to",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) => Login()));
                    },
                    icon: Icon(Icons.logout),
                    iconSize: 35,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "GreenThumb",
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Gap(20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 50.0,
              width: size.width,
              child: Text(
                "Trending Plants",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: size.height * .3,
              child: ListView.builder(
                  itemCount: _plantList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: DetailPage(
                                  plantId: _plantList[index].plantId,
                                ),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 50,
                              right: 50,
                              top: 50,
                              bottom: 50,
                              child: Image.asset(_plantList[index].imageURL),
                            ),
                            Positioned(
                              bottom: 15,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _plantList[index].category,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    _plantList[index].plantName,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
              child: const Text(
                'My Plants',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _plantStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            documents = snapshot.data!.docs;
                        if (documents.isEmpty) {
                          return Center(child: Text('No plants found'));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            final DocumentSnapshot<Map<String, dynamic>>
                                document = documents[index];
                            final data = document.data()!;
                            // Assuming 'document' is your DocumentSnapshot containing the image data
                            String? imageDataString = document.data()?['image'];

                            if (imageDataString != null) {
                              // Decode base64 string to Uint8List
                              Uint8List imageBytes =
                                  base64Decode(imageDataString);

                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => Plans()));
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: MemoryImage(imageBytes),
                                  ),
                                  title: Text(data['name']),
                                  subtitle: Text(data['type']),
                                  // Add more widgets or customize the ListTile as needed
                                ),
                              );
                            }
                          },
                        );
                      })),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => AddPlans(
                    user_ID: widget.userid,
                  )));
        },
        child: Icon(
          Icons.add,
          color: Colors.white70,
        ),
      ),
    );
  }
}
