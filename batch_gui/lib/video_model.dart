class VideoModel {
  final String id;
  final String title;
  final String channel;
  final String duration;
  final String thumbnailUrl;
  final String url;
  final String platform;
  bool isDownloading;
  bool isCompleted;

  VideoModel({
    required this.id,
    required this.title,
    required this.channel,
    required this.duration,
    required this.thumbnailUrl,
    required this.url,
    required this.platform,
    this.isDownloading = false,
    this.isCompleted = false,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown Title',
      channel: json['uploader'] ?? 'Unknown Channel',
      duration: json['duration_string'] ?? '0:00',
      thumbnailUrl: json['thumbnail'] ?? '',
      url: json['webpage_url'] ?? '',
      platform: json['extractor'] ?? 'unknown',
    );
  }
}
