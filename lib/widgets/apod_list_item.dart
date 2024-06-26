import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/models/nasa_image.dart';
import 'package:nasa_apod/models/nasa_video.dart';
import 'package:nasa_apod/pages/apod_page.dart';
import 'package:nasa_apod/widgets/apod_media_widget.dart';

class ApodListItem extends StatelessWidget {
  final NasaApod apod;
  const ApodListItem(this.apod, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: MediaQuery.of(context).orientation == Orientation.portrait
            ? null
            : const BoxConstraints(maxWidth: 540),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ApodPage(apod),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildImage(),
                    const SizedBox(height: 16),
                    _buildTitle(),
                    const SizedBox(height: 16),
                    _buildDateAndMediaType(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndMediaType() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDate(),
          _buildMediaType(),
        ],
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
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    });
  }

  Widget _buildImage() {
    return Hero(
      tag: _getImageUrl(),
      child: ApodMediaWidget(
        imgUrl: _getImageUrl(),
      ),
    );
  }

  Widget _buildMediaType() {
    late String label;
    late IconData icon;
    final item = apod;
    if (item is NasaImage) {
      label = 'Image';
      icon = Icons.image;
    } else if (item is NasaVideo) {
      label = 'Video';
      icon = Icons.videocam;
    } else {
      throw AssertionError();
    }

    return Row(
      children: [
        Icon(icon, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDate() {
    return Row(
      children: [
        const Icon(Icons.calendar_month, size: 14),
        const SizedBox(width: 4),
        Text(
          DateFormat.yMMMd().format(apod.date),
          style: const TextStyle(fontSize: 12),
        ),
      ],
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
