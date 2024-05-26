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
            return Column(
              children: [
                if (state.dateRange != null)
                  _buildDateRangeHeader(state.dateRange!),
                Expanded(child: _buildContent(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateRangeHeader(DateTimeRange dateRange) {
    return Container(
      color: Colors.purple,
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${dateRange.start.formatForUser()} '
              '- ${dateRange.end.formatForUser()}',
              textAlign: TextAlign.center,
            ),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                context.read<ApodListCubit>().loadMore();
              },
              icon: const Icon(Icons.close),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent(ApodListState state) {
    if (state.items.isNotEmpty) {
      return ApodList(state: state);
    } else if (state.isLoading) {
      return _buildLoading();
    } else if (state.error != null) {
      return _buildError(state.error!);
    } else {
      return _buildError(AssertionError());
    }
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(Object error) {
    return Builder(builder: (context) {
      return AppErrorWidget(
        error,
        onRetry: () => context.read<ApodListCubit>().refresh(),
      );
    });
  }
}
