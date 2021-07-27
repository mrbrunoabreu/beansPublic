import 'package:blackbeans/auth/complete_registration.dart';
import 'package:blackbeans/bloc/recipes_provider.dart';
import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/models/profile.dart';
import 'package:blackbeans/models/recipe.dart';
import 'package:blackbeans/screens/image_capture_screen.dart';
import 'package:blackbeans/screens/recipes_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:blackbeans/widgets/pickTags.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key key}) : super(key: key);

  static const routeName = 'addrecipe-screen';

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subtitleFocus = FocusNode();
  final _recipeFocus = FocusNode();
  final List<String> _createdTags = [];
  bool profileCheck = true;
  Profile user;

  String mealImageUrl;
  final Recipe _newRecipe = Recipe(
      creatorId: '',
      mealImage: '',
      mealTitle: '',
      mealDescription: '',
      mealInstructions: '',
      isLunch: false,
      isDinner: false,
      recipeTags: []);

  @override
  void initState() {
    final userData = Provider.of<UserRepository>(context, listen: false);
    if (profileCheck) {
      setState(() {
        user = userData.userProfile;
        profileCheck = false;
      });
    }
    super.initState();
  }

  Future<void> _saveForm(Recipe newRecipe) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    try {
      newRecipe.recipeTags = _createdTags;
      await Provider.of<RecipesProvider>(context, listen: false)
          .addRecipe(newRecipe);
    } catch (error) {
      print(error);
    }
    Navigator.of(context).popAndPushNamed(RecipesHome.routeName);
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

    if (user.name == null || user.name == 'User') {
      return const CompleteRegistration();
    } else {
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
                              onPressed: () => _saveForm(_newRecipe),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
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
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_subtitleFocus);
                                },
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                    hintText: 'Recipe title'),
                                onSaved: (String value) {
                                  _newRecipe.mealTitle = value;
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
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_recipeFocus);
                                },
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                    hintText: 'Recipe subtitle'),
                                onSaved: (String value) {
                                  _newRecipe.mealDescription = value;
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
                                  maxLength: 1500,
                                  scrollPadding: const EdgeInsets.all(5),
                                  decoration: const InputDecoration(
                                    hintText: 'Recipe instructions (optional)',
                                  ),
                                  onSaved: (String value) {
                                    _newRecipe.mealInstructions = value;
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              PickTags(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  value: _newRecipe.isLunch,
                                  onChanged: (bool val) {
                                    setState(() {
                                      _newRecipe.isLunch = val;
                                    });
                                  }),
                              const SizedBox(height: 15),
                              SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('Dinner',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  value: _newRecipe.isDinner,
                                  onChanged: (bool val) {
                                    setState(() {
                                      _newRecipe.isDinner = val;
                                    });
                                  }),
                              InkWell(
                                  onTap: () => Navigator.of(context)
                                          .pushNamed(
                                              ImageCaptureScreen.routeName)
                                          .then((value) {
                                        setState(() {
                                          mealImageUrl = value as String;
                                          _newRecipe.mealImage = mealImageUrl;
                                        });
                                      }),
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey[200],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(14))),
                                      child: (mealImageUrl != null)
                                          ? Image.network(mealImageUrl)
                                          : const Icon(Ionicons.image,
                                              color: Colors.black54))),
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
