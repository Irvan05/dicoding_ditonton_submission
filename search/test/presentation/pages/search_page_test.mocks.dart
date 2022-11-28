// Mocks generated by Mockito 5.3.2 from annotations
// in search/test/presentation/pages/search_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:core/core.dart' as _i6;
import 'package:dartz/dartz.dart' as _i3;
import 'package:flutter_bloc/flutter_bloc.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:movie/movie.dart' as _i7;
import 'package:search/search.dart' as _i2;
import 'package:tv/tv.dart' as _i8;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeMovieSearchState_0 extends _i1.SmartFake
    implements _i2.MovieSearchState {
  _FakeMovieSearchState_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTvSearchState_1 extends _i1.SmartFake implements _i2.TvSearchState {
  _FakeTvSearchState_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSearchRepository_2 extends _i1.SmartFake
    implements _i2.SearchRepository {
  _FakeSearchRepository_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_3<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MovieSearchBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockMovieSearchBloc extends _i1.Mock implements _i2.MovieSearchBloc {
  MockMovieSearchBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MovieSearchState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _FakeMovieSearchState_0(
          this,
          Invocation.getter(#state),
        ),
      ) as _i2.MovieSearchState);
  @override
  _i4.Stream<_i2.MovieSearchState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i4.Stream<_i2.MovieSearchState>.empty(),
      ) as _i4.Stream<_i2.MovieSearchState>);
  @override
  bool get isClosed => (super.noSuchMethod(
        Invocation.getter(#isClosed),
        returnValue: false,
      ) as bool);
  @override
  _i5.EventTransformer<T> debounce<T>(Duration? duration) =>
      (super.noSuchMethod(
        Invocation.method(
          #debounce,
          [duration],
        ),
        returnValue: (
          _i4.Stream<T> events,
          _i5.EventMapper<T> mapper,
        ) =>
            _i4.Stream<T>.empty(),
      ) as _i5.EventTransformer<T>);
  @override
  void add(_i2.MovieSearchEvent? event) => super.noSuchMethod(
        Invocation.method(
          #add,
          [event],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onEvent(_i2.MovieSearchEvent? event) => super.noSuchMethod(
        Invocation.method(
          #onEvent,
          [event],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void emit(_i2.MovieSearchState? state) => super.noSuchMethod(
        Invocation.method(
          #emit,
          [state],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void on<E extends _i2.MovieSearchEvent>(
    _i5.EventHandler<E, _i2.MovieSearchState>? handler, {
    _i5.EventTransformer<E>? transformer,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #on,
          [handler],
          {#transformer: transformer},
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onTransition(
          _i5.Transition<_i2.MovieSearchEvent, _i2.MovieSearchState>?
              transition) =>
      super.noSuchMethod(
        Invocation.method(
          #onTransition,
          [transition],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  void onChange(_i5.Change<_i2.MovieSearchState>? change) => super.noSuchMethod(
        Invocation.method(
          #onChange,
          [change],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addError(
    Object? error, [
    StackTrace? stackTrace,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #addError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onError(
    Object? error,
    StackTrace? stackTrace,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #onError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [TvSearchBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockTvSearchBloc extends _i1.Mock implements _i2.TvSearchBloc {
  MockTvSearchBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TvSearchState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _FakeTvSearchState_1(
          this,
          Invocation.getter(#state),
        ),
      ) as _i2.TvSearchState);
  @override
  _i4.Stream<_i2.TvSearchState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i4.Stream<_i2.TvSearchState>.empty(),
      ) as _i4.Stream<_i2.TvSearchState>);
  @override
  bool get isClosed => (super.noSuchMethod(
        Invocation.getter(#isClosed),
        returnValue: false,
      ) as bool);
  @override
  _i5.EventTransformer<T> debounce<T>(Duration? duration) =>
      (super.noSuchMethod(
        Invocation.method(
          #debounce,
          [duration],
        ),
        returnValue: (
          _i4.Stream<T> events,
          _i5.EventMapper<T> mapper,
        ) =>
            _i4.Stream<T>.empty(),
      ) as _i5.EventTransformer<T>);
  @override
  void add(_i2.TvSearchEvent? event) => super.noSuchMethod(
        Invocation.method(
          #add,
          [event],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onEvent(_i2.TvSearchEvent? event) => super.noSuchMethod(
        Invocation.method(
          #onEvent,
          [event],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void emit(_i2.TvSearchState? state) => super.noSuchMethod(
        Invocation.method(
          #emit,
          [state],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void on<E extends _i2.TvSearchEvent>(
    _i5.EventHandler<E, _i2.TvSearchState>? handler, {
    _i5.EventTransformer<E>? transformer,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #on,
          [handler],
          {#transformer: transformer},
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onTransition(
          _i5.Transition<_i2.TvSearchEvent, _i2.TvSearchState>? transition) =>
      super.noSuchMethod(
        Invocation.method(
          #onTransition,
          [transition],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  void onChange(_i5.Change<_i2.TvSearchState>? change) => super.noSuchMethod(
        Invocation.method(
          #onChange,
          [change],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addError(
    Object? error, [
    StackTrace? stackTrace,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #addError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void onError(
    Object? error,
    StackTrace? stackTrace,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #onError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [SearchMovies].
///
/// See the documentation for Mockito's code generation for more information.
class MockSearchMovies extends _i1.Mock implements _i2.SearchMovies {
  MockSearchMovies() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.SearchRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeSearchRepository_2(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.SearchRepository);
  @override
  _i4.Future<_i3.Either<_i6.Failure, List<_i7.Movie>>> execute(String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [query],
        ),
        returnValue: _i4.Future<_i3.Either<_i6.Failure, List<_i7.Movie>>>.value(
            _FakeEither_3<_i6.Failure, List<_i7.Movie>>(
          this,
          Invocation.method(
            #execute,
            [query],
          ),
        )),
      ) as _i4.Future<_i3.Either<_i6.Failure, List<_i7.Movie>>>);
}

/// A class which mocks [SearchTvs].
///
/// See the documentation for Mockito's code generation for more information.
class MockSearchTvs extends _i1.Mock implements _i2.SearchTvs {
  MockSearchTvs() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.SearchRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeSearchRepository_2(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.SearchRepository);
  @override
  _i4.Future<_i3.Either<_i6.Failure, List<_i8.Tv>>> execute(String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [query],
        ),
        returnValue: _i4.Future<_i3.Either<_i6.Failure, List<_i8.Tv>>>.value(
            _FakeEither_3<_i6.Failure, List<_i8.Tv>>(
          this,
          Invocation.method(
            #execute,
            [query],
          ),
        )),
      ) as _i4.Future<_i3.Either<_i6.Failure, List<_i8.Tv>>>);
}