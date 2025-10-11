import 'package:teaseme_flutter/models/content_model.dart';
import 'package:teaseme_flutter/services/api_service.dart';

class ContentProvider {
  List<ContentModel> _content = [];

  List<ContentModel> get content => _content;

  Future<void> fetchContent() async {
    final data = await ApiService().get('/api/content/');
    _content = (data['results'] as List).map((json) => ContentModel.fromJson(json)).toList();
  }
}