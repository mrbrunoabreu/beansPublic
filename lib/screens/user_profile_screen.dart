import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/screens/edit_profile.dart';
import 'package:blackbeans/screens/recipes_home.dart';
import 'package:blackbeans/widgets/switch_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key key}) : super(key: key);

  static const routeName = 'profile-screen';

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future _userProfile;

  bool profileCheck = true;

  @override
  void initState() {
    final profileData = Provider.of<UserRepository>(context, listen: false);
    if (profileCheck) {
      _userProfile = profileData.fetchProfile();
      profileCheck = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenArea = MediaQuery.of(context).size.height * 0.8;
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: _userProfile,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                } else {
                  return Consumer<UserRepository>(
                    builder: (ctx, repositoryData, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                      repositoryData.userProfile.userPhotoUrl),
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome,',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                    Text(
                                      '${repositoryData.userProfile.name} ${repositoryData.userProfile.lastName}',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Text('Settings',
                                style: Theme.of(context).textTheme.headline2),
                            const SizedBox(height: 20),
                            SettingsItem(
                              iconShapeColor: Colors.purple[50],
                              iconColor: Colors.purple,
                              icon: Ionicons.finger_print,
                              settingsTitle: 'Your info',
                              onPressedAction: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(
                                            currentProfile:
                                                repositoryData.userProfile,
                                          ))),
                            ),
                            const SizedBox(height: 20),
                            Consumer<SwitchTheme>(
                              builder: (context, switchTheme, child) =>
                                  SettingsItem(
                                      iconShapeColor: Colors.lightBlue[50],
                                      iconColor: Colors.lightBlue,
                                      icon: Ionicons.moon,
                                      settingsTitle: 'Dark Mode',
                                      onPressedAction: () =>
                                          switchTheme.toggleTheme()),
                            ),
                            const SizedBox(height: 20),
                            SettingsItem(
                              iconShapeColor: Colors.orange[50],
                              iconColor: Colors.orange,
                              icon: Ionicons.earth,
                              settingsTitle: 'Language',
                            ),
                            const SizedBox(height: 20),
                            SettingsItem(
                              iconShapeColor: Colors.red[50],
                              iconColor: Colors.red,
                              icon: Ionicons.exit_outline,
                              settingsTitle: 'Log out',
                              onPressedAction: () => buildShowDialog(
                                  context: context,
                                  alertMessage:
                                      'Are you sure you want to log out?',
                                  onConfirm: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pop(context);
                                  }),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              }),
        ],
      ),
    );
  }

  Future buildShowDialog(
      {BuildContext context, String alertMessage, VoidCallback onConfirm}) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              titleTextStyle: Theme.of(context).textTheme.bodyText1,
              title: Text(
                alertMessage,
              ),
              actions: [
                FlatButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Cancel')),
                FlatButton(onPressed: onConfirm, child: const Text('Yes'))
              ],
            ));
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem(
      {this.iconShapeColor,
      this.iconColor,
      this.icon,
      this.settingsTitle,
      this.onPressedAction});

  final Color iconShapeColor;
  final Color iconColor;
  final IconData icon;
  final String settingsTitle;
  final VoidCallback onPressedAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration:
                  BoxDecoration(color: iconShapeColor, shape: BoxShape.circle),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              settingsTitle,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
        Material(
          color: Theme.of(context).primaryColorDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: IconButton(
            icon: const Icon(
              Ionicons.chevron_forward,
              size: 18,
            ),
            onPressed: onPressedAction,
          ),
        ),
      ],
    );
  }
}

class StunningBar extends StatelessWidget {
  final Icon leadingIcon;
  final String centerTitle;
  final Icon trailingIcon;
  final Color backgroundColor;

  const StunningBar({
    this.leadingIcon,
    this.centerTitle,
    this.trailingIcon,
    this.backgroundColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Theme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 22,
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ),
            Material(
              color: Theme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 24,
                ),
                onPressed: () => Navigator.of(context).canPop()
                    ? Navigator.of(context).pop
                    : Navigator.of(context)
                        .pushReplacementNamed(RecipesHome.routeName),
              ),
            )
          ],
        ),
      ),
    );
  }
}
