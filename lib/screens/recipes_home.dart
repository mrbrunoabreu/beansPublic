import 'package:blackbeans/bloc/recipes_repository.dart';
import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/models/recipe.dart';
import 'package:blackbeans/screens/add_item_selection.dart';
import 'package:blackbeans/screens/add_recipe.dart';
import 'package:blackbeans/screens/beansta_home.dart';
import 'package:blackbeans/screens/recipe_detail.dart';
import 'package:blackbeans/screens/telateste.dart';
import 'package:blackbeans/screens/user_profile_screen.dart';
import 'package:blackbeans/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blackbeans/constants/recipe_filters.dart';
import 'package:ionicons/ionicons.dart';

class RecipesHome extends StatefulWidget {
  static const routeName = 'recipes-home';

  @override
  _RecipesHomeState createState() => _RecipesHomeState();
}

class _RecipesHomeState extends State<RecipesHome> {

  int _currentIndex = 0;
  bool profileCheck = true;

  @override
  void initState() {
    final userData = Provider.of<UserRepository>(context, listen: false);
    if (profileCheck) {
      userData.fetchProfile();
      setState(() {
        profileCheck = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final recipesRepository = Provider.of<RecipesRepository>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.lightBlue[900],
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedLabelStyle: Theme.of(context).textTheme.bodyText1,
        unselectedLabelStyle: Theme.of(context).textTheme.bodyText1,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Ionicons.home_outline), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.image_outline), label: 'Food Porn'),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.add_circle_outline), label: 'Add item'),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.happy_outline), label: 'Profile')
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _currentIndex == 3 ? UserProfileScreen() : _currentIndex == 2 ? AddItemSelection() : _currentIndex == 1 ? BeanstaHome() : Container(
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
                    shadowColor: Colors.blueGrey.withOpacity(0.4),
                    color: Theme.of(context).backgroundColor,
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
                          onTap: () => showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(recipesRepository, recipesRepository.recipeItems)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                          color: recipesRepository.showLunch
                              ? Colors.blue
                              : Theme.of(context).buttonColor,
                          disabledColor: Colors.red,
                          onPressed: () => recipesRepository.toggleShowLunch(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text('Lunch',
                              style: Theme.of(context).textTheme.button)),
                      const SizedBox(width: 10),
                      FlatButton(
                          color: recipesRepository.showDinner
                              ? Colors.blue
                              : Theme.of(context).buttonColor,
                          disabledColor: Colors.red,
                          onPressed: () {},
                          child: Text('Dinner',
                              style: Theme.of(context).textTheme.button),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 10),
                      FlatButton(
                          color: recipesRepository.showPlan
                              ? Colors.blue
                              : Theme.of(context).buttonColor,
                          disabledColor: Colors.red,
                          onPressed: () {},
                          child: Text('Plans',
                              style: Theme.of(context).textTheme.button),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 10),
                      FlatButton(
                          color: recipesRepository.showFave
                              ? Colors.blue
                              : Theme.of(context).buttonColor,
                          disabledColor: Colors.red,
                          onPressed: () {},
                          child: Text('Faves',
                              style: Theme.of(context).textTheme.button),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, top: 15),
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: Color(0xFF01579B), width: 2))),
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
                    height: 130,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [
                        0.4,
                        0.9,
                      ],
                      colors: [
                        Theme.of(context).backgroundColor,
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    )),
                  ),
                  Container(
                      height: 100,
                      color: Theme.of(context).scaffoldBackgroundColor)
                ]),
                SuggestionsList(recipesRepository: recipesRepository),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 4),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('MY COLLECTION',
                        style: Theme.of(context).textTheme.headline1),
                    IconButton(icon: const Icon(Ionicons.create_outline), iconSize: 26, onPressed: () => Navigator.of(context).pushNamed(
                          AddRecipeScreen.routeName)
                    )
                  ]),
            ),
            Expanded(child: RecipeCollectionList()),
            // TodayHighlight(deviceWidth: deviceWidth),
          ],
        ),
      ),
    );
  }
}

class SuggestionsList extends StatelessWidget {
  const SuggestionsList({
    Key key,
    @required this.recipesRepository,
  }) : super(key: key);

  final RecipesRepository recipesRepository;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 190,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: recipesRepository.suggestions
                .map((e) => GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(RecipeDetail.routeName, arguments: e),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        height: 160,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey[400].withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  3, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.indigo,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(e.mealImage))),
                                height: 80,
                                width: 140,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.mealTitle,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                    const Divider(),
                                    Text(e.mealDescription,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList()),
      ),
    );
  }
}

class DestaqueDia extends StatelessWidget {
  const DestaqueDia({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 110,
      child: Card(
        elevation: 8,
        shadowColor: Colors.black,
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                      image: AssetImage('assets/images/roasted_lamb.jpeg'))),
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Receita nome grande demais',
                      softWrap: true,
                      style: Theme.of(context).textTheme.subtitle1),
                  Divider(
                      height: 15,
                      thickness: 1,
                      color: Color(0xFF01579B),
                      endIndent: 50),
                  Text('Descricao',
                      style: Theme.of(context).textTheme.subtitle2)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RecipeCollectionList extends StatefulWidget {
  const RecipeCollectionList({
    Key key,
  }) : super(key: key);

  @override
  _RecipeCollectionListState createState() => _RecipeCollectionListState();
}

class _RecipeCollectionListState extends State<RecipeCollectionList> {
  Future _initialRecipes;

  @override
  void initState() {
    _initialRecipes = Provider.of<RecipesRepository>(context, listen: false)
        .setFetchRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialRecipes,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapshot.hasError) {
            return const Center(child: Text('Error'));
          } else {
            return Consumer<RecipesRepository>(
              builder: (ctx, repositoryData, child) {
                final List<Recipe> recipes = repositoryData.showLunch
                    ? repositoryData.lunchItems
                    : repositoryData.showDinner
                        ? repositoryData.dinnerItems
                        : repositoryData.showPlan
                            ? repositoryData.planItems
                            : repositoryData.showFave
                                ? repositoryData.faveItems
                                : repositoryData.recipeItems;
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 4),
                  shrinkWrap: true,
                  itemCount: recipes.length,
                  itemBuilder: (ctx, index) => Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    shadowColor: Colors.blueGrey.withOpacity(0.3),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(right: 15),
                      leading: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4)),
                        child: SizedBox(
                          height: 60,
                          width: 80,
                          child: Image.network(recipes[index].mealImage,
                              fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(recipes[index].mealTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodyText1),
                      trailing: Wrap(
                        spacing: 1,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.favorite,
                                  size: 16,
                                  color: recipes[index].isFave
                                      ? Colors.red
                                      : Colors.grey),
                              onPressed: () {}), // icon-1
                          IconButton(
                              icon: Icon(Icons.restaurant,
                                  size: 16,
                                  color: recipes[index].isPlan
                                      ? Colors.red
                                      : Colors.grey),
                              onPressed: () {}), // icon-2
                        ],
                      ),
                      onTap: () => Navigator.of(ctx).pushNamed(
                          RecipeDetail.routeName,
                          arguments: recipes[index]),
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}

class TodayHighlight extends StatelessWidget {
  const TodayHighlight({
    Key key,
    @required this.deviceWidth,
  }) : super(key: key);

  final double deviceWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(left: 8, top: 12, right: 8),
        elevation: 10,
        shadowColor: Colors.black,
        // color: Colors.brown[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(RecipeDetail.routeName),
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
                            style: Theme.of(context).textTheme.headline3),
                      ),
                    ),
                    Container(height: 2, width: 100, color: Colors.amber),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
