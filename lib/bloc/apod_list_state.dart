part of 'apod_list_cubit.dart';

class ApodListState<T> extends Equatable {
  final List<NasaApod> items;
  final bool isLoading;
  final Object? error;

  const ApodListState._({
    required this.items,
    required this.isLoading,
    required this.error,
  });

  ApodListState.initialState()
      : items = [],
        isLoading = false,
        error = null;

  ApodListState<T> addResult(List<NasaApod> result) {
    return ApodListState._(
      items: items + result,
      isLoading: false,
      error: null,
    );
  }

  ApodListState<T> loading() {
    return ApodListState._(
      items: items,
      isLoading: true,
      error: null,
    );
  }

  ApodListState<T> withError(Object error) {
    return ApodListState._(
      items: items,
      isLoading: false,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, error];
}
