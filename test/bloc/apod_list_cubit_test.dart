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
      'simple call',
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
          items: fix
              .fromRange(DateTimeRange(start: march(21), end: march(30)))
              .reversed
              .toList(),
          isLoading: false,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: march(21),
        ),
      ],
    );

    blocTest<ApodListCubit, ApodListState>(
      'three loadings',
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
          items: fix
              .fromRange(DateTimeRange(start: march(21), end: march(30)))
              .reversed
              .toList(),
          isLoading: false,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: march(21),
        ),
        ApodListState(
          items: fix
              .fromRange(DateTimeRange(start: march(21), end: march(30)))
              .reversed
              .toList(),
          isLoading: true,
          error: null,
          query: '',
          dateRange: null,
          infiniteScrollLastDay: march(21),
        ),
        ApodListState(
          items: fix
              .fromRange(DateTimeRange(start: march(11), end: march(30)))
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
              .fromRange(DateTimeRange(start: march(11), end: march(30)))
              .reversed
              .toList(),
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
        "when user searches for 'galaxy' while the current list doesn't "
        "have any 'galaxy', so the result must be an empty list",
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
            items: fix
                .fromRange(DateTimeRange(start: march(21), end: march(30)))
                .reversed
                .toList(),
            isLoading: false,
            error: null,
            query: '',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
          ApodListState(
            items: fix
                .fromRange(DateTimeRange(start: march(21), end: march(30)))
                .reversed
                .toList(),
            isLoading: false,
            error: null,
            query: 'galaxy',
            dateRange: null,
            infiniteScrollLastDay: march(21),
          ),
        ],
      );

      blocTest<ApodListCubit, ApodListState>(
        "when user searches for 'galaxy' while the current list has "
        "galaxies, the result must contain only galaxies",
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
        "when user searches for 'galaxy' and loads more, the new "
        "found galaxies must be added to the result",
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
  });
}
