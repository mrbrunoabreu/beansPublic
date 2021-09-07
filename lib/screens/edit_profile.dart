import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/models/profile.dart';
import 'package:blackbeans/screens/image_capture_screen.dart';
import 'package:blackbeans/screens/reset_password.dart';
import 'package:blackbeans/screens/user_profile_screen.dart';
import 'package:blackbeans/widgets/beans_custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({this.currentProfile, Key? key}) : super(key: key);

  final Profile? currentProfile;
  static const routeName = 'editprofile-screen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? newProfilePhotoUrl;

  final _formKey = GlobalKey<FormState>();
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  Profile editedProfile = Profile();

  Future<void> _saveForm(Profile editedProfile) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      Provider.of<UserRepository>(context, listen: false).editProfile(
          userName: editedProfile.name,
          userLastName: editedProfile.lastName,
          userPhotoUrl: editedProfile.userPhotoUrl);
    } catch (error) {
      print(error);
    }
    Navigator.canPop(context)
        ? Navigator.of(context).pop()
        : Navigator.of(context).popAndPushNamed(UserProfileScreen.routeName);
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
                    child: BeansCustomAppBar(
                  isBackButton: true,
                  trailingIcon: const Icon(
                    Ionicons.checkmark,
                    size: 22,
                  ),
                  trailingIconAction: () => _saveForm(editedProfile),
                )

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Material(
                    //       color: Colors.white60,
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(15)),
                    //       child: IconButton(
                    //         icon: const Icon(
                    //           Ionicons.chevron_back,
                    //           color: Colors.black,
                    //           size: 22,
                    //         ),
                    //         onPressed: Navigator.of(context).pop,
                    //       ),
                    //     ),
                    //     Material(
                    //       color: Colors.lightBlueAccent,
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(15)),
                    //       child: IconButton(
                    //         icon: const Icon(
                    //           Ionicons.checkmark,
                    //           color: Colors.white,
                    //           size: 22,
                    //         ),
                    //         onPressed: () {},
                    //       ),
                    //     )
                    //   ],
                    // ),
                    ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editing your profile',
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
                              initialValue: widget.currentProfile!.name,
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
                              initialValue: widget.currentProfile!.lastName,
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
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              focusNode: _emailFocus,
                              initialValue: widget.currentProfile!.email,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocus);
                              },
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                  hintText: 'Change your email?'),
                              onChanged: (String value) {
                                editedProfile.email = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty || value.length < 3) {
                                  return 'Please enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            FlatButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(ResetPasswordScreen.routeName),
                                child: const Text('Reset your password?')),
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
                                  child: Image.network(
                                      widget.currentProfile!.userPhotoUrl!)),
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
