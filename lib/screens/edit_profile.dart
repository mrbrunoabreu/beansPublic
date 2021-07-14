import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/models/profile.dart';
import 'package:blackbeans/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({this.currentProfile, Key key}) : super(key: key);

  final Profile currentProfile;
  static const routeName = 'editprofile-screen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  Profile editedProfile = Profile();


  Future<void> _saveForm(Profile editedProfile) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState.save();


    try {
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
                              initialValue: widget.currentProfile.name,
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
                                if (value.isEmpty || value.length < 3) {
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
                              initialValue: widget.currentProfile.lastName,
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
                                if (value.isEmpty || value.length < 3) {
                                  return 'Please enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              focusNode: _emailFocus,
                              initialValue: widget.currentProfile.email,
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
                                if (value.isEmpty || value.length < 3) {
                                  return 'Please enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            FlatButton(onPressed: null, child: Text('Reset your password?')),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              focusNode: _passwordFocus,
                              initialValue: widget.currentProfile.password,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocus);
                              },
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                  hintText: 'Enter a new password'),
                              onSaved: (String value) {
                                editedProfile.password = value;
                              },
                              validator: (value) {
                                if (value.isEmpty || value.length < 3) {
                                  return 'Please enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
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
                                  hintText: 'Please confirm your new password'),
                              onSaved: (String value) {
                                
                              },
                              validator: (value) {
                                if (value.isEmpty || value.length < 3) {
                                  return 'Please enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            InkWell(
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey[200],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(14))),
                                  child: Image.network(widget.currentProfile.userPhotoUrl)),
                              onTap: () {},
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