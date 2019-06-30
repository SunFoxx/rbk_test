import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rbk_test/model/gif.dart';

import './gif_event.dart';
import './gif_state.dart';
import '../network/giphy_api.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  final API api;

  GifBloc({@required this.api});

  @override
  GifState get initialState => GifUninitialized();

  @override
  Stream<GifState> mapEventToState(GifEvent event) async* {
    if (event is Fetch) {
      try {
        if (currentState is GifUninitialized) {
          final gifs = await api.get(query: event.query, offset: 0);
          yield GifLoaded(gifs: gifs);
          return;
        }

        if (currentState is GifLoaded) {
          final gifs = await api.get(
              query: event.query, offset: (currentState as GifLoaded).gifs.length);
          yield GifLoaded(gifs: (currentState as GifLoaded).gifs + gifs);
        }
      } catch (e) {
        yield GifError();
      }
    }

    if (event is Clear) {
      yield event.isCompleteClear ? GifUninitialized() : GifLoaded(gifs: []);
    }

    if (event is Fav) {
      if (currentState is GifLoaded) {
        final Gif refGif = (currentState as GifLoaded).gifs[event.index];
        Gif newGif = Gif(url: refGif.url, id: refGif.id);
        newGif.isFavourite = !refGif.isFavourite;

        List<Gif> newList = List.from((currentState as GifLoaded).gifs);
        newList.replaceRange(event.index, event.index + 1, [newGif]);

        yield GifLoaded(gifs: newList);
      }
    }
  }
}
