import 'package:flutter/material.dart';
class LoadingBottom extends StatelessWidget {
  final bool isLoading;

  const LoadingBottom({Key key, this.isLoading}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _createLoading();
  }

  _createLoading(){
    if(isLoading){
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator()
            ],),
            SizedBox(height:15.0)
          ],
      );
     
    }
    return Container();
  }
}