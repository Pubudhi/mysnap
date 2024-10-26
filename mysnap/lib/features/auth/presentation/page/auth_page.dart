import 'package:flutter/widgets.dart';
import 'package:mysnap/features/auth/presentation/page/login_page.dart';
import 'package:mysnap/features/auth/presentation/page/register_page.dart';


/// redirect between login and register 



class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  // initial page
  bool showLoginPage = true;

  // toggle between pages
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(
        togglePages: togglePages,
      );
    }else{
      return RegisterPage(
        togglePages: togglePages,
      );
    }
  }
}