import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_apod/bloc/apod_list_cubit.dart';
import 'package:nasa_apod/repository/i_app_repository.dart';
import 'package:nasa_apod/utils/date_utils.dart';
import 'package:nasa_apod/widgets/apod_list.dart';
import 'package:nasa_apod/widgets/apod_search_bar.dart';
import 'package:nasa_apod/widgets/app_error_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ApodListCubit(context.read<IAppRepository>())..loadMore(),
      child: Scaffold(
        appBar: const ApodSearchBar(),
        body: BlocBuilder<ApodListCubit, ApodListState>(
          builder: (context, state) {
            if (state.items.isNotEmpty) {
              return _buildList(state, context);
            } else if (state.isLoading) {
              return _buildLoading();
            } else if (state.error != null) {
              return _buildError(state.error!, context);
            } else {
              return _buildError(AssertionError(), context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(Object error, BuildContext context) {
    return AppErrorWidget(
      error,
      onRetry: () => context.read<ApodListCubit>().filter(null),
    );
  }

  Widget _buildList(ApodListState state, BuildContext context) {
    return Column(
      children: [
        if (state.dateRange != null)
          Container(
            color: Colors.purple,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${state.dateRange!.start.formatForUser()} '
                    '- ${state.dateRange!.end.formatForUser()}',
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<ApodListCubit>().filter(null);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
        Expanded(
          child: Stack(
            children: [
              ApodList(state: state),
              if (state.isLoading) const LinearProgressIndicator(),
            ],
          ),
        ),
      ],
    );
  }
}
