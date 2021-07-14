import 'package:blackbeans/auth/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool signUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/login-bg.jpg"), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to BEANS',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 20),
              SizedBox(
                child: Column(children: [
                  TextField(
                      style: Theme.of(context).textTheme.headline5,
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email')),
                  TextField(
                      style: Theme.of(context).textTheme.headline5,
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password')),
                  SizedBox(height: 30),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      if (signUp) {
                        context.read<AuthService>().signUp(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                      } else {
                        context.read<AuthService>().signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                      }
                    },
                    child: signUp
                        ? Text('Sign Up',
                            style: Theme.of(context).textTheme.button)
                        : Text('Sign In',
                            style: Theme.of(context).textTheme.button),
                  ),
                  OutlineButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      setState(() {
                        signUp = !signUp;
                      });
                    },
                    child: signUp
                        ? const Text('Have an account? Sign In')
                        : const Text('Create an account'),
                  )
                ]),
              ),
            ]),
      ),
    ));
  }
}
