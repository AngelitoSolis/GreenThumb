import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPlans extends StatefulWidget {
  final String user_ID;
  const AddPlans({Key? key, required this.user_ID}) : super(key: key);

  @override
  _AddPlansState createState() => _AddPlansState();
}

class _AddPlansState extends State<AddPlans> {
  File? _imageFile;

  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantTypeController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Picture'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plant'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _plantNameController,
                decoration: InputDecoration(
                  labelText: 'Plant Name',
                  hintText: 'Enter the name of the plant',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _plantTypeController,
                decoration: InputDecoration(
                  labelText: 'Plant Type',
                  hintText: 'Enter the type of the plant',
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _showImagePicker(context);
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String plantName = _plantNameController.text;
                    String plantType = _plantTypeController.text;
                    File? plantImage = _imageFile;

                    if (plantName.isNotEmpty &&
                        plantType.isNotEmpty &&
                        plantImage != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      String imageUrl =
                          ''; // Initialize with empty string for now

                      // Convert image to bytes
                      List<int> imageBytes = plantImage.readAsBytesSync();

                      // Encode bytes to base64 string
                      String base64Image = base64Encode(imageBytes);

                      // Store base64 string in Firestore
                      await FirebaseFirestore.instance
                          .collection('plants')
                      
                          .add({
                        'userID': widget.user_ID,
                        'name': plantName,
                        'type': plantType,
                        'image': base64Image,
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Plant added successfully')),
                      );

                      _plantNameController.clear();
                      _plantTypeController.clear();
                      setState(() {
                        _imageFile = null;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please fill all fields and select an image')),
                      );
                    }
                  },
                  child: Text('Add Plant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
