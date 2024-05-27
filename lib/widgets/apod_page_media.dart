import 'package:flutter/material.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/models/nasa_image.dart';
import 'package:nasa_apod/models/nasa_video.dart';
import 'package:nasa_apod/pages/photo_view_page.dart';
import 'package:nasa_apod/widgets/apod_media_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ApodPageMedia extends StatelessWidget {
  final NasaApod apod;
  const ApodPageMedia(this.apod, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: _buildMedia(),
    );
  }

  Widget _buildMedia() {
    if (apod is NasaImage) {
      return _buildImage();
    } else if (apod is NasaVideo) {
      return _buildVideo();
    } else {
      throw AssertionError();
    }
  }

  void _onTap(BuildContext context) {
    if (apod is NasaImage) {
      _onClickImage(context);
    } else if (apod is NasaVideo) {
      _onClickVideo();
    }
  }

  void _onClickVideo() {
    launchUrl(Uri.parse((apod as NasaVideo).videoUrl));
  }

  void _onClickImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoViewPage((apod as NasaImage).hdUrl),
      ),
    );
  }

  Widget _buildVideo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ApodMediaWidget(imgUrl: (apod as NasaVideo).thumbUrl),
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
    );
  }

  Widget _buildImage() {
    return ApodMediaWidget(
      imgUrl: (apod as NasaImage).imageUrl,
    );
  }
}
