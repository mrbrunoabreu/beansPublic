import 'package:blackbeans/auth/authService.dart';
import 'package:blackbeans/auth/authWrapper.dart';
import 'package:blackbeans/bloc/beansta_repository.dart';
import 'package:blackbeans/bloc/recipes_repository.dart';
import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/models/beansta_comment.dart';
import 'package:blackbeans/screens/add_recipe.dart';
import 'package:blackbeans/screens/beansta_add_photo.dart';
import 'package:blackbeans/screens/beansta_comments.dart';
import 'package:blackbeans/screens/beansta_home.dart';
import 'package:blackbeans/screens/edit_profile.dart';
import 'package:blackbeans/screens/edit_recipe.dart';
import 'package:blackbeans/screens/image_capture_screen.dart';
import 'package:blackbeans/screens/recipe_detail.dart';
import 'package:blackbeans/screens/recipes_home.dart';
import 'package:blackbeans/screens/telateste.dart';
import 'package:blackbeans/screens/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(

    statusBarColor: Colors.black,/* set Status bar color in Android devices. */
    
    statusBarIconBrightness: Brightness.light,/* set Status bar icons color in Android devices.*/
    
    statusBarBrightness: Brightness.light)/* set Status bar icon color in iOS. */
); 
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<RecipesRepository>(
            create: (_) => RecipesRepository()),
        ChangeNotifierProvider<UserRepository>(
            create: (_) => UserRepository()),
        ChangeNotifierProvider<BeanstaRepository>(
            create: (_) => BeanstaRepository()),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: lightTheme(),
        // initialRoute: RecipesHome.routeName,
        routes: {
          RecipesHome.routeName: (ctx) => RecipesHome(),
          RecipeDetail.routeName: (ctx) => RecipeDetail(),
          UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
          EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
          AddRecipeScreen.routeName: (ctx) => AddRecipeScreen(),
          EditRecipeScreen.routeName: (ctx) => EditRecipeScreen(),
          ImageCaptureScreen.routeName: (ctx) => ImageCaptureScreen(),
          TelaTeste.routeName: (ctx) => TelaTeste(),
          BeanstaHome.routeName: (ctx) => BeanstaHome(),
          BeanstaAddPhotoScreen.routeName: (ctx) => BeanstaAddPhotoScreen(),
          BeanstaComments.routeName: (ctx) => BeanstaComments(),
        },
        home: AuthWrapper(),
      ),
    );
  }

  ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
        hintColor: Colors.black,
          primarySwatch: Colors.blue,
          buttonColor: Colors.lightBlue[900],
          scaffoldBackgroundColor: const Color(0xffeef2f5),
          backgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: const TextTheme(
              bodyText1: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
              bodyText2: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
              headline1: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black87),
              headline2: TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
              headline3: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
              headline4: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w200,
                  color: Colors.grey),
              headline5: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
              headline6: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
              subtitle1: TextStyle(
                  fontSize: 21.0,
                  fontFamily: 'Sacramento',
                  fontStyle: FontStyle.italic,
                  color: Colors.blue),
              subtitle2: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open Sans',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54),
              button: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  color: Colors.white)),
          buttonTheme: ButtonThemeData(minWidth: 50),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w200,
                color: Colors.black87),
          ));
  }
}
