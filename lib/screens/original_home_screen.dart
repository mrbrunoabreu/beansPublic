import 'package:blackbeans/bloc/recipes_repository.dart';
import 'package:blackbeans/screens/recipe_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'recipes-home';

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width * 0.95;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).backgroundColor,
              padding: const EdgeInsets.fromLTRB(20, 55, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    type: MaterialType.card,
                    elevation: 8,
                    shadowColor: Colors.black,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black),
                          hintText: 'Search recipes',
                          hintStyle: Theme.of(context).textTheme.bodyText1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                          color: Colors.amber,
                          disabledColor: Colors.red,
                          onPressed: () => Provider.of<RecipesRepository>(context, listen: false).setFetchRecipes(),
                          child: Text('Lunch'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      SizedBox(width: 10),
                      FlatButton(
                          color: Colors.amber,
                          disabledColor: Colors.red,
                          onPressed: () {},
                          child: Text('Dinner'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      SizedBox(width: 10),
                      FlatButton(
                          color: Colors.amber,
                          disabledColor: Colors.red,
                          onPressed: () {},
                          child: Text('Plans'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      SizedBox(width: 10),
                      FlatButton(
                          color: Colors.amber,
                          disabledColor: Colors.red,
                          onPressed: () {},
                          child: Text('Faves'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ],
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, top: 15),
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              left: BorderSide(color: Colors.amber, width: 2))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('SUGGESTIONS FOR TODAY',
                            style: Theme.of(context).textTheme.headline2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Column(children: [
                  Container(
                      height: 80, color: Theme.of(context).backgroundColor),
                  Container(
                      height: 80,
                      color: Theme.of(context).scaffoldBackgroundColor)
                ]),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: 250,
                    height: 130,
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.black,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 15),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.indigo,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/roasted_lamb.jpeg'))),
                            height: 80,
                            width: 80,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Receita nome grande pakas',
                                    softWrap: true,
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Divider(
                                    height: 10,
                                    thickness: 1,
                                    color: Colors.amber,
                                    endIndent: 50),
                                Text('Descricao',
                                    style:
                                        Theme.of(context).textTheme.subtitle2)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.only(left: 18, top: 8),
                child: Text('September 7',
                    style: Theme.of(context).textTheme.headline4),
              ),
              SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.only(left: 18, bottom: 8),
                child:
                    Text('TODAY', style: Theme.of(context).textTheme.headline1),
              ),
            ]),
            Card(
                margin: EdgeInsets.only(left: 8, top: 12, right: 8),
                elevation: 10,
                shadowColor: Colors.black,
                // color: Colors.brown[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(RecipeDetail.routeName),
                  child: Stack(
                    children: [
                      Container(
                        height: 300,
                        width: deviceWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/kiyama.jpg'))),
                      ),
                      Container(
                        height: 300,
                        width: deviceWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            gradient: LinearGradient(
                                begin: FractionalOffset.center,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Colors.grey[700].withOpacity(0.0),
                                  Colors.black87,
                                ],
                                stops: [
                                  0.0,
                                  1.0
                                ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 200),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 120,
                                child: Text('UNI & EGG BOWL',
                                    softWrap: true,
                                    style:
                                        Theme.of(context).textTheme.headline3),
                              ),
                            ),
                            Container(
                                height: 2, width: 100, color: Colors.amber),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
