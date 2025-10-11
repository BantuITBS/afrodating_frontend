import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

class NotificationService {
  Future<void> initialize() async {
    // Firebase Messaging setup
  }
}