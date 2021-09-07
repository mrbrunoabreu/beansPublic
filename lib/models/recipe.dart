class Recipe {
  String? recipeId;
  String? creatorId;
  String? creationDate;
  String? mealImage;
  String? mealTitle;
  String? mealDescription;
  String? mealInstructions;
  bool? isLunch;
  bool? isDinner;
  bool? isFave = false;
  bool? isPlan = false;
  List<dynamic>? recipeTags = [];

  Recipe(
      {this.recipeId,
      this.creatorId,
      this.creationDate,
      required this.mealImage,
      required this.mealTitle,
      required this.mealDescription,
      this.mealInstructions,
      this.isLunch,
      this.isDinner,
      this.isFave,
      this.isPlan,
      this.recipeTags});

  factory Recipe.fromJson(Map<String, dynamic> data) {
    return Recipe(
        recipeId: data['recipeId'] as String?,
        creatorId: data['creatorId'] as String?,
        creationDate: data['creationDate'] as String?,
        mealTitle: data['mealTitle'] as String?,
        mealDescription: data['mealDescription'] as String?,
        mealInstructions: data['mealInstructions'] as String?,
        mealImage: data['mealImage'] as String?,
        isLunch: data['isLunch'] as bool?,
        isDinner: data['isDinner'] as bool?,
        isPlan: data['isPlan'] as bool?,
        isFave: data['isFave'] as bool?,
        recipeTags: data['recipeTags'] as List<dynamic>?);
  }

  Map<String, dynamic> toJson() => {
        'recipeId': recipeId,
        'creatorId': creatorId,
        'creationDate': DateTime.now().toIso8601String(),
        'mealTitle': mealTitle,
        'mealDescription': mealDescription,
        'mealImage': mealImage,
        'mealInstructions': mealInstructions,
        'isLunch': isLunch,
        'isDinner': isDinner,
        'isPlan': isPlan,
        'isFave': isFave,
        'recipeTags': recipeTags
      };
}
