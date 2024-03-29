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
        playsInline: true,
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
      videoId: widget.videoId,
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
    return Scaffold(
      body: YoutubePlayerControllerProvider(
        controller: _controller,
        child: YoutubePlayer(
          controller: _controller,
          aspectRatio: 16 / 9,
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}
