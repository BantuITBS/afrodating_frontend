import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://api.teaseme.co.za'));

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async {
    final response = await dio.post(path, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> get(String path) async {
    final response = await dio.get(path);
    return response.data;
  }
}