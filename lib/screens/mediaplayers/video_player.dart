import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String title, url;
  const VideoPlayerScreen({super.key, required this.url, required this.title});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late CustomVideoPlayerController customVideoPlayerController;
  late CachedVideoPlayerController videoPlayerController;
  @override
  void initState() {
    initializedVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    customVideoPlayerController.dispose();
    videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: GoogleFonts.ubuntu(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomVideoPlayer(
              customVideoPlayerController: customVideoPlayerController),
        ],
      ),
    );
  }

  void initializedVideoPlayer() {
    videoPlayerController = CachedVideoPlayerController.network(widget.url)
      ..initialize().then((value) {
        setState(() {});
      });
    customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: videoPlayerController);
  }
}
