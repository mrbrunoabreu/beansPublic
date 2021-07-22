import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/widgets/beans_custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key key}) : super(key: key);

  static const routeName = 'resetpassword-screen';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  String _newPassword = '';

  _saveForm() {
    if (_formKey.currentState.validate()) {
      Provider.of<UserRepository>(context).changePassword(_newPassword);
    } else {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                titleTextStyle: Theme.of(context).textTheme.bodyText1,
                title: Text(
                  'Please choose and confirm a new password',
                ),
                actions: [
                  FlatButton(
                      onPressed: Navigator.of(context).pop, child: Text('Ok'))
                ],
              ));
    }
  }

  @override
  void dispose() {
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
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
                BeansCustomAppBar(
                    isBackButton: true,
                    trailingIcon: Icon(
                      Ionicons.checkmark,
                      size: 22,
                    ),
                    trailingIconAction: () => _saveForm),

                // SafeArea(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 15),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Material(
                //           color: Colors.white60,
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(15)),
                //           child: IconButton(
                //             icon: const Icon(
                //               Ionicons.chevron_back,
                //               color: Colors.black,
                //               size: 22,
                //             ),
                //             onPressed: Navigator.of(context).pop,
                //           ),
                //         ),
                //         Material(
                //           color: Colors.lightBlueAccent,
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(15)),
                //           child: IconButton(
                //             icon: const Icon(
                //               Ionicons.checkmark,
                //               color: Colors.white,
                //               size: 22,
                //             ),
                //             onPressed: () => _saveForm(),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Changing your password',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText1,
                              focusNode: _passwordFocus,
                              controller: _pass,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_confirmPasswordFocus);
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Enter a new password'),
                              validator: (value) {
                                _newPassword = value;
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
                              controller: _confirmPass,
                              decoration: const InputDecoration(
                                  hintText: 'Please confirm your new password'),
                              validator: (value) {
                                if (value != _newPassword) {
                                  return 'Password doesn\'t match. Please confirm the new password';
                                }
                                return null;
                              },
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
