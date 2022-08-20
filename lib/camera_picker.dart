
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppPicker extends StatefulWidget {
  const AppPicker({Key? key}) : super(key: key);
  @override
  State<AppPicker> createState() => _AppPickerState();
}



class _AppPickerState extends State<AppPicker> {

  XFile? imageFile;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future picImage() async {
    XFile? selectedImageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(selectedImageFile != null){
      imageFile = selectedImageFile;
      setState(() {

      });
    }
  }

  Future takeImage() async {
    XFile? selectedImageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if(selectedImageFile != null){
      imageFile = selectedImageFile;
      setState(() {

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Camera Picker"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
      Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(child: imageFile == null ? Text('No Image') : Image.file(File(imageFile!.path)))
        ],
      ),
      Card(
        child: Column(
          children:<Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('camera'),
                  onPressed: () {
                    takeImage();
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('gallery'),
                  onPressed: () { picImage(); },
                ),
                const SizedBox(width: 8),

              ],
            ),
          ],

        ),
    )
  ],
      ),
    );
  }
}