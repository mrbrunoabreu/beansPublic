import 'package:blackbeans/auth/authService.dart';
import 'package:blackbeans/auth/authWrapper.dart';
import 'package:blackbeans/bloc/beansta_provider.dart';
import 'package:blackbeans/bloc/recipes_provider.dart';
import 'package:blackbeans/bloc/user_repository.dart';
import 'package:blackbeans/screens/add_recipe.dart';
import 'package:blackbeans/screens/beansta_add_photo.dart';
import 'package:blackbeans/screens/beansta_comments.dart';
import 'package:blackbeans/screens/beansta_home.dart';
import 'package:blackbeans/screens/edit_profile.dart';
import 'package:blackbeans/screens/edit_recipe.dart';
import 'package:blackbeans/screens/image_capture_screen.dart';
import 'package:blackbeans/screens/recipe_detail.dart';
import 'package:blackbeans/screens/recipes_home.dart';
import 'package:blackbeans/screens/reset_password.dart';
import 'package:blackbeans/screens/telateste.dart';
import 'package:blackbeans/screens/user_profile_screen.dart';
import 'package:blackbeans/theme.dart';
import 'package:blackbeans/widgets/switch_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<RecipesProvider>(
            create: (_) => RecipesProvider()),
        ChangeNotifierProvider<UserRepository>(create: (_) => UserRepository()),
        ChangeNotifierProvider<BeanstaProvider>(
            create: (_) => BeanstaProvider()),
        ChangeNotifierProvider<SwitchTheme>(create: (_) => SwitchTheme()),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
        )
      ],
      child: Consumer<SwitchTheme>(
        builder: (context, switchTheme, child) => MaterialApp(
          title: 'BEANS',
          theme:
              switchTheme.darkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
          routes: {
            RecipesHome.routeName: (ctx) => RecipesHome(),
            RecipeDetail.routeName: (ctx) => RecipeDetail(),
            UserProfileScreen.routeName: (ctx) => const UserProfileScreen(),
            EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
            ResetPasswordScreen.routeName: (ctx) => const ResetPasswordScreen(),
            AddRecipeScreen.routeName: (ctx) => const AddRecipeScreen(),
            EditRecipeScreen.routeName: (ctx) => const EditRecipeScreen(),
            ImageCaptureScreen.routeName: (ctx) => const ImageCaptureScreen(),
            TelaTeste.routeName: (ctx) => const TelaTeste(),
            BeanstaHome.routeName: (ctx) => const BeanstaHome(),
            BeanstaAddPhotoScreen.routeName: (ctx) =>
                const BeanstaAddPhotoScreen(),
            BeanstaComments.routeName: (ctx) => BeanstaComments(),
          },
          home: AuthWrapper(),
        ),
      ),
    );
  }
}
