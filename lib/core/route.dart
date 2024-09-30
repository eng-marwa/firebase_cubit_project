import '../presentation/home.dart';
import '../presentation/login.dart';
import '../presentation/register.dart';
import '../presentation/splash.dart';

var routes = {
  '/': (context) => Splash(),
  '/home': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),
};
