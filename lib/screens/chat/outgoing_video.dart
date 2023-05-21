import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class OutgoingVideo extends StatefulWidget {
  const OutgoingVideo({Key? key, required this.path}) : super(key: key);
  final String path;
  @override
  _OutgoingVideoState createState() => _OutgoingVideoState();
}

class _OutgoingVideoState extends State<OutgoingVideo> {
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
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SizedBox(
                width: 200,
                height: 355,
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
    );
  }
}
