import 'package:flutter/material.dart';
import 'package:rbk_test/model/gif.dart';

class GifImage extends StatelessWidget {
  final Gif gif;
  final Function onFavPress;

  GifImage({ this.gif, this.onFavPress });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Padding(
        padding: EdgeInsets.all(1),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topLeft,
          children: <Widget>[
            FadeInImage.assetNetwork(
              image: gif.url,
              fit: BoxFit.fill,
              alignment: Alignment.topLeft,
              placeholder: 'assets/loading.gif',
            ),
            IconButton(
              icon: Icon(Icons.star),
              alignment: Alignment.topLeft,
              iconSize: 48,
              highlightColor: Colors.amber,
              splashColor: Colors.amber,
              color: gif.isFavourite ? Colors.amber : Colors.white,
              onPressed: onFavPress,
            ),
          ],
        ),
      ),
    );
  }
}
