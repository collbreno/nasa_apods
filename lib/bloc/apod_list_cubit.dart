import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/repository/i_app_repository.dart';

part 'apod_list_state.dart';

class ApodListCubit extends Cubit<ApodListState> {
  final IAppRepository repository;
  DateTime? _currentDate;

  ApodListCubit(this.repository) : super(ApodListState.initialState());

  void loadMore() async {
    if (state.isLoading) {
      return;
    }
    print('loading more...');

    _currentDate ??= DateTime.now();
    emit(state.loading());
    try {
      final startDate = _currentDate!.subtract(const Duration(days: 15));
      final result = await repository.getApods(
        startDate: startDate,
        endDate: _currentDate!,
      );
      _currentDate = startDate;
      emit(state.addResult(result));
    } on Exception catch (e) {
      emit(state.withError(e));
    }
  }
}
