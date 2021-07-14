import 'package:blackbeans/models/recipe.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecipesRepository with ChangeNotifier {
  String baseUrl = 'https://beans-aa4aa.firebaseio.com/';

  String uid;

  List<Recipe> _recipeItems = [
    Recipe(
        recipeId: '1',
        mealImage: 'https://i.ibb.co/1q4cKxJ/lentils.jpg',
        mealTitle: 'Lentil salad',
        mealDescription: 'With egg, bacon and mustard vinaigrette',
        mealInstructions:
            'Boil lentils with one clove of garlic and bay leaf until al dente. Drain and add mustard and onions vinegrette, a pouched egg and croutons',
        isLunch: false,
        isDinner: true,
        isFave: false,
        isPlan: false),
  ];

  List<Recipe> get recipeItems => [..._recipeItems];
  List<Recipe> get lunchItems =>
      recipeItems.where((element) => element.isLunch).toList();
  List<Recipe> get dinnerItems =>
      recipeItems.where((element) => element.isDinner).toList();
  List<Recipe> get planItems =>
      recipeItems.where((element) => element.isPlan).toList();
  List<Recipe> get faveItems =>
      recipeItems.where((element) => element.isFave).toList();
      
  List<Recipe> get suggestions {
    List<Recipe> randomList = recipeItems;
    randomList.shuffle();
    var trimmedRandom = randomList.take(5);
    return trimmedRandom.toList();
  }

  bool showDinner = false;
  bool showLunch = false;
  bool showPlan = false;
  bool showFave = false;

  Future<void> setFetchRecipes() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    uid = _auth.currentUser.uid;

    final Dio dio = Dio();

    var url = '$baseUrl/$uid/recipes.json';

    try {
      final Response response = await dio.get(url);
      final extractedData = response.data as Map<String, dynamic>;

      extractedData.forEach((recipeId, recipeData) {
        _recipeItems.add(Recipe(
            recipeId: recipeId,
            creatorId: uid,
            creationDate: recipeData['creationDate'] as String,
            mealTitle: recipeData['mealTitle'] as String,
            mealDescription: recipeData['mealDescription'] as String,
            mealInstructions: recipeData['mealInstructions'] as String,
            mealImage: recipeData['mealImage'] as String,
            isLunch: recipeData['isLunch'] as bool,
            isDinner: recipeData['isDinner'] as bool,
            isPlan: recipeData['isPlan'] as bool,
            isFave: recipeData['isFave'] as bool,
            recipeTags: recipeData['recipeTags'] as List<dynamic>));
      });
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> getFiveLatestRecipes() {}

  void toggleShowLunch() {
    showLunch = !showLunch;
    showDinner = false;
    showPlan = false;
    showFave = false;
    notifyListeners();
  }

  void toggleShowDinner() {
    showDinner = !showDinner;
    showLunch = false;
    showPlan = false;
    showFave = false;
    notifyListeners();
  }

  void toggleShowPlan() {
    showPlan = !showPlan;
    showLunch = false;
    showDinner = false;
    showFave = false;
    notifyListeners();
  }

  void toggleShowFave() {
    showFave = !showFave;
    showLunch = false;
    showDinner = false;
    showPlan = false;
    notifyListeners();
  }

  Future<void> addRecipe(Recipe newRecipe) async {

    newRecipe.mealImage ??= 'https://firebasestorage.googleapis.com/v0/b/beans-aa4aa.appspot.com/o/images/empty-dish.jpg';

    final Dio dio = Dio();
    final url = '$baseUrl/$uid/recipes.json';
    
    try {
      final response = await dio.post(url,
          data: {
            'creatorId': uid,
            'creationDate': DateTime.now().toIso8601String(),
            'mealTitle': newRecipe.mealTitle,
            'mealDescription': newRecipe.mealDescription,
            'mealImage': newRecipe.mealImage,
            'mealInstructions': newRecipe.mealInstructions ?? '',
            'isLunch': newRecipe.isLunch,
            'isDinner': newRecipe.isDinner,
            'isPlan': false,
            'isFave': false,
            'recipeTags': newRecipe.recipeTags ?? ['Nothing']
          });

      final createdRecipe = Recipe(
          recipeId: response.data['recipeId'] as String,
          creationDate: DateTime.now().toIso8601String(),
          mealTitle: newRecipe.mealTitle,
          mealDescription: newRecipe.mealDescription,
          mealInstructions: newRecipe.mealInstructions,
          mealImage: newRecipe.mealImage,
          isLunch: newRecipe.isLunch,
          isDinner: newRecipe.isDinner,
          isPlan: false,
          isFave: false,
          recipeTags: newRecipe.recipeTags ?? ['Nothing']);
      _recipeItems.add(createdRecipe);
      print(createdRecipe.recipeTags[0]);
      print(newRecipe.mealTitle);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> editRecipe({Recipe editedRecipe, String recipeId}) async {

    print('id da receita: $recipeId');

    final Dio dio = Dio();
    final url = '$baseUrl/$uid/recipes/$recipeId.json';

    try {
      final response = await dio.patch(url,
          data: {
            'mealTitle': editedRecipe.mealTitle,
            'mealDescription': editedRecipe.mealDescription,
            'mealImage': editedRecipe.mealImage,
            'mealInstructions': editedRecipe.mealInstructions ?? null,
            'isLunch': editedRecipe.isLunch,
            'isDinner': editedRecipe.isDinner,
            'recipeTags': editedRecipe.recipeTags
          });

      final newRecipe = Recipe(
          recipeId: recipeId,
          creationDate: editedRecipe.creationDate,
          mealTitle: editedRecipe.mealTitle,
          mealDescription: editedRecipe.mealDescription,
          mealInstructions: editedRecipe.mealInstructions,
          mealImage: editedRecipe.mealImage,
          isLunch: editedRecipe.isLunch,
          isDinner: editedRecipe.isDinner,
          isPlan: false,
          isFave: false,
          recipeTags: editedRecipe.recipeTags ?? ['Nothing']);

      final recipeToEditIndex =
          _recipeItems.indexWhere((element) => element.recipeId == editedRecipe.recipeId);

      if (recipeToEditIndex >= 0) {
        _recipeItems[recipeToEditIndex] = newRecipe;
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  // Future<void> saveForm({Recipe newRecipe, List<String> tags}) async {
  //   newRecipe.recipeTags = tags;
  //   addRecipe(newRecipe);
  // }

}
