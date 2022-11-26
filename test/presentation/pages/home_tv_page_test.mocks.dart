// Mocks generated by Mockito 5.3.0 from annotations
// in ditonton/test/presentation/pages/home_tv_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;
import 'dart:ui' as _i9;

import 'package:ditonton/common/state_enum.dart' as _i7;
import 'package:ditonton/domain/entities/tv.dart' as _i6;
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart' as _i2;
import 'package:ditonton/domain/usecases/get_popular_tvs.dart' as _i3;
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart' as _i4;
import 'package:ditonton/presentation/provider/tv_list_notifier.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

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

class _FakeGetOnTheAirTvs_0 extends _i1.SmartFake
    implements _i2.GetOnTheAirTvs {
  _FakeGetOnTheAirTvs_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetPopularTvs_1 extends _i1.SmartFake implements _i3.GetPopularTvs {
  _FakeGetPopularTvs_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetTopRatedTvs_2 extends _i1.SmartFake
    implements _i4.GetTopRatedTvs {
  _FakeGetTopRatedTvs_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [TvListNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockTvListNotifier extends _i1.Mock implements _i5.TvListNotifier {
  MockTvListNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetOnTheAirTvs get getOnTheAirTvs => (super.noSuchMethod(
          Invocation.getter(#getOnTheAirTvs),
          returnValue:
              _FakeGetOnTheAirTvs_0(this, Invocation.getter(#getOnTheAirTvs)))
      as _i2.GetOnTheAirTvs);
  @override
  _i3.GetPopularTvs get getPopularTvs =>
      (super.noSuchMethod(Invocation.getter(#getPopularTvs),
              returnValue:
                  _FakeGetPopularTvs_1(this, Invocation.getter(#getPopularTvs)))
          as _i3.GetPopularTvs);
  @override
  _i4.GetTopRatedTvs get getTopRatedTvs => (super.noSuchMethod(
          Invocation.getter(#getTopRatedTvs),
          returnValue:
              _FakeGetTopRatedTvs_2(this, Invocation.getter(#getTopRatedTvs)))
      as _i4.GetTopRatedTvs);
  @override
  List<_i6.Tv> get onTheAirTvs =>
      (super.noSuchMethod(Invocation.getter(#onTheAirTvs),
          returnValue: <_i6.Tv>[]) as List<_i6.Tv>);
  @override
  _i7.RequestState get onTheAirState =>
      (super.noSuchMethod(Invocation.getter(#onTheAirState),
          returnValue: _i7.RequestState.Empty) as _i7.RequestState);
  @override
  List<_i6.Tv> get popularTvs => (super
          .noSuchMethod(Invocation.getter(#popularTvs), returnValue: <_i6.Tv>[])
      as List<_i6.Tv>);
  @override
  _i7.RequestState get popularTvsState =>
      (super.noSuchMethod(Invocation.getter(#popularTvsState),
          returnValue: _i7.RequestState.Empty) as _i7.RequestState);
  @override
  List<_i6.Tv> get topRatedTvs =>
      (super.noSuchMethod(Invocation.getter(#topRatedTvs),
          returnValue: <_i6.Tv>[]) as List<_i6.Tv>);
  @override
  _i7.RequestState get topRatedTvsState =>
      (super.noSuchMethod(Invocation.getter(#topRatedTvsState),
          returnValue: _i7.RequestState.Empty) as _i7.RequestState);
  @override
  String get message =>
      (super.noSuchMethod(Invocation.getter(#message), returnValue: '')
          as String);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i8.Future<void> fetchOnTheAirTvs() => (super.noSuchMethod(
      Invocation.method(#fetchOnTheAirTvs, []),
      returnValue: _i8.Future<void>.value(),
      returnValueForMissingStub: _i8.Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> fetchPopularTvs() => (super.noSuchMethod(
      Invocation.method(#fetchPopularTvs, []),
      returnValue: _i8.Future<void>.value(),
      returnValueForMissingStub: _i8.Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> fetchTopRatedTvs() => (super.noSuchMethod(
      Invocation.method(#fetchTopRatedTvs, []),
      returnValue: _i8.Future<void>.value(),
      returnValueForMissingStub: _i8.Future<void>.value()) as _i8.Future<void>);
  @override
  void addListener(_i9.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i9.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}
