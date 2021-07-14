import 'package:blackbeans/screens/add_recipe.dart';
import 'package:blackbeans/screens/beansta_add_photo.dart';
import 'package:flutter/material.dart';

class AddItemSelection extends StatelessWidget {
  const AddItemSelection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [
            0.2,
            0.6,
          ],
          colors: [
            Theme.of(context).backgroundColor,
            Theme.of(context).scaffoldBackgroundColor,
          ],
        )),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            OutlineButton(
              onPressed: () => Navigator.of(context).pushNamed(
                          AddRecipeScreen.routeName),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                'Add a new recipe',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(height: 12),
            OutlineButton(
              onPressed: () => Navigator.of(context).pushNamed(
                          BeanstaAddPhotoScreen.routeName),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text('Add a new Beansta photo',
                  style: Theme.of(context).textTheme.headline5),
            ),
          ]),
        ));
  }
}
