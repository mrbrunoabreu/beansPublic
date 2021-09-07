import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/models/profile.dart';
import 'package:blackbeans/screens/image_capture_screen.dart';
import 'package:blackbeans/screens/recipes_home.dart';
import 'package:blackbeans/screens/user_profile_screen.dart';
import 'package:blackbeans/widgets/beans_custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class CompleteRegistration extends StatefulWidget {
  const CompleteRegistration({
    Key? key,
  }) : super(key: key);

  @override
  _CompleteRegistrationState createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<CompleteRegistration> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  Profile editedProfile = Profile();
  String? newProfilePhotoUrl;

  Future<void> _saveForm(Profile editedProfile) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      Provider.of<UserRepository>(context, listen: false).createProfile(
          userName: editedProfile.name,
          userLastName: editedProfile.lastName,
          userPhotoUrl: editedProfile.userPhotoUrl);
    } catch (error) {
      print(error);
    }
    Navigator.of(context).popAndPushNamed(RecipesHome.routeName);
  }

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
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
                      child: BeansCustomAppBar(
                        trailingIcon: const Icon(
                          Ionicons.checkmark,
                          color: Colors.white,
                          size: 22,
                        ),
                        trailingIconAction: () => _saveForm(editedProfile),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete your profile',
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
                                    .requestFocus(_lastNameFocus);
                              },
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                  hintText: 'Enter your first name'),
                              onChanged: (String value) {
                                editedProfile.name = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Please enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              focusNode: _lastNameFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocus);
                              },
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                  hintText: 'Enter your last name'),
                              onChanged: (String value) {
                                editedProfile.lastName = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Please enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(ImageCaptureScreen.routeName)
                                  .then((value) {
                                setState(() {
                                  newProfilePhotoUrl = value as String?;
                                  editedProfile.userPhotoUrl =
                                      newProfilePhotoUrl;
                                });
                              }),
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey[200],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(14))),
                                  child: editedProfile.userPhotoUrl != null
                                      ? Image.network(
                                          editedProfile.userPhotoUrl!)
                                      : const Icon(Ionicons.camera)),
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
