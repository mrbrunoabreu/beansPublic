import 'dart:ui';

import 'package:blackbeans/models/recipe.dart';
import 'package:blackbeans/screens/edit_recipe.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class RecipeDetail extends StatefulWidget {
  static const routeName = 'recipe-detail';

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  bool expandRecipeContainer = false;
  int recipeMaxLines = 4;
  double recipeBoxHeight = 60;

  String curryRecipe =
      'This has been the go-to dish I order at my local Indian restaurant so I finally just decided to recreate it at home and I couldnt be happier with the end result! I love that it has an abundance of spices leaving it with incredible flavor. I also love that little bit of cream thats added at the end, even though its not much it works wonders. And of course its got an abundance of sauce because thats what chicken curry is all about – that irresistible sauce for soaking up with naan bread or serving alongside rice.';

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = ModalRoute.of(context).settings.arguments as Recipe;
    final deviceWidth = MediaQuery.of(context).size.width;
    final halfDeviceHeight = MediaQuery.of(context).size.height / 2;
    double containerHeight = halfDeviceHeight / 2;

    return Scaffold(
        // extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0.0,
        //   leading: IconButton(
        //         icon: const Icon(
        //           Ionicons.arrow_back_circle,
        //           color: Colors.white70,
        //           size: 32,
        //         ),
        //         onPressed: Navigator.of(context).pop,
        //       ),
        // ),
        body: Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: halfDeviceHeight,
          child: Image.network(recipe.mealImage, fit: BoxFit.cover),
        ),
        StunningBraveBar(recipe: recipe),
        DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.6,
          maxChildSize: 0.8,
          builder: (context, scrollcontroller) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(12),
              child: SingleChildScrollView(
                controller: scrollcontroller,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.drag_handle),
                      SizedBox(height: 6),
                      Text(recipe.mealTitle,
                          style: Theme.of(context).textTheme.headline2),
                      Text(recipe.mealDescription,
                          style: Theme.of(context).textTheme.subtitle2),
                      SizedBox(height: 12),
                      if (recipe.recipeTags != null)
                        Row(
                          children: recipe.recipeTags
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Material(
                                      color: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('$e',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                      color: Colors.black))),
                                    ),
                                  ))
                              .toList(),
                        ),
                      SizedBox(height: 12),
                      Divider(thickness: 1),
                      SizedBox(height: 12),
                      Text(recipe.mealInstructions,
                          style: Theme.of(context).textTheme.subtitle1),
                    ]),
              )),
        )

        // Container(
        //   padding: EdgeInsets.all(12),
        //   height: halfDeviceHeight,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(recipe.mealTitle, style: Theme.of(context).textTheme.headline2),
        //       SizedBox(height: 12),
        //       Expanded(
        //         child: Text(recipe.mealInstructions, style: Theme.of(context).textTheme.bodyText1),)
        //     ]
        //   ),
        //   )
      ],
    )

        // Stack(
        //   children: [
        //     Container(
        //       width: deviceWidth,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(12.0),
        //           image: DecorationImage(
        //               fit: BoxFit.cover, image: NetworkImage(recipe.mealImage))),
        //     ),
        //     Container(
        //       width: deviceWidth,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(12.0),
        //           gradient: LinearGradient(
        //               begin: FractionalOffset.center,
        //               end: FractionalOffset.bottomCenter,
        //               colors: [
        //                 Colors.grey[700].withOpacity(0.0),
        //                 Colors.black,
        //               ],
        //               stops: [
        //                 0.0,
        //                 1.0
        //               ])),
        //     ),
        //     Center(
        //       child: Padding(
        //         padding: EdgeInsets.only(bottom: 70),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: [
        //             AnimatedContainer(
        //               duration: Duration(milliseconds: 500),
        //               curve: Curves.fastOutSlowIn,
        //               width: deviceWidth * 0.9,
        //               height:
        //                   expandRecipeContainer ? halfDeviceHeight * 1.5 : 260,
        //               child: Card(
        //                 shadowColor: Colors.black,
        //                 color: Colors.black38,
        //                 shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(20)),
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(20.0),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.spaceBetween,
        //                                 children: [
        //                                   Text(recipe.mealTitle,
        //                                       style: Theme.of(context)
        //                                           .textTheme
        //                                           .headline5
        //                                           .copyWith(
        //                                               color: Colors.white,
        //                                               fontSize: 16)),
        //                                   Icon(Icons.favorite_border,
        //                                       color: Colors.white, size: 20),
        //                                 ]),
        //                             Text(recipe.mealDescription,
        //                                 style: Theme.of(context)
        //                                     .textTheme
        //                                     .subtitle2
        //                                     .copyWith(color: Colors.white)),
        //                             Chip(
        //                                 label: Text(
        //                                   'Spicy',
        //                                   style: Theme.of(context)
        //                                       .textTheme
        //                                       .bodyText1
        //                                       .copyWith(color: Colors.white),
        //                                 ),
        //                                 backgroundColor:
        //                                     Colors.blueGrey[900].withOpacity(0.9),
        //                                 shape: RoundedRectangleBorder(
        //                                     borderRadius: BorderRadius.all(
        //                                         Radius.circular(4)))),
        //                             SizedBox(
        //                               height: expandRecipeContainer
        //                                   ? halfDeviceHeight
        //                                   : 60,
        //                               child: Text(curryRecipe,
        //                                       softWrap: true,
        //                                       maxLines:
        //                                           expandRecipeContainer ? 18 : 4,
        //                                       overflow: TextOverflow.ellipsis,
        //                                       style: Theme.of(context)
        //                                           .textTheme
        //                                           .bodyText1
        //                                           .copyWith(color: Colors.white)),
        //                               ),
        //                           ]),
        //                       FlatButton(
        //                           color: Colors.white,
        //                           onPressed: () {
        //                             setState(() {
        //                               expandRecipeContainer =
        //                                   !expandRecipeContainer;
        //                             });
        //                           },
        //                           child: Text(expandRecipeContainer
        //                               ? 'Shrink'
        //                               : 'Expand'))
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        );
  }

  void buildMaterialTags(List<dynamic> recipe) {
    recipe
        .map((e) => Material(
              color: Colors.blueGrey[700],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: const EdgeInsets.all(8.0), child: Text('${e[1]}')),
            ))
        .toList();
  }
}

class StunningBraveBar extends StatelessWidget {
  final Icon leadingIcon;
  final String centerTitle;
  final Icon trailingIcon;
  final Color backgroundColor;
  final Recipe recipe;

  const StunningBraveBar({
    this.leadingIcon,
    this.centerTitle,
    this.trailingIcon,
    this.backgroundColor,
    this.recipe,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.white60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                  size: 22,
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ),
            Material(
              color: Colors.white60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            EditRecipeScreen(recipe: recipe)));
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAppBar({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: preferredSize.height,
        child: child,
      ),
    );
  }
}