abstract class GifEvent {}

class Fetch extends GifEvent {
  final String query;
  final int offset;

  Fetch({ this.query, this.offset });

  @override
  String toString() => 'Fetch action';
}

class Clear extends GifEvent {
  bool isCompleteClear = false;

  Clear(this.isCompleteClear);

  @override
  String toString() => 'Clear action';
}

class Fav extends GifEvent {
  int index;

  Fav(this.index);

  @override
  String toString() => 'Fav action';
}
