import 'dart:async';
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
  late String _videoTitle;
  String _infoText = "Loading...";
  late YoutubeMetaData _metaData;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        playsInline: false,
        mute: false,
        loop: false,
        color: 'red',
        strictRelatedVideos: true,
      ),
    );

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

    _controller.setFullScreenListener((isFullScreen) {
      debugPrint('The player is ${isFullScreen ? 'fullscreen' : 'not fullscreen'}');
    });

    Future.delayed(
      const Duration(milliseconds: 3000),
      () => {
        setState(() {
          _metaData = _controller.metadata;
          _videoTitle = _metaData.title;
          String dur = _metaData.duration.toString();
          if (_controller.metadata.title == null || _controller.metadata.title.isEmpty) {
            _videoTitle = "not available right now.";
          }
          if (_controller.metadata.duration.toString().isEmpty) {
            dur = "not available right now.";
          }

          _infoText = "Title: $_videoTitle\nDuration: $dur";

          Future.delayed(Duration(milliseconds: 1500), () {
            _videoTitle = "Dune 2";
            _infoText = "Title: $_videoTitle\nDuration: $dur";
          });
        })
      },
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
                Positioned(
                  top: 230,
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adding a background color for better visibility
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _infoText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
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
