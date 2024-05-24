import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/models/nasa_image.dart';
import 'package:nasa_apod/models/nasa_video.dart';

class ApodListItem extends StatelessWidget {
  final NasaApod apod;
  const ApodListItem(this.apod, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Material(
          child: GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: _getImageUrl(),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDate(),
                      _buildMediaType(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
