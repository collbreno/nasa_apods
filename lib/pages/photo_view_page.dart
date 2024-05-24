import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {
  final String imageUrl;
  const PhotoViewPage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image viewer')),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(imageUrl),
      ),
    );
  }
}
