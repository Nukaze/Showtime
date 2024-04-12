import 'dart:async';
import 'package:intl/intl.dart';

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

  late double screenWidth;
  late double screenHeight;

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
            String date = DateTime.now().toString().split(" ")[0];
            DateTime parsedDate = DateTime.parse(date); // Parse the date string
            String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate); // Format the parsed date

            String time = DateTime.now().toString().split(" ")[1];
            String timeHour = time.split(":")[0];
            int? timeMinute = int.tryParse(time.split(":")[1]);
            timeMinute ??= 0;
            String formattedMinute = (timeMinute > 30) ? "30" : "00";
            String formattedTime = "$timeHour:$formattedMinute";

            movie = MovieMockupMetaData(
              title: "Dune 2",
              genre: "Sci-fi / Adventure",
              seat: "A10",
              // theatreBranch: "Bangkok University",
              theatreBranch: "Future Park Rungsit",
              theatreNumber: randomNumber(1, 16),
              duration: 166,
              date: formattedDate,
              time: formattedTime,
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

  Widget _buildYoutubePlayer() {
    return Padding(
      padding: const EdgeInsets.all(0), // Adjust top margin as needed
      child: YoutubePlayerControllerProvider(
        controller: _controller,
        child: YoutubePlayer(
          controller: _controller,
          aspectRatio: aspectRatio.width / aspectRatio.height,
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  Widget _buildText(String text, double fontSize, {Color? color, FontWeight? fontWeight}) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget _buildMovieInfo() {
    const double _titleFontSize = 40.0;
    const double _subTitleFontSize = 18.0;
    const double _fontSize = 16.0;
    const double _blankSpace = 10.0;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // Calculate the percentage values for width, height, and padding
    final containerWidth = screenWidth * 0.85; // 85% of screen width
    final containerHeight = screenHeight * 0.3; // 50% of screen height
    final containerPadding = EdgeInsets.all(screenWidth * 0.05); // 5% of screen width as padding

    Color? colorInfo = Colors.grey.shade500 as Color?;
    return Positioned(
      top: screenHeight * 0.3,
      width: containerWidth,
      // height: containerHeight,
      child: Container(
        color: Colors.black.withOpacity(0.5), // Adding a background color for better visibility
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText("Now Streaming", _fontSize, color: Colors.greenAccent, fontWeight: FontWeight.bold),
              _buildText(movie.title, _titleFontSize, fontWeight: FontWeight.bold),
              _buildText(movie.genre, _fontSize, color: colorInfo),
              const SizedBox(height: 30.0),
              _buildText(movie.theatreBranch, _fontSize),
              const SizedBox(height: 10.0),
              // _buildDateAndTimeRow(movie.date, movie.time),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText("Date", _fontSize),
                      _buildText(movie.date, _fontSize, color: colorInfo),
                      _buildText("", _blankSpace),
                      _buildText("Theatre Number", _fontSize),
                      _buildText(movie.theatreNumber.toString(), _fontSize, color: colorInfo),
                    ],
                  ),
                  const SizedBox(width: 60.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText("Time", _fontSize),
                      _buildText(movie.time, _fontSize, color: colorInfo),
                      _buildText("", _blankSpace),
                      _buildText("Seat", _fontSize),
                      _buildText(movie.seat, _fontSize, color: colorInfo),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                _buildYoutubePlayer(),
                _buildMovieInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
