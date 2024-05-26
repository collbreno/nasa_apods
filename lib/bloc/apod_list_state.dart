part of 'apod_list_cubit.dart';

class ApodListState extends Equatable {
  final List<NasaApod> items;
  final String query;
  final DateTimeRange? dateRange;
  final DateTime? infiniteScrollLastDay;
  final bool isLoading;
  final Object? error;

  @visibleForTesting
  const ApodListState({
    required this.items,
    required this.isLoading,
    required this.error,
    required this.query,
    required this.dateRange,
    required this.infiniteScrollLastDay,
  });

  ApodListState.initialState()
      : items = [],
        query = '',
        isLoading = false,
        dateRange = null,
        infiniteScrollLastDay = null,
        error = null;

  ApodListState withResult(Iterable<NasaApod> result) {
    return ApodListState(
      items: result.toList(),
      isLoading: false,
      error: null,
      query: query,
      dateRange: dateRange,
      infiniteScrollLastDay: dateRange == null ? result.last.date : null,
    );
  }

  ApodListState loading(DateTimeRange? dateRange) {
    return ApodListState(
      items: items,
      isLoading: true,
      error: null,
      query: query,
      dateRange: dateRange,
      infiniteScrollLastDay: dateRange == null ? infiniteScrollLastDay : null,
    );
  }

  ApodListState withError(Object error) {
    return ApodListState(
      items: items,
      isLoading: false,
      error: error,
      query: query,
      dateRange: dateRange,
      infiniteScrollLastDay: infiniteScrollLastDay,
    );
  }

  ApodListState withQuery(String query) {
    return ApodListState(
      items: items,
      isLoading: isLoading,
      error: error,
      query: query,
      dateRange: dateRange,
      infiniteScrollLastDay: infiniteScrollLastDay,
    );
  }

  List<NasaApod> get filtered => query.isEmpty
      ? items
      : items
          .where(
              (apod) => apod.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

  bool get hasError => error != null;

  @override
  List<Object?> get props => [
        items,
        isLoading,
        error,
        query,
        dateRange,
        infiniteScrollLastDay,
      ];
}
