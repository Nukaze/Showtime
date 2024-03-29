import 'dart:math';

import 'package:flutter/material.dart';
import 'package:showtime/utils.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class StreamingContent extends StatefulWidget {
  final String videoId;

  const StreamingContent({super.key, required this.videoId});

  @override
  _StreamingContentState createState() => _StreamingContentState();
}

class _StreamingContentState extends State<StreamingContent> {
  late YoutubePlayerController _controller;
  static const double _minute = 60;
  static const double _requiredDurationInSeconds = _minute * 20;

  late final dynamic _startTimeInSeconds;
  late final dynamic _endTimeInSeconds;

  Size aspectRatio = Size(16, 9);

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        color: 'red',
        loop: false,
        playsInline: false,
        strictRelatedVideos: true,
      ),
    );

    _controller.setFullScreenListener((isFullScreen) {
      debugPrint('The player is ${isFullScreen ? 'fullscreen' : 'not fullscreen'}');
    });

    // actual production
    // int maxStartTimeItShouldbe = _controller.metadata.duration.inSeconds.toInt() - _requiredDurationInSeconds.toInt();
    // dev mode
    int maxStartTimeItShouldbe = (_controller.metadata.duration.inSeconds.toInt() * 0.8).toInt();
    _startTimeInSeconds = randomNumber(0, maxStartTimeItShouldbe);
    _endTimeInSeconds = _startTimeInSeconds + _requiredDurationInSeconds;
    _controller.loadVideoById(
      // videoId: widget.videoId ?? "WOZfIgBR84Y",  // production
      videoId: "WOZfIgBR84Y", // dev mode
      startSeconds: _startTimeInSeconds.toDouble(),
      endSeconds: _endTimeInSeconds.toDouble(),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/showtime_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox.expand(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0), // Adjust top margin as needed
                  child: YoutubePlayerControllerProvider(
                    controller: _controller,
                    child: YoutubePlayer(
                      controller: _controller,
                      aspectRatio: aspectRatio.width / aspectRatio.height,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
