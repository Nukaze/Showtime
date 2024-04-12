class MovieMockupMetaData {
  String title;
  String genre;
  String seat;
  String theatreBranch;
  int theatreNumber;
  int duration; // duration in minutes
  String date;
  String time;

  MovieMockupMetaData({
    this.title = "not available right now.",
    this.genre = "not available right now.",
    this.seat = "not available right now.",
    this.theatreBranch = "not available right now.",
    this.theatreNumber = 0,
    this.duration = 0,
    this.date = "not available right now.",
    this.time = "not available right now.",
  });
}

class MetaDataResponse {
  final String kind;
  final String etag;
  final List<VideoItem> items;
  final PageInfo pageInfo;

  MetaDataResponse({
    required this.kind,
    required this.etag,
    required this.items,
    required this.pageInfo,
  });

  factory MetaDataResponse.fromJson(Map<String, dynamic> json) {
    return MetaDataResponse(
      kind: json['kind'],
      etag: json['etag'],
      items: (json['items'] as List<dynamic>).map((itemJson) => VideoItem.fromJson(itemJson)).toList(),
      pageInfo: PageInfo.fromJson(json['pageInfo']),
    );
  }
}

class VideoItem {
  final String kind;
  final String etag;
  final String id;
  final VideoSnippet snippet;
  final VideoContentDetails contentDetails;

  VideoItem({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet,
    required this.contentDetails,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      kind: json['kind'],
      etag: json['etag'],
      id: json['id'],
      snippet: VideoSnippet.fromJson(json['snippet']),
      contentDetails: VideoContentDetails.fromJson(json['contentDetails']),
    );
  }
}

class VideoSnippet {
  final String publishedAt;
  final String channelId;
  final String title;
  final String description;
  final Thumbnails thumbnails;
  final String channelTitle;
  final List<String> tags;
  final String categoryId;
  final String liveBroadcastContent;
  final Localized localized;

  VideoSnippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.tags,
    required this.categoryId,
    required this.liveBroadcastContent,
    required this.localized,
  });

  factory VideoSnippet.fromJson(Map<String, dynamic> json) {
    return VideoSnippet(
      publishedAt: json['publishedAt'],
      channelId: json['channelId'],
      title: json['title'],
      description: json['description'],
      thumbnails: Thumbnails.fromJson(json['thumbnails']),
      channelTitle: json['channelTitle'],
      tags: List<String>.from(json['tags']),
      categoryId: json['categoryId'],
      liveBroadcastContent: json['liveBroadcastContent'],
      localized: Localized.fromJson(json['localized']),
    );
  }
}

class Thumbnails {
  final Thumbnail defaultThumbnail;
  final Thumbnail mediumThumbnail;
  final Thumbnail highThumbnail;
  final Thumbnail standardThumbnail;
  final Thumbnail maxresThumbnail;

  Thumbnails({
    required this.defaultThumbnail,
    required this.mediumThumbnail,
    required this.highThumbnail,
    required this.standardThumbnail,
    required this.maxresThumbnail,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return Thumbnails(
      defaultThumbnail: Thumbnail.fromJson(json['default']),
      mediumThumbnail: Thumbnail.fromJson(json['medium']),
      highThumbnail: Thumbnail.fromJson(json['high']),
      standardThumbnail: Thumbnail.fromJson(json['standard']),
      maxresThumbnail: Thumbnail.fromJson(json['maxres']),
    );
  }
}

class Thumbnail {
  final String url;
  final int width;
  final int height;

  Thumbnail({
    required this.url,
    required this.width,
    required this.height,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }
}

class Localized {
  final String title;
  final String description;

  Localized({
    required this.title,
    required this.description,
  });

  factory Localized.fromJson(Map<String, dynamic> json) {
    return Localized(
      title: json['title'],
      description: json['description'],
    );
  }
}

class VideoContentDetails {
  final String duration;
  final String dimension;
  final String definition;
  final String caption;
  final bool licensedContent;
  final Map<String, dynamic> contentRating;
  final String projection;

  VideoContentDetails({
    required this.duration,
    required this.dimension,
    required this.definition,
    required this.caption,
    required this.licensedContent,
    required this.contentRating,
    required this.projection,
  });

  factory VideoContentDetails.fromJson(Map<String, dynamic> json) {
    return VideoContentDetails(
      duration: json['duration'],
      dimension: json['dimension'],
      definition: json['definition'],
      caption: json['caption'],
      licensedContent: json['licensedContent'],
      contentRating: json['contentRating'],
      projection: json['projection'],
    );
  }
}

class PageInfo {
  final int totalResults;
  final int resultsPerPage;

  PageInfo({
    required this.totalResults,
    required this.resultsPerPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      totalResults: json['totalResults'],
      resultsPerPage: json['resultsPerPage'],
    );
  }
}
