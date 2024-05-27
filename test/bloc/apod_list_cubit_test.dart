import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nasa_apod/bloc/apod_list_cubit.dart';
import 'package:nasa_apod/repository/i_app_repository.dart';

import '../fixtures/apod_list_fixture.dart';
import 'apod_list_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IAppRepository>(as: #MockRepository)])
void main() {
  DateTime march(int day) => DateTime(2024, 3, day);
  final from03to07range = DateTimeRange(start: march(3), end: march(7));
  final from22to31range = DateTimeRange(start: march(22), end: march(31));
  final from21to30range = DateTimeRange(start: march(21), end: march(30));
  final from11to30range = DateTimeRange(start: march(11), end: march(30));
  final from01to20range = DateTimeRange(start: march(1), end: march(20));
  final from11to20range = DateTimeRange(start: march(11), end: march(20));
  late DateTimeRange customRange;

  group('mocked repository', () {
    late MockRepository repository;
    late ApodListFixture fix;

    setUp(
      () async {
        repository = MockRepository();
        fix = await ApodListFixture.loadFromMarch();
        when(repository.getApods(any)).thenAnswer(
          (invocation) async => fix.fromRange(
            invocation.positionalArguments.single,
          ),
        );
      },
    );

    blocTest<ApodListCubit, ApodListState>(
      'when [loadMore()] is called, '
      'emits [loadingEmpty, results]',
      build: () => ApodListCubit(repository),
      act: (bloc) => withClock(
        Clock.fixed(march(30)),
        () async {
          await bloc.loadMore();
        },
      ),
      expect: () => [
        const ApodListState(
          items: [],
          isLoading: true,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: null,
        ),
        ApodListState(
          items: fix.fromRange(from21to30range).reversed.toList(),
          isLoading: false,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: march(21),
        ),
      ],
    );

    blocTest<ApodListCubit, ApodListState>(
      'when [loadMore(), loadMore(), loadMore()] is called '
      'emits [loadingEmpty, results, loading, results, loading, results]',
      build: () => ApodListCubit(repository),
      act: (bloc) => withClock(
        Clock.fixed(march(30)),
        () async {
          await bloc.loadMore();
          await bloc.loadMore();
          await bloc.loadMore();
        },
      ),
      expect: () => [
        const ApodListState(
          items: [],
          isLoading: true,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: null,
        ),
        ApodListState(
          items: fix.fromRange(from21to30range).reversed.toList(),
          isLoading: false,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: march(21),
        ),
        ApodListState(
          items: fix.fromRange(from21to30range).reversed.toList(),
          isLoading: true,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: march(21),
        ),
        ApodListState(
          items: fix.fromRange(from11to30range).reversed.toList(),
          isLoading: false,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: march(11),
        ),
        ApodListState(
          items: fix.fromRange(from11to30range).reversed.toList(),
          isLoading: true,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: march(11),
        ),
        ApodListState(
          items: fix
              .fromRange(DateTimeRange(start: march(1), end: march(30)))
              .reversed
              .toList(),
          isLoading: false,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: march(1),
        ),
      ],
    );

    group('using search by query', () {
      blocTest<ApodListCubit, ApodListState>(
        'when [loadMore(), search(query)] is called, '
        'emits [loadingEmpty, results, resultsWithQuery] '
        '(when filtered is empty)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            bloc.search('galaxy');
          },
        ),
        verify: (bloc) {
          expect(
            bloc.state.filtered,
            isEmpty,
          );
        },
        expect: () => [
          const ApodListState(
            items: [],
            isLoading: true,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: null,
          ),
          ApodListState(
            items: fix.fromRange(from21to30range).reversed.toList(),
            isLoading: false,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
          ApodListState(
            items: fix.fromRange(from21to30range).reversed.toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
        ],
      );

      blocTest<ApodListCubit, ApodListState>(
        'when [loadMore(), search(query)] is called, '
        'emits [loadingEmpty, results, resultsWithQuery] '
        '(when filtered is not empty)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(20)),
          () async {
            await bloc.loadMore();
            bloc.search('galaxy');
          },
        ),
        verify: (bloc) {
          expect(
            bloc.state.filtered,
            orderedEquals([
              fix.fromDate(march(20)),
              fix.fromDate(march(17)),
              fix.fromDate(march(12)),
            ]),
          );
        },
        expect: () => [
          const ApodListState(
            items: [],
            isLoading: true,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: null,
          ),
          ApodListState(
            items: fix
                .fromRange(DateTimeRange(start: march(11), end: march(20)))
                .reversed
                .toList(),
            isLoading: false,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: march(11),
          ),
          ApodListState(
            items: fix
                .fromRange(DateTimeRange(start: march(11), end: march(20)))
                .reversed
                .toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: march(11),
          ),
        ],
      );

      blocTest<ApodListCubit, ApodListState>(
        'when [loadMore(), search(query), loadMore()] is called, '
        'emits [loadingEmpty, results, resultsWithQuery, loadingWithQuery, resultsWithQuery] '
        '(new results must be added to the filtered list)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(20)),
          () async {
            await bloc.loadMore();
            bloc.search('galaxy');
            await bloc.loadMore();
          },
        ),
        verify: (bloc) {
          expect(
            bloc.state.filtered,
            orderedEquals([
              fix.fromDate(march(20)),
              fix.fromDate(march(17)),
              fix.fromDate(march(12)),
              fix.fromDate(march(6)),
            ]),
          );
        },
        skip: 3,
        expect: () => [
          ApodListState(
            items: fix
                .fromRange(DateTimeRange(start: march(11), end: march(20)))
                .reversed
                .toList(),
            isLoading: true,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: march(11),
          ),
          ApodListState(
            items: fix
                .fromRange(DateTimeRange(start: march(1), end: march(20)))
                .reversed
                .toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: march(1),
          ),
        ],
      );
    });

    group('using filter by date', () {
      blocTest(
        'when [loadMore(), filter(dates)] is called, '
        'emits [loadingEmpty, results, loadingEmptyWithDates, resultsWithDates]',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.filter(from03to07range);
          },
        ),
        skip: 2,
        expect: () => [
          ApodListState(
            items: const [],
            isLoading: true,
            error: null,
            query: '',
            dateRange: from03to07range,
            infiniteScrollLastDay: null,
          ),
          ApodListState(
            items: fix.fromRange(from03to07range).reversed.toList(),
            isLoading: false,
            error: null,
            query: '',
            dateRange: from03to07range,
            infiniteScrollLastDay: null,
          ),
        ],
      );

      blocTest(
        'when [loadMore(), filter(dates), filter(dates)] is called, '
        'emits [loadingEmpty, results, loadingEmptyWithDates, resultsWithDates, loadingEmptyWithDates, resultsWithDates]',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.filter(from03to07range);
            await bloc.filter(DateTimeRange(start: march(12), end: march(15)));
          },
        ),
        skip: 4,
        expect: () => [
          ApodListState(
            items: const [],
            isLoading: true,
            error: null,
            query: '',
            dateRange: DateTimeRange(start: march(12), end: march(15)),
            infiniteScrollLastDay: null,
          ),
          ApodListState(
            items: fix
                .fromRange(DateTimeRange(start: march(12), end: march(15)))
                .reversed
                .toList(),
            isLoading: false,
            error: null,
            query: '',
            dateRange: DateTimeRange(start: march(12), end: march(15)),
            infiniteScrollLastDay: null,
          ),
        ],
      );

      blocTest(
        'when [loadMore(), filter(dates), filter(sameDate)] is called, '
        'emits [loadingEmpty, results, loadingEmptyWithDates, resultsWithDates] '
        '(last filter() is ignored)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.filter(from03to07range);
            await bloc.filter(from03to07range);
          },
        ),
        skip: 4,
        expect: () => [],
      );

      blocTest(
        'when [loadMore(), filter(dates), loadMore()] is called, '
        'emits [loadingEmpty, results, loadingEmptyWithDates, resultsWithDates, loadingEmpty, results]',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.filter(from03to07range);
            await bloc.loadMore();
          },
        ),
        skip: 4,
        expect: () => [
          const ApodListState(
            items: [],
            isLoading: true,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: null,
          ),
          ApodListState(
            items: fix.fromRange(from21to30range).reversed.toList(),
            isLoading: false,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
        ],
      );
    });

    group('combining search by query and filter by date ', () {
      blocTest(
        'when [loadMore(), filter(dates), search(query)] is called, '
        'emits [loadingEmpty, results, loadingEmptyWithDates, resultsWithDates, resultsWithDatesWithQuery] '
        '(dates are preserved)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.filter(from03to07range);
            bloc.search('galaxy');
          },
        ),
        skip: 4,
        verify: (bloc) {
          expect(bloc.state.filtered, orderedEquals([fix.fromDate(march(6))]));
        },
        expect: () => [
          ApodListState(
            items: fix.fromRange(from03to07range).reversed.toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: from03to07range,
            infiniteScrollLastDay: null,
          ),
        ],
      );

      blocTest(
        'when [loadMore(), filter(dates), search(query)] is called, '
        'emits [loadingEmpty, results, loadingEmptyWithDates, resultsWithDates, resultsWithDatesWithQuery] '
        '(shows empty list if there are no corresponding results)',
        build: () => ApodListCubit(repository),
        setUp: () => customRange = DateTimeRange(
          start: march(1),
          end: march(5),
        ),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.filter(customRange);
            bloc.search('galaxy');
          },
        ),
        skip: 4,
        verify: (bloc) {
          expect(bloc.state.filtered, isEmpty);
        },
        expect: () => [
          ApodListState(
            items: fix.fromRange(customRange).reversed.toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: customRange,
            infiniteScrollLastDay: null,
          ),
        ],
      );

      blocTest<ApodListCubit, ApodListState>(
        'when [loadMore(), search(query), filter(dates)] is called, '
        'emits [loadingEmpty, results, resultsWithQuery, loadingEmptyWithDatesWithQuery, resultsWithDatesWithQuery] '
        '(query is preserved)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            bloc.search('galaxy');
            await bloc.filter(from03to07range);
          },
        ),
        skip: 3,
        verify: (bloc) {
          expect(
            bloc.state.filtered,
            orderedEquals([fix.fromDate(march(6))]),
          );
        },
        expect: () => [
          ApodListState(
            items: const [],
            isLoading: true,
            error: null,
            query: 'galaxy',
            dateRange: from03to07range,
            infiniteScrollLastDay: null,
          ),
          ApodListState(
            items: fix.fromRange(from03to07range).reversed.toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: from03to07range,
            infiniteScrollLastDay: null,
          ),
        ],
      );

      blocTest<ApodListCubit, ApodListState>(
        'when [loadMore(), search(query), filter(dates)] is called, '
        'emits [loadingEmpty, results, resultsWithQuery, loadingEmptyWithDatesWithQuery, resultsWithDatesWithQuery] '
        '(shows empty list if there are no corresponding results)',
        build: () => ApodListCubit(repository),
        setUp: () => customRange = DateTimeRange(
          start: march(1),
          end: march(5),
        ),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            bloc.search('galaxy');
            await bloc.filter(customRange);
          },
        ),
        skip: 3,
        verify: (bloc) {
          expect(
            bloc.state.filtered,
            isEmpty,
          );
        },
        expect: () => [
          ApodListState(
            items: const [],
            isLoading: true,
            error: null,
            query: 'galaxy',
            dateRange: customRange,
            infiniteScrollLastDay: null,
          ),
          ApodListState(
            items: fix.fromRange(customRange).reversed.toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: customRange,
            infiniteScrollLastDay: null,
          ),
        ],
      );

      blocTest(
        'when [loadMore(), filter(dates), search(query), loadMore()] is called, '
        'emits [loadingEmpty, results, loadingEmptyWithDates, resultsWithDates, resultsWithDatesWithQuery, loadingEmptyWithQuery, resultsWithQuery] '
        '(query is preserved)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.filter(from03to07range);
            bloc.search('galaxy');
            await bloc.loadMore();
          },
        ),
        skip: 5,
        verify: (bloc) {
          expect(bloc.state.filtered, isEmpty);
        },
        expect: () => [
          const ApodListState(
            items: [],
            isLoading: true,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: null,
          ),
          ApodListState(
            items: fix.fromRange(from21to30range).reversed.toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
        ],
      );
    });

    group('refreshing', () {
      blocTest<ApodListCubit, ApodListState>(
        'when [loadMore(), refresh()] is called, '
        'emits [loadingEmpty, results, loading, results]',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.refresh();
          },
        ),
        skip: 2,
        expect: () => [
          ApodListState(
            items: fix.fromRange(from21to30range).reversed.toList(),
            isLoading: true,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
          ApodListState(
            items: fix.fromRange(from21to30range).reversed.toList(),
            isLoading: false,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
        ],
      );

      blocTest<ApodListCubit, ApodListState>(
        'when [loadMore(), loadMore(), refresh()] is called '
        'emits [loadingEmpty, results, loading, results, loading, results] '
        '(shows only first 10 results)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.loadMore();
            await bloc.refresh();
          },
        ),
        skip: 4,
        expect: () => [
          ApodListState(
            items: fix.fromRange(from11to30range).reversed.toList(),
            isLoading: true,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: march(11),
          ),
          ApodListState(
            items: fix.fromRange(from21to30range).reversed.toList(),
            isLoading: false,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
        ],
      );

      blocTest<ApodListCubit, ApodListState>(
        'when [loadMore(), search(query), refresh()] is called, '
        'emits [loadingEmpty, results, resultsWithQuery, loadingWithQuery, resultsWithQuery] '
        '(query is preserved)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            bloc.search('galaxy');
            await bloc.refresh();
          },
        ),
        verify: (bloc) {
          expect(
            bloc.state.filtered,
            isEmpty,
          );
        },
        skip: 3,
        expect: () => [
          ApodListState(
            items: fix.fromRange(from21to30range).reversed.toList(),
            isLoading: true,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
          ApodListState(
            items: fix.fromRange(from21to30range).reversed.toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
        ],
      );

      blocTest<ApodListCubit, ApodListState>(
        'when [loadMore(), loadMore(), search(query), refresh()] is called, '
        'emits [loadingEmpty, results, resultsWithQuery, loadingWithQuery, resultsWithQuery] '
        '(only query is preserved)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(20)),
          () async {
            await bloc.loadMore();
            await bloc.loadMore();
            bloc.search('galaxy');
            await bloc.refresh();
          },
        ),
        verify: (bloc) {
          expect(
            bloc.state.filtered,
            orderedEquals([
              fix.fromDate(march(20)),
              fix.fromDate(march(17)),
              fix.fromDate(march(12)),
            ]),
          );
        },
        skip: 5,
        expect: () => [
          ApodListState(
            items: fix.fromRange(from01to20range).reversed.toList(),
            isLoading: true,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: march(1),
          ),
          ApodListState(
            items: fix.fromRange(from11to20range).reversed.toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: march(11),
          ),
        ],
      );

      blocTest(
        'when [loadMore(), filter(dates), refresh()] is called, '
        'emits [loadingEmpty, results, loadingEmptyWithDates, resultsWithDates, loadingWithDates, resultsWithDates] '
        '(dates are preserved)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.filter(from03to07range);
            await bloc.refresh();
          },
        ),
        skip: 4,
        expect: () => [
          ApodListState(
            items: fix.fromRange(from03to07range).reversed.toList(),
            isLoading: true,
            error: null,
            query: '',
            dateRange: from03to07range,
            infiniteScrollLastDay: null,
          ),
          ApodListState(
            items: fix.fromRange(from03to07range).reversed.toList(),
            isLoading: false,
            error: null,
            query: '',
            dateRange: from03to07range,
            infiniteScrollLastDay: null,
          ),
        ],
      );

      blocTest(
        'when [loadMore(), filter(dates), search(query), refresh()] is called, '
        'emits [loadingEmpty, results, loadingEmptyWithDates, resultsWithDates, resultsWithDatesWithQuery, loadingWithDatesWithQuery, resultsWithDatesWithQuery] '
        '(dates and query are preserved)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.loadMore();
            await bloc.filter(from03to07range);
            bloc.search('galaxy');
            await bloc.refresh();
          },
        ),
        skip: 5,
        verify: (bloc) {
          expect(bloc.state.filtered, orderedEquals([fix.fromDate(march(6))]));
        },
        expect: () => [
          ApodListState(
            items: fix.fromRange(from03to07range).reversed.toList(),
            isLoading: true,
            error: null,
            query: 'galaxy',
            dateRange: from03to07range,
            infiniteScrollLastDay: null,
          ),
          ApodListState(
            items: fix.fromRange(from03to07range).reversed.toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: from03to07range,
            infiniteScrollLastDay: null,
          ),
        ],
      );

      blocTest<ApodListCubit, ApodListState>(
        'when [loadMore(), refresh()] is called, '
        'emits [loadingEmpty, results, loading, results] '
        '(shows new days if date has changed)',
        build: () => ApodListCubit(repository),
        act: (bloc) => withClock(
          Clock.fixed(march(30)),
          () async {
            await bloc.refresh();
            withClock(
              Clock.fixed(march(31)),
              () async {
                await bloc.refresh();
              },
            );
          },
        ),
        skip: 2,
        expect: () => [
          ApodListState(
            items: fix.fromRange(from21to30range).reversed.toList(),
            isLoading: true,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
          ApodListState(
            items: fix.fromRange(from22to31range).reversed.toList(),
            isLoading: false,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: march(22),
          ),
        ],
      );
    });
  });
}
