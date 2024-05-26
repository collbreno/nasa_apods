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
      },
    );

    blocTest(
      'simple call',
      build: () => ApodListCubit(repository),
      setUp: () {
        when(repository.getApods(any)).thenAnswer(
          (invocation) async => fix.fromRange(
            invocation.positionalArguments.single,
          ),
        );
      },
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

    blocTest(
      'three loadings',
      build: () => ApodListCubit(repository),
      setUp: () {
        when(repository.getApods(any)).thenAnswer(
          (invocation) async => fix.fromRange(
            invocation.positionalArguments.single,
          ),
        );
      },
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
  });
}
