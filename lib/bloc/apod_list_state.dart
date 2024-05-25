part of 'apod_list_cubit.dart';

class ApodListState extends Equatable {
  final List<NasaApod> items;
  final String query;
  final DateTimeRange? dateRange;
  final bool isLoading;
  final Object? error;

  const ApodListState._({
    required this.items,
    required this.isLoading,
    required this.error,
    required this.query,
    required this.dateRange,
  });

  ApodListState.initialState()
      : items = [],
        query = '',
        isLoading = false,
        dateRange = null,
        error = null;

  ApodListState addResult(List<NasaApod> result) {
    return ApodListState._(
      items: items + result,
      isLoading: false,
      error: null,
      query: query,
      dateRange: dateRange,
    );
  }

  ApodListState loading(DateTimeRange? dateRange) {
    return ApodListState._(
      items: items,
      isLoading: true,
      error: null,
      query: query,
      dateRange: dateRange,
    );
  }

  ApodListState withError(Object error) {
    return ApodListState._(
      items: items,
      isLoading: false,
      error: error,
      query: query,
      dateRange: dateRange,
    );
  }

  ApodListState withQuery(String query) {
    return ApodListState._(
      items: items,
      isLoading: false,
      error: error,
      query: query,
      dateRange: dateRange,
    );
  }

  List<NasaApod> get filtered => query.isEmpty
      ? items
      : items
          .where(
              (apod) => apod.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

  @override
  List<Object?> get props => [items, isLoading, error, query, dateRange];
}
