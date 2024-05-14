import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPlanScreen extends StatelessWidget {
  final String userid;
  final String plantName;

  AddPlanScreen({required this.userid, required this.plantName});

  @override
  Widget build(BuildContext context) {
    TextEditingController _planController = TextEditingController();

    void _addPlan(String newPlan) async {
      CollectionReference<Map<String, dynamic>> userCollection =
          FirebaseFirestore.instance.collection('users');
      final snapshot = await userCollection
          .doc(userid)
          .collection('plants')
          .doc(plantName)
          .get();
      final data = snapshot.data();
      List<Map<String, dynamic>> checklist = [];
      if (data != null && data.containsKey('checklist')) {
        checklist = List<Map<String, dynamic>>.from(data['checklist']);
      }
      checklist.add({'task': newPlan, 'isDone': false});
      await userCollection
          .doc(userid)
          .collection('plants')
          .doc(plantName)
          .set({'checklist': checklist});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _planController,
              decoration: InputDecoration(
                labelText: 'Plan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String newPlan = _planController.text;
                if (newPlan.isNotEmpty) {
                  _addPlan(newPlan);
                  Navigator.pop(context); // Go back to the previous screen
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
