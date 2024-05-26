import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_apod/bloc/apod_list_cubit.dart';
import 'package:nasa_apod/widgets/apod_list_item.dart';

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
    return Scrollbar(
      child: RefreshIndicator(
        onRefresh: () => context.read<ApodListCubit>().refresh(),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.state.filtered.length,
          itemBuilder: (context, index) {
            final apod = widget.state.filtered[index];
            return ApodListItem(apod);
          },
        ),
      ),
    );
  }
}
