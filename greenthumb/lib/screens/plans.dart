import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenthumb/screens/add.dart';

class ChecklistPage extends StatefulWidget {
  final String plantName;
  final String userid;

  ChecklistPage({required this.plantName, required this.userid});

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  late CollectionReference<Map<String, dynamic>> _userCollection;

  @override
  void initState() {
    super.initState();
    _userCollection = FirebaseFirestore.instance.collection('users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plans for ${widget.plantName}'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPlanScreen(
                    userid: widget.userid,
                    plantName: widget.plantName,
                  ),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _userCollection
              .doc(widget.userid)
              .collection('plants')
              .doc(widget.plantName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.data() == null) {
              return Center(child: Text('No data found'));
            }

            List<Map<String, dynamic>> _checklist = [];
            final data = snapshot.data?.data() as Map<String, dynamic>?;
            if (data != null && data.containsKey('checklist')) {
              _checklist = List<Map<String, dynamic>>.from(data['checklist']);
            }

            return ListView.builder(
              itemCount: _checklist.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_checklist[index]['task']),
                  onDismissed: (direction) {
                    setState(() {
                      _checklist.removeAt(index);
                      _userCollection
                          .doc(widget.userid)
                          .collection('plants')
                          .doc(widget.plantName)
                          .set({'checklist': _checklist});
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task dismissed'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.green,
                    child: Icon(Icons.delete),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        _checklist[index]['task'],
                        style: TextStyle(
                          decoration: _checklist[index]['isDone']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Checkbox(
                        value: _checklist[index]['isDone'],
                        onChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              _checklist[index]['isDone'] = value;
                            });
                            _userCollection
                                .doc(widget.userid)
                                .collection('plants')
                                .doc(widget.plantName)
                                .set({'checklist': _checklist});
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
