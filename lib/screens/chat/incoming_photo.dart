import 'dart:io';
import 'package:flutter/material.dart';
import 'camera_view.dart';

class IncomingPhoto extends StatelessWidget {
  const IncomingPhoto({
    Key? key,
    required this.path,
    required this.isItChannel,
  }) : super(key: key);
  final String path;
  final bool isItChannel;
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
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            Visibility(
              visible: isItChannel,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/profile/details');
                },
                child: const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'http://thecaretta.com/model/photo-1.jpg',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isItChannel ? 60 : 16, vertical: 8),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2.3,
                width: MediaQuery.of(context).size.width / 1.8,
                child: Card(
                  margin: const EdgeInsets.all(3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Image.file(
                    File(path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
