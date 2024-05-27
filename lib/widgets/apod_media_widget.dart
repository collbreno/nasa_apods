import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ApodMediaWidget extends StatelessWidget {
  final String imgUrl;
  const ApodMediaWidget({required this.imgUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 2,
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey,
              child: const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
