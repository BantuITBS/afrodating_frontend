import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaPlayer extends StatelessWidget {
  final String url;
  final String type;

  const MediaPlayer({super.key, required this.url, required this.type});

  @override
  Widget build(BuildContext context) {
    return type == 'image'
        ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover)
        : const Placeholder(); // Replace with video player
  }
}