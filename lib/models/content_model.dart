class ContentModel {
  final String id;
  final String title;
  final String fileUrl;
  final String type;
  final bool isFreeTeaser;
  final String thumbnailUrl;
  final String teaserName;

  ContentModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.type,
    required this.isFreeTeaser,
    required this.thumbnailUrl,
    required this.teaserName,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      fileUrl: json['file_url'] as String,
      type: json['type'] as String,
      isFreeTeaser: json['is_free_teaser'] as bool,
      thumbnailUrl: json['thumbnail_url'] as String,
      teaserName: json['teaser_name'] as String,
    );
  }
}