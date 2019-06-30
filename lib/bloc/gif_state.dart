import 'package:rbk_test/model/gif.dart';

abstract class GifState {
  GifState([List props = const []]);
}

class GifUninitialized extends GifState {
  @override
  String toString() => 'GifUninitialized';
}

class GifError extends GifState {
  @override
  String toString() => 'GifError';
}

class GifLoaded extends GifState {
  final List<Gif> gifs;

  GifLoaded({
    this.gifs,
  }) : super([gifs]);

  @override
  String toString() =>
      'GifsLoaded { gifs: ${gifs.length}}';
}