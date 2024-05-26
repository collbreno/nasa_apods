import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/repository/i_app_repository.dart';

part 'apod_list_state.dart';

class ApodListCubit extends Cubit<ApodListState> {
  final IAppRepository repository;

  ApodListCubit(this.repository) : super(ApodListState.initialState());

  Future<void> loadMore() async {
    if (state.isLoading) {
      return;
    }

    final loadingState = state.dateRange == null
        ? state.loading(null)
        : ApodListState.initialState().withQuery(state.query).loading(null);
    emit(loadingState);

    try {
      final endDate = state.infiniteScrollLastDay == null
          ? clock.now()
          : state.infiniteScrollLastDay!.subtract(const Duration(days: 1));
      final startDate = endDate.subtract(const Duration(days: 9));
      final result = await repository.getApods(
        DateTimeRange(start: startDate, end: endDate),
      );
      emit(state.addResult(result.reversed));
    } on Exception catch (e) {
      emit(state.withError(e));
    }
  }

  void search(String query) {
    emit(state.withQuery(query));
  }

  Future<void> filter(DateTimeRange dateRange) async {
    if (dateRange == state.dateRange) {
      return;
    }

    emit(
      ApodListState.initialState().withQuery(state.query).loading(dateRange),
    );
    try {
      final result = await repository.getApods(dateRange);
      emit(state.addResult(result.reversed));
    } on Exception catch (e) {
      emit(state.withError(e));
    }
  }
}
