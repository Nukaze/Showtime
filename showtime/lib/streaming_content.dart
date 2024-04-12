import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showtime/struct_class.dart';
import 'package:showtime/utils.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Size aspectRatio = const Size(16, 9);
  late String _movieTitle = "Loading...";
  late MetaDataResponse _metaData;

  // Mock up metadata for testing
  MovieMockupMetaData movie = MovieMockupMetaData();

  @override
  void initState() {
    super.initState();

    setState(() {
      movie.title = "Loading...";
    });

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
        setState(() async {
          _metaData = (await fetchYoutubeMetadata(widget.videoId))!;
          _movieTitle = _metaData.items[0].snippet.title;
          String channelName = _metaData.items[0].snippet.channelTitle;
          if (_movieTitle.isEmpty) {
            _movieTitle = "not available right now.";
          }
          if (channelName.isEmpty) {
            channelName = "not available right now.";
          }

          setState(() {
            movie = MovieMockupMetaData(
              title: "Dune 2",
              genre: "Sci-fi / Adventure",
              seat: "A1",
              theatreBranch: "Bangkok University",
              theatreNumber: randomNumber(1, 16),
              duration: 166,
              date: DateTime.now().toString().split(" ")[0],
              time: DateTime.now().toString().split(" ")[1],
            );
          });
        })
      },
    );
  }

  Future<MetaDataResponse?> fetchYoutubeMetadata(String videoId) async {
    if (videoId.isEmpty) {
      throw ArgumentError('videoId cannot be empty');
    }

    const String apiKey = "AIzaSyDtRcryAopzK84mYu9vi5Ap5rCKkzO30JA";
    try {
      final response = await http.get(Uri.parse(
          "https://www.googleapis.com/youtube/v3/videos?part=snippet,contentDetails&id=$videoId&key=$apiKey"));
      if (response.statusCode == 200) {
        debugPrint("\n\n\n\n\n\n#Response: ${response.body}\n\n\n\n\n\n\n\n\n");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return MetaDataResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load metadata');
      }
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(movie.genre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                        Text(
                          movie.theatreBranch,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
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
