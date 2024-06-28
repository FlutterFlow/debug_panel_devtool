import 'package:flutter/material.dart';

extension GenericMapExtension<K, V> on Map<K, V> {
  Map<V, K> get reversed => entries.map((e) => MapEntry(e.value, e.key)).mapify;
}

extension MapEntryIterable<K, V> on Iterable<MapEntry<K, V>> {
  Future<List<S>> futureMap<S>(Future<S> Function(K k, V v) fn) =>
      Future.wait(entryMap(fn));
  Iterable<V> get values => map((e) => e.value);
  Iterable<K> get keys => map((e) => e.key);
  Map<K, V> get mapify => Map.fromEntries(this);
  Iterable<T> entryMap<T>(T Function(K k, V v) fn) =>
      map((e) => fn(e.key, e.value));
}

extension Flatten<T> on Iterable<Iterable<T>> {
  Iterable<T> get flatten => expand((i) => i);
}

extension IterableExtension<T> on Iterable<T> {
  /// Maps each element and its index to a new value.
  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert) sync* {
    var index = 0;
    for (var element in this) {
      yield convert(index++, element);
    }
  }

  List<S> listMap<S>(S Function(T t) fn) => map(fn).toList();

  List<T> divide(T t) => isEmpty
      ? []
      : (enumerate.map((e) => [e.value, t]).flatten.toList()..removeLast());

  Iterable<MapEntry<int, T>> get enumerate => toList().asMap().entries;
}

extension DurationInt on int {
  Duration get hours => Duration(hours: this);
  Duration get minutes => Duration(minutes: this);
  Duration get seconds => Duration(seconds: this);
  Duration get millis => Duration(milliseconds: this);
  Duration get days => Duration(days: this);
  Iterable<int> get times => Iterable.generate(this, identity);
}

T identity<T>(T t) => t;

void showSnackbar(
  BuildContext context,
  String message, {
  bool loading = false,
  int duration = 4,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (loading)
            const Padding(
              padding: EdgeInsetsDirectional.only(end: 10.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          Text(message),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
}

extension ColorHelper on Color {
  Color ifBright(Color brightColor, {required Color otherwise}) {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.light
        ? brightColor
        : otherwise;
  }

  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(
        alpha, (red * f).round(), (green * f).round(), (blue * f).round());
  }

  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}
