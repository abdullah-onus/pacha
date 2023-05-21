import 'dart:io';
import 'package:flutter/material.dart';
import 'camera_view.dart';

class OutgoingPhoto extends StatelessWidget {
  const OutgoingPhoto({Key? key, required this.path}) : super(key: key);
  final String path;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => CameraViewPage(
                      path: path,
                      onImageSend: () {},
                      route: false,
                    )));
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2.3,
            width: MediaQuery.of(context).size.width / 1.8,
            child: Card(
              margin: const EdgeInsets.all(3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Image.file(File(path), fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
