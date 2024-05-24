import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/models/nasa_image.dart';
import 'package:nasa_apod/models/nasa_video.dart';
import 'package:nasa_apod/pages/photo_view_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ApodMediaContent extends StatelessWidget {
  final NasaApod apod;
  const ApodMediaContent(this.apod, {super.key});

  @override
  Widget build(BuildContext context) {
    if (apod is NasaImage) {
      return _buildImage(apod as NasaImage, context);
    } else if (apod is NasaVideo) {
      return _buildVideo(apod as NasaVideo);
    } else {
      throw AssertionError();
    }
  }

  Widget _buildVideo(NasaVideo video) {
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(video.videoUrl));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: video.thumbUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(Icons.play_arrow, size: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(NasaImage image, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoViewPage(image.hdUrl),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: image.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
