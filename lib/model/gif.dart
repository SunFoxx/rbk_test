class Gif {
  final String url;
  final String id;
  bool isFavourite = false;

  Gif({ this.url, this.id });

  Gif.fromJson(Map json)
      : url = json['url'],
      id = json['id'];

  @override
  String toString() {
    return '$id: $url';
  }
}
