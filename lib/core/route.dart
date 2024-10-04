import 'package:firebase_cubit_project/presentation/item.dart';

import '../presentation/home.dart';
import '../presentation/login.dart';
import '../presentation/register.dart';
import '../presentation/splash.dart';

var routes = {
  '/': (context) => Splash(),
  '/home': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),
  '/item': (context) => Item(),
};
