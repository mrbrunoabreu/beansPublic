import 'dart:io';
import 'package:blackbeans/widgets/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ionicons/ionicons.dart';

class ImageCaptureScreen extends StatefulWidget {
  const ImageCaptureScreen({Key? key}) : super(key: key);

  static const routeName = 'image-capture-screen';

  @override
  _ImageCaptureScreenState createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  File? _imageFile;
  String? fileName;

  Future<void> _pickImage(ImageSource source) async {
    final selected = await ImagePicker()
        .getImage(source: source, maxWidth: 800, maxHeight: 800);

    setState(() {
      _imageFile = File(selected!.path);
      fileName = path.basename(_imageFile!.path);
    });
  }

  Future<void> _cropImage() async {
    final File? cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile!.path,
        cropStyle: CropStyle.rectangle,
        aspectRatio: const CropAspectRatio(ratioX: 800, ratioY: 800));

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: const Icon(Ionicons.arrow_back, color: Colors.black),
            onPressed: Navigator.of(context).pop),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              icon: const Icon(Ionicons.camera),
              onPressed: () =>
                  _pickImage(ImageSource.camera).then((_) => _cropImage())),
          IconButton(
              icon: const Icon(Ionicons.images),
              onPressed: () =>
                  _pickImage(ImageSource.gallery).then((_) => _cropImage()))
        ],
      )),
      body: ListView(children: [
        if (_imageFile != null) ...[
          SizedBox(width: 400, height: 400, child: Image.file(_imageFile!)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  onPressed: () => _cropImage(), child: const Icon(Ionicons.crop)),
              FlatButton(
                  onPressed: () => _clear(), child: const Icon(Ionicons.reload))
            ],
          ),
          const SizedBox(height: 10),
          ImageUploader(file: _imageFile, fileName: fileName)
        ]
      ]),
    );
  }
}
