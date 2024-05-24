import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/models/nasa_image.dart';
import 'package:nasa_apod/models/nasa_video.dart';

class ApodPage extends StatelessWidget {
  final NasaApod apod;
  const ApodPage(this.apod, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(DateFormat.yMMMd().format(apod.date))),
      body: ListView(children: [
        Hero(
          tag: _getImageUrl(),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: _getImageUrl(),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            apod.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            apod.explanation,
            textAlign: TextAlign.justify,
          ),
        ),
        if (apod.copyright != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.copyright),
                  const SizedBox(width: 4),
                  Text(apod.copyright!),
                ],
              ),
            ),
          ),
      ]),
    );
  }

  String _getImageUrl() {
    final item = apod;
    if (item is NasaImage) {
      return item.imageUrl;
    } else if (item is NasaVideo) {
      return item.thumbUrl;
    } else {
      throw AssertionError();
    }
  }
}
