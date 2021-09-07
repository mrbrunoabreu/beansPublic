import 'package:blackbeans/widgets/pickTags.dart';
import 'package:flutter/material.dart';

class TelaTeste extends StatefulWidget {
  const TelaTeste({ Key? key }) : super(key: key);

  static const routeName = 'telateste';

  @override
  _TelaTesteState createState() => _TelaTesteState();
}

class _TelaTesteState extends State<TelaTeste> {

  List<String> _myList = [];
  List<String> _myListCustom = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela de teste'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PickTags(
              initialTags: [],
              onTag: (tag) {},
              onDelete: (tag) {},
            ),
            //Default
            const Divider(),
            //Customised
          ],
        ),
      ));
  }
}