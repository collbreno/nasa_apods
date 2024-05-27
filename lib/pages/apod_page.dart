import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/models/nasa_image.dart';
import 'package:nasa_apod/models/nasa_video.dart';
import 'package:nasa_apod/widgets/apod_page_media.dart';

class ApodPage extends StatelessWidget {
  final NasaApod apod;
  const ApodPage(this.apod, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(DateFormat.yMMMd().format(apod.date))),
      body: ListView(children: [
        _buildImage(),
        const SizedBox(height: 24),
        _buildTitle(),
        const SizedBox(height: 16),
        _buildExplanation(),
        const SizedBox(height: 16),
        if (apod.copyright != null) _buildCopyright(),
      ]),
    );
  }

  Widget _buildCopyright() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
    );
  }

  Widget _buildExplanation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        apod.explanation,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildTitle() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          apod.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    });
  }

  Widget _buildImage() {
    return Hero(
      tag: _getImageUrl(),
      child: ApodPageMedia(apod),
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
