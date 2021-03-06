import 'package:blackbeans/auth/complete_registration.dart';
import 'package:blackbeans/bloc/beansta_provider.dart';
import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/models/beansta_photo.dart';
import 'package:blackbeans/models/profile.dart';
import 'package:blackbeans/screens/beansta_home.dart';
import 'package:blackbeans/screens/image_capture_screen.dart';
import 'package:blackbeans/widgets/beans_custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class BeanstaAddPhotoScreen extends StatefulWidget {
  const BeanstaAddPhotoScreen({Key key}) : super(key: key);

  static const routeName = 'beansta-add-photo';

  @override
  _BeanstaAddPhotoScreenState createState() => _BeanstaAddPhotoScreenState();
}

class _BeanstaAddPhotoScreenState extends State<BeanstaAddPhotoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _captionFocus = FocusNode();
  bool profileCheck = true;
  Profile user;

  String newPhotoUrl;
  final BeanstaPhoto _newPhoto = BeanstaPhoto();

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

  Future<void> _saveForm(BeanstaPhoto newPhoto) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    try {
      await Provider.of<BeanstaProvider>(context, listen: false)
          .addPhotoItem(newphoto: newPhoto, photoUrl: newPhotoUrl, user: user);
    } catch (error) {
      print(error);
    }
    Navigator.of(context).popAndPushNamed(BeanstaHome.routeName);
  }

  @override
  void dispose() {
    _captionFocus.dispose();
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
                      child: BeansCustomAppBar(
                    isBackButton: true,
                    trailingIcon: const Icon(
                      Ionicons.checkmark,
                      color: Colors.white,
                      size: 22,
                    ),
                    trailingIconAction: () => _saveForm(_newPhoto),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add a new photo',
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
                                      .requestFocus(_captionFocus);
                                },
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                    hintText: 'Photo location'),
                                onSaved: (String value) {
                                  _newPhoto.itemLocation = value;
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
                                  focusNode: _captionFocus,
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
                                  maxLength: 500,
                                  scrollPadding: const EdgeInsets.all(5),
                                  decoration: const InputDecoration(
                                    hintText: 'Photo caption (optional)',
                                  ),
                                  onSaved: (String value) {
                                    _newPhoto.itemDescription = value;
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              InkWell(
                                  onTap: () => Navigator.of(context)
                                          .pushNamed(
                                              ImageCaptureScreen.routeName)
                                          .then((value) {
                                        setState(() {
                                          newPhotoUrl = value as String;
                                          _newPhoto.itemPhoto = newPhotoUrl;
                                        });
                                      }),
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey[200],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(14))),
                                      child: (newPhotoUrl != null)
                                          ? Image.network(newPhotoUrl)
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
