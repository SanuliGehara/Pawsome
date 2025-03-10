import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/home/home.dart';
import 'package:pawsome/pages/login_signup/reset_password.dart';
import 'package:pawsome/pages/login_signup/signup_page.dart';
import 'package:pawsome/reusable_widgets/reusable_widget.dart';
import 'package:pawsome/services/firebaseAuth_service.dart';
import 'package:pawsome/utils/color_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailTextControler = TextEditingController();
  TextEditingController _passwordTextControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor('FF6D00'),
              hexStringToColor('ffa31a'),
              hexStringToColor('ffb84d')
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              logoWidget('assets/images/pawsome_logo.jpeg'),
              const SizedBox(
                height: 30,
              ),
              reusableTextField('Enter Username', Icons.person_outline, false, _emailTextControler),
              const SizedBox(
                height: 20,
              ),
              reusableTextField('Enter Password', Icons.lock_outline, true, _passwordTextControler),
              const SizedBox(
                height: 10,
              ),
              forgetPassword(context),
              // login using firebase auth
              firebaseUIButton(context, 'LOGIN' , () {
                FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailTextControler.text,
                    password: _passwordTextControler.text)
                .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));})
                    .catchError((error) {
                  print("Error: ${error.toString()}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error.toString())),
                  );
                });
              }),
              const SizedBox(
                height: 10,
              ),
              // google login
          ElevatedButton(
            onPressed: () async {
              await FirebaseServices().signInWithGoogle();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage()));
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.black26;
                  }
                  return Colors.white;
                })),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/google.png",
                    height: 35,
                    width: 35,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Login with Google",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
              const SizedBox(
                height: 20,
              ),
              signUpOption(),
          ]
        ),
        ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 15)),
        GestureDetector(
          onTap: () {
            style: TextStyle(color: Colors.black);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignupPage()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16 ),
          ),
        )
      ],
    );
  }
  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
