import 'package:blackbeans/models/recipe.dart';
import 'package:blackbeans/screens/recipe_detail.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';


class CustomSearchDelegate extends SearchDelegate {
  final recipeProvider;
  final List<Recipe> recipeData;

  List suggestion = ['Please add a meal first', 'Nonono'];

  CustomSearchDelegate(this.recipeProvider, this.recipeData);

  List<Recipe> searchResult = List();

  @override
ThemeData appBarTheme(BuildContext context) {
return ThemeData(
  primaryColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    color: Colors.black12,

  )

);
}

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Ionicons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Ionicons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchResult.clear();
    searchResult = recipeData
        .where((element) =>
            element.mealTitle.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Container(
      margin: EdgeInsets.all(20),
      child: ListView(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          scrollDirection: Axis.vertical,
          children: List.generate(searchResult.length, (index) {
            var item = searchResult[index];
            return ListTile(
              contentPadding: EdgeInsets.only(right: 15),
              leading: Container(
                width: 80,
                height: 60,
                child: item.mealImage != null
                    ? Image.network(item.mealImage, fit: BoxFit.cover)
                    : Image.asset('assets/kiyama.jpg'),
              ),
              title: Text(
                item.mealTitle,
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              onTap: () => Navigator.of(context)
                  .pushNamed(RecipeDetail.routeName, arguments: item),
              trailing: Wrap(
                spacing: 1,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.favorite,
                        size: 16,
                        color: item.isFave ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        recipeProvider.toggleFave(item);
                      }), // icon-1
                  IconButton(
                      icon: Icon(Icons.restaurant,
                          size: 16,
                          color: item.isPlan ? Colors.red : Colors.grey),
                      onPressed: () {
                        recipeProvider.togglePlan(item);
                      }), // icon-2
                ],
              ),
            );
          })),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestion = recipeData.sublist(0, 3);
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    final suggestionList = query.isEmpty
        ? suggestion
        : recipeData
            .where((element) =>
                element.mealTitle.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          if (query.isEmpty) {
            query = suggestion[index].mealTitle as String;
          }
          Navigator.of(context).pushNamed(RecipeDetail.routeName,
              arguments: suggestionList[index]);
        },
        leading: Icon(query.isEmpty ? Icons.history : Icons.search),
        title: RichText(
            text: TextSpan(
                text:
                    suggestionList[index].mealTitle.substring(0, query.length) as String,
                style: Theme.of(context).textTheme.bodyText1,
                children: [
              TextSpan(
                text: suggestionList[index].mealTitle.substring(query.length) as String,
              )
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}