import 'package:blackbeans/bloc/recipes_provider.dart';
import 'package:blackbeans/models/recipe.dart';
import 'package:blackbeans/screens/image_capture_screen.dart';
import 'package:blackbeans/screens/recipes_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:blackbeans/widgets/pickTags.dart';

class EditRecipeScreen extends StatefulWidget {
  const EditRecipeScreen({this.recipe, Key key}) : super(key: key);

  final Recipe recipe;
  static const routeName = 'editrecipe-screen';

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subtitleFocus = FocusNode();
  final _recipeFocus = FocusNode();
  List<String> _createdTags = [];

  String mealImageUrl;
  Recipe _editedRecipe = Recipe(
      recipeId: '',
      creatorId: '',
      mealImage: '',
      mealTitle: '',
      mealDescription: '',
      mealInstructions: '',
      isLunch: false,
      isDinner: false,
      recipeTags: []);

  Future<void> _saveForm(Recipe editedRecipe) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    editedRecipe.recipeTags = _createdTags;
    _editedRecipe.mealImage =
        mealImageUrl.isEmpty ? widget.recipe.mealImage : mealImageUrl;

    try {
      await Provider.of<RecipesProvider>(context, listen: false)
          .editRecipe(editedRecipe: editedRecipe, recipeId: widget.recipe.recipeId);
    } catch (error) {
      print(error);
    }
    Navigator.canPop(context)
        ? Navigator.of(context).pop()
        : Navigator.of(context).popAndPushNamed(RecipesHome.routeName);
  }

  @override
  void dispose() {
    _subtitleFocus.dispose();
    _recipeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenArea = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Container(
          height: screenArea,
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.white60,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: IconButton(
                            icon: const Icon(
                              Ionicons.chevron_back,
                              color: Colors.black,
                              size: 22,
                            ),
                            onPressed: Navigator.of(context).pop,
                          ),
                        ),
                        Material(
                          color: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: IconButton(
                            icon: const Icon(
                              Ionicons.checkmark,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: () => _saveForm(_editedRecipe),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add a new recipe',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              textInputAction: TextInputAction.next,
                              autofocus: true,
                              initialValue: widget.recipe.mealTitle,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_subtitleFocus);
                              },
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                  hintText: 'Recipe title'),
                              onSaved: (String value) {
                                _editedRecipe.mealTitle = value;
                              },
                              validator: (value) {
                                if (value.isEmpty || value.length < 3) {
                                  return 'Please enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              focusNode: _subtitleFocus,
                              textInputAction: TextInputAction.next,
                              initialValue: widget.recipe.mealDescription,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_recipeFocus);
                              },
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                  hintText: 'Recipe subtitle'),
                              onSaved: (String value) {
                                _editedRecipe.mealDescription = value;
                              },
                              validator: (value) {
                                if (value.isEmpty || value.length < 3) {
                                  return 'Please enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            Container(
                              alignment: Alignment.bottomLeft,
                              width: double.infinity,
                              height: 110,
                              child: TextFormField(
                                style: Theme.of(context).textTheme.bodyText1,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                initialValue: widget.recipe.mealInstructions,
                                onFieldSubmitted: (_) {
                                  final FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                },
                                keyboardType: TextInputType.multiline,
                                minLines: 5,
                                maxLines: 10,
                                maxLength: 500,
                                scrollPadding: const EdgeInsets.all(5),
                                decoration: const InputDecoration(
                                  hintText: 'Recipe instructions (optional)',
                                ),
                                onSaved: (String value) {
                                  _editedRecipe.mealInstructions = value;
                                },
                              ),
                            ),
                            const SizedBox(height: 15),
                            PickTags(
                              initialTags: widget.recipe.recipeTags
                                  .map((e) => e.toString())
                                  .toList(),
                              onTag: (tag) {
                                _createdTags.add(tag);
                              },
                              onDelete: (tag) {
                                _createdTags.remove(tag);
                              },
                            ),
                            const SizedBox(height: 15),
                            SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Lunch',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                value: widget.recipe.isLunch,
                                onChanged: (bool val) {
                                  setState(() {
                                    _editedRecipe.isLunch = val;
                                  });
                                }),
                            const SizedBox(height: 15),
                            SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Dinner',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                value: widget.recipe.isDinner,
                                onChanged: (bool val) {
                                  setState(() {
                                    _editedRecipe.isDinner = val;
                                  });
                                }),
                            InkWell(
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey[200],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(14))),
                                  child: (mealImageUrl != null)
                                      ? Image.network(mealImageUrl)
                                      : Image.network(widget.recipe.mealImage)),
                              onTap: () => Navigator.of(context)
                                  .pushNamed(ImageCaptureScreen.routeName)
                                  .then((value) {
                                setState(() {
                                  mealImageUrl = value as String;
                                  _editedRecipe.mealImage = mealImageUrl;
                                });
                              }),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Pick an image',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StunningBar extends StatelessWidget {
  final Icon leadingIcon;
  final String centerTitle;
  final Icon trailingIcon;
  final Color backgroundColor;
  final Future save;

  const StunningBar({
    this.leadingIcon,
    this.centerTitle,
    this.trailingIcon,
    this.backgroundColor,
    this.save,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.white60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: IconButton(
                icon: const Icon(
                  Ionicons.chevron_back,
                  color: Colors.black,
                  size: 22,
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ),
            Material(
              color: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: IconButton(
                icon: const Icon(
                  Ionicons.checkmark,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({this.settingsTitle, this.onPressedAction});

  final String settingsTitle;
  final Function onPressedAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              settingsTitle,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ],
    );
  }
}
