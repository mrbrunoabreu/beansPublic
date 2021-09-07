import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart';

class ImageUploader extends StatefulWidget {
  final File? file;
  final String? fileName;

  ImageUploader({Key? key, this.file, this.fileName}) : super(key: key);

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://beans-aa4aa.appspot.com');

  UploadTask? _uploadTask;
  String uid = '';

  Future<void> _startUpload() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      uid = user.uid;
    }

    try {
      await FirebaseStorage.instance
          .ref('uploads/file-to-upload.png')
          .putFile(widget.file!);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }

    final String filePath = 'images/$uid/${widget.fileName}';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file!);
    });
    final TaskSnapshot taskSnapshot = await _uploadTask!.whenComplete(() {});
    final String imageUrl = await taskSnapshot.ref.getDownloadURL();
    Navigator.of(context).pop(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
          stream: _uploadTask!.asStream(),
          builder: (context, snapshot) {
            var event = snapshot.data;
            double progressPercent =
                event != null ? event.bytesTransferred / event.totalBytes : 0;
            return Column(
              children: [
                if (_uploadTask!.snapshot.state == TaskState.success)
                  const Text('Finished'),
                if (_uploadTask!.snapshot.state == TaskState.paused)
                  TextButton(
                      onPressed: () => _uploadTask!.resume(),
                      child: const Icon(Ionicons.play)),
                if (_uploadTask!.snapshot.state == TaskState.running)
                  TextButton(
                      onPressed: () => _uploadTask!.pause(),
                      child: const Icon(Ionicons.pause)),
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} %',
                    style: Theme.of(context).textTheme.bodyText2)
              ],
            );
          });
    } else {
      return TextButton.icon(
          onPressed: _startUpload,
          icon: const Icon(Ionicons.cloud_upload),
          label: const Text('Upload image'));
    }
  }
}
