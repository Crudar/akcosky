import 'package:flutter/material.dart';

class MainUI extends StatelessWidget {

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
                "SUCCESSFULLY LOGGED IN"
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
