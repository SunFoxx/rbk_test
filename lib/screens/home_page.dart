import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rbk_test/bloc/block.dart';
import 'package:rbk_test/model/gif.dart';
import 'package:rbk_test/network/giphy_api.dart';
import 'package:rbk_test/widgets/gif_image.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  String _query = '';
  Timer _inputDebounce;
  GifBloc _gifBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _gifBloc = GifBloc(api: API());
  }

  Widget _buildListItem(int index, List<Gif> gifs) {
    return Center(
        child: GifImage(
            gif: gifs[index], onFavPress: () => _gifBloc.dispatch(Fav(index))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        builder: (BuildContext context) => _gifBloc,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              BlocBuilder(
                bloc: _gifBloc,
                builder: (BuildContext context, GifState state) {
                  if (state is GifUninitialized) {
                    return Center(
                      child: Text(
                        'Nothing to dispaly... Please, try to input something to the search bar',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (state is GifError) {
                    return Center(
                      child: Text('Oops... something went wrong'),
                    );
                  }

                  if (state is GifLoaded) {
                    if (state.gifs.isEmpty) {
                      return Center(
                        child: Text('No results found'),
                      );
                    }

                    return GridView.count(
                      controller: _scrollController,
                      crossAxisCount: 2,
                      padding: EdgeInsets.only(top: 50),
                      children: List.generate(state.gifs.length,
                          (index) => _buildListItem(index, state.gifs)),
                    );
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: _onSearchChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    if (_inputDebounce?.isActive ?? false) _inputDebounce.cancel();
    bool _isEmpty = text.length == 0;
    _query = text;

    _gifBloc.dispatch(Clear(_isEmpty));

    if (!_isEmpty) {
      _inputDebounce = Timer(const Duration(milliseconds: 500), () {
        _gifBloc.dispatch(Fetch(query: text));
      });
    }
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _gifBloc.dispatch(Fetch(query: _query));
    }
  }
}
