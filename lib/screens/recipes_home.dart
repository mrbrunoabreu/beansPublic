import 'package:blackbeans/bloc/recipes_provider.dart';
import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/models/recipe.dart';
import 'package:blackbeans/screens/add_item_selection.dart';
import 'package:blackbeans/screens/add_recipe.dart';
import 'package:blackbeans/screens/beansta_home.dart';
import 'package:blackbeans/screens/recipe_detail.dart';
import 'package:blackbeans/screens/user_profile_screen.dart';
import 'package:blackbeans/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final recipesProvider = Provider.of<RecipesProvider>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: Theme.of(context).textTheme.bodyText1,
        unselectedLabelStyle: Theme.of(context).textTheme.bodyText1,
        items: const [
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
      body: _currentIndex == 3
          ? const UserProfileScreen()
          : _currentIndex == 2
              ? const AddItemSelection()
              : _currentIndex == 1
                  ? const BeanstaHome()
                  : RecipesMain(recipesProvider: recipesProvider),
    );
  }
}

class RecipesMain extends StatelessWidget {
  const RecipesMain({
    Key key,
    @required this.recipesProvider,
  }) : super(key: key);

  final RecipesProvider recipesProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                        // color: Colors.black
                      ),
                      hintText: 'Search recipes',
                      hintStyle: Theme.of(context).textTheme.bodyText1),
                  onTap: () => showSearch(
                      context: context,
                      delegate:
                          CustomSearchDelegate(recipesProvider.recipeItems)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      color: recipesProvider.showLunch
                          ? Colors.blue[700]
                          : Theme.of(context).buttonColor,
                      disabledColor: Colors.red,
                      onPressed: () => recipesProvider.toggleShowLunch(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('Lunch',
                          style: Theme.of(context).textTheme.button)),
                  const SizedBox(width: 10),
                  FlatButton(
                    color: recipesProvider.showDinner
                        ? Colors.blue[700]
                        : Theme.of(context).buttonColor,
                    disabledColor: Colors.red,
                    onPressed: () => recipesProvider.toggleShowDinner(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Dinner',
                        style: Theme.of(context).textTheme.button),
                  ),
                  const SizedBox(width: 10),
                  FlatButton(
                    color: recipesProvider.showPlan
                        ? Colors.blue[700]
                        : Theme.of(context).buttonColor,
                    disabledColor: Colors.red,
                    onPressed: () => recipesProvider.toggleShowPlan(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Plans',
                        style: Theme.of(context).textTheme.button),
                  ),
                  const SizedBox(width: 10),
                  FlatButton(
                    color: recipesProvider.showFave
                        ? Colors.blue[700]
                        : Theme.of(context).buttonColor,
                    disabledColor: Colors.red,
                    onPressed: () => recipesProvider.toggleShowFave(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Faves',
                        style: Theme.of(context).textTheme.button),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 2, top: 15),
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          left:
                              BorderSide(color: Color(0xFF01579B), width: 2))),
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
                  height: 100, color: Theme.of(context).scaffoldBackgroundColor)
            ]),
            StaffSuggestions(recipesProvider: recipesProvider),
            // SuggestionsList(recipesProvider: recipesProvider),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, top: 4),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('MY COLLECTION', style: Theme.of(context).textTheme.headline1),
            IconButton(
                icon: const Icon(Ionicons.create_outline),
                iconSize: 26,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AddRecipeScreen.routeName))
          ]),
        ),
        const Expanded(child: RecipeCollectionList()),
      ],
    );
  }
}

class StaffSuggestions extends StatefulWidget {
  const StaffSuggestions({
    Key key,
    @required this.recipesProvider,
  }) : super(key: key);

  final RecipesProvider recipesProvider;

  @override
  _StaffSuggestionsState createState() => _StaffSuggestionsState();
}

class _StaffSuggestionsState extends State<StaffSuggestions> {
  Future _suggestions;
  bool _needRefresh = true;

  @override
  void initState() {
    if (_needRefresh) {
      _suggestions = widget.recipesProvider.staffSuggestions();
      _needRefresh = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 190,
        child: FutureBuilder(
            future: _suggestions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget.recipesProvider.todaysSuggestions
                      .map((e) => GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                                RecipeDetail.routeName,
                                arguments: e),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              height: 160,
                              width: 140,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Theme.of(context).cardTheme.shadowColor,
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
                                              image:
                                                  NetworkImage(e.mealImage))),
                                      height: 80,
                                      width: 140,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(e.mealTitle,
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3),
                                          const Divider(),
                                          Text(e.mealDescription,
                                              softWrap: true,
                                              maxLines: 1,
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
                      .toList());
            }),
      ),
    );
  }
}

class SuggestionsList extends StatelessWidget {
  const SuggestionsList({
    Key key,
    @required this.recipesProvider,
  }) : super(key: key);

  final RecipesProvider recipesProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 190,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: recipesProvider.suggestions
                .map((e) => GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(RecipeDetail.routeName, arguments: e),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        height: 160,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).cardTheme.shadowColor,
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
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                    const Divider(),
                                    Text(e.mealDescription,
                                        softWrap: true,
                                        maxLines: 1,
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
    _initialRecipes =
        Provider.of<RecipesProvider>(context, listen: false).setFetchRecipes();
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
            return const Center(child: Text('No recipes yet'));
          } else {
            return Consumer<RecipesProvider>(
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
                  itemBuilder: (ctx, index) => recipes.isEmpty
                      ? const Center(
                          child: Text('No data'),
                        )
                      : Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          shadowColor: Colors.blueGrey.withOpacity(0.3),
                          child: Dismissible(
                            key: ValueKey(recipes[index].recipeId),
                            background: Container(
                                color: Theme.of(context).errorColor,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Ionicons.trash,
                                    size: 20, color: Colors.white)),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) {
                              return showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        titleTextStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        title: const Text(
                                          'This will delete this recipe forever. Are you sure?',
                                        ),
                                        actions: [
                                          FlatButton(
                                              onPressed:
                                                  Navigator.of(context).pop,
                                              child: const Text('Cancel')),
                                          FlatButton(
                                              onPressed: () => repositoryData
                                                  .deleteRecipe(
                                                      recipeId: recipes[index]
                                                          .recipeId,
                                                      imageUrl: recipes[index]
                                                          .mealImage)
                                                  .then(Navigator.of(context)
                                                      .pop),
                                              child: const Text('OK'))
                                        ],
                                      ));
                            },
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
                                      onPressed: () =>
                                          repositoryData.toggleFave(
                                              id: recipes[index]
                                                  .recipeId)), // icon-1
                                  IconButton(
                                      icon: Icon(Icons.restaurant,
                                          size: 16,
                                          color: recipes[index].isPlan
                                              ? Colors.red
                                              : Colors.grey),
                                      onPressed: () =>
                                          repositoryData.togglePlan(
                                              id: recipes[index]
                                                  .recipeId)), // icon-2
                                ],
                              ),
                              onTap: () => Navigator.of(ctx).pushNamed(
                                  RecipeDetail.routeName,
                                  arguments: recipes[index]),
                            ),
                          ),
                        ),
                );
              },
            );
          }
        });
  }
}
