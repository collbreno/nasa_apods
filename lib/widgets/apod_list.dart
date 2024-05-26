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
    if (widget.state.dateRange == null &&
        _scrollController.position.pixels >
            _scrollController.position.maxScrollExtent * 0.75) {
      context.read<ApodListCubit>().loadMore();
    }
  }

  int get apodListLength => widget.state.filtered.length;
  bool get showFooter => widget.state.dateRange == null;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: RefreshIndicator(
        onRefresh: () => context.read<ApodListCubit>().refresh(),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: showFooter ? apodListLength + 1 : apodListLength,
          itemBuilder: (context, index) {
            if (index == apodListLength) {
              return _buildListFooter();
            }

            final apod = widget.state.filtered[index];
            return ApodListItem(apod);
          },
        ),
      ),
    );
  }

  Widget _buildListFooter() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: widget.state.isLoading
          ? const Center(
              child: SizedBox.square(
                dimension: 32,
                child: CircularProgressIndicator(),
              ),
            )
          : TextButton(
              onPressed: () => context.read<ApodListCubit>().loadMore(),
              child: Text('Load more'),
            ),
    );
  }
}
