import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nasa_apod/bloc/apod_list_cubit.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/models/nasa_image.dart';
import 'package:nasa_apod/models/nasa_video.dart';

class ApodList extends StatefulWidget {
  final ApodListState state;
  const ApodList({required this.state, super.key});

  @override
  State<ApodList> createState() => _ApodListState();
}

class _ApodListState extends State<ApodList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent * 0.75) {
      context.read<ApodListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.state.items.length,
      itemBuilder: (context, index) {
        final apod = widget.state.items[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_getImageUrl(apod)),
          ),
          title: Text(apod.title),
          trailing: Text(DateFormat.yMMMd().format(apod.date)),
        );
      },
    );
  }

  String _getImageUrl(NasaApod apod) {
    if (apod is NasaImage) {
      return apod.imageUrl;
    } else if (apod is NasaVideo) {
      return apod.thumbUrl;
    } else {
      throw AssertionError();
    }
  }
}
