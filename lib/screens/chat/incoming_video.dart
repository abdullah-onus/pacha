import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class IncomingVideo extends StatefulWidget {
  const IncomingVideo({Key? key, required this.path, required this.isItChannel}) : super(key: key);
  final String path;
  final bool isItChannel;
  @override
  _IncomingVideoState createState() => _IncomingVideoState();
}

class _IncomingVideoState extends State<IncomingVideo> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(File(widget.path));
    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Visibility(
            visible: widget.isItChannel,
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
            padding: EdgeInsets.symmetric(horizontal: widget.isItChannel ? 60 : 16, vertical: 8),
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: Chewie(
                      key: PageStorageKey(widget.path),
                      controller: ChewieController(
                        videoPlayerController: videoPlayerController,
                        autoInitialize: true,
                        looping: false,
                        autoPlay: false,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
