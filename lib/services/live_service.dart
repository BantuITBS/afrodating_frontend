import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final liveServiceProvider = Provider<LiveService>((ref) => LiveService());

class LiveService {
  RtcEngine? engine;

  Future<void> initialize() async {
    // Initialize Agora
  }
}