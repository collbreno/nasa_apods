import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_apod/bloc/apod_list_cubit.dart';
import 'package:nasa_apod/repository/i_app_repository.dart';
import 'package:nasa_apod/widgets/apod_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ApodListCubit(context.read<IAppRepository>())..loadMore(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Apods'),
        ),
        body: BlocBuilder<ApodListCubit, ApodListState>(
          builder: (context, state) {
            if (state.items.isNotEmpty) {
              return _buildList(state);
            } else if (state.isLoading) {
              return _buildLoading();
            } else if (state.error != null) {
              return _buildError(state.error!);
            } else {
              return _buildError(AssertionError());
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(Object error) {
    return const Center(child: Text('Something got wrong'));
  }

  Widget _buildList(ApodListState state) {
    return ApodList(state: state);
  }
}
