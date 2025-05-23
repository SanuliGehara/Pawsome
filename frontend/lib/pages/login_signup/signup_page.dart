import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/home/home.dart';
import 'package:pawsome/pages/login_signup/login_page.dart';
import 'package:pawsome/reusable_widgets/reusable_widget.dart';
import 'package:pawsome/services/database_service.dart';
import 'package:pawsome/services/firebaseAuth_service.dart';
import 'package:pawsome/utils/color_utils.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  /// The currently selected user type.
  String? _selectedUserType;

  /// Dropdown menu options for user types.
  final List<String> _userTypes = ['normal', 'pet sitter'];

  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
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
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter UserName", Icons.person_outline, false,
                        _userNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email Id", Icons.person_outline, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outlined, true,
                        _passwordTextController),
                    const SizedBox(
                      height: 20,
                    ),

                    /// Dropdown to select account type.
                    DropdownButtonFormField<String>(
                      /// Make text white to match the other fields
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),

                      /// Set the dropdown menu background color
                      dropdownColor: Colors.white.withOpacity(0.3),

                      /// Icon color matches the text field icons
                      iconEnabledColor: Colors.white70,

                      /// Expand to match parent width
                      isExpanded: true,

                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.list,
                          color: Colors.white70,
                        ),
                        labelText: 'Select Account Type',
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.3),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      value: _selectedUserType,
                      items: _userTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUserType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    firebaseUIButton(context, "Sign Up", () {
                      if (_selectedUserType == null) {
                        showCustomSnackBar(context, "Please select an account type", Colors.deepOrangeAccent.shade200);
                        return;
                      }

                      // Create a firebase Auth instance for user account
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                          .then((value) { // if the user created with successful auth,

                        final username = _userNameTextController.text.trim();
                        final email = _emailTextController.text.trim();

                        // CREATE USER BASED ON THE TYPE - CALL CORRESPONDING FUNCTION FROM SERVICE
                        if (_selectedUserType == 'pet sitter') {
                          // Create a Pet Sitter Account
                          _databaseService.createPetSitterUser(username, email).then((_) {
                            showCustomSnackBar(context, "Created Pet Sitter account!", Colors.green.shade400);
                            print("Created Pet Sitter account in DB");

                          });
                        } else {
                          // Create a Normal User Account
                          _databaseService.createNormalUser(username, email).then((_) {
                            showCustomSnackBar(context, "Created Normal User account!", Colors.green.shade400);
                            print("Created Normal User account in DB");

                          });
                        }

                        //Navigate to Login Page
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));

                      }).onError((error, stackTrace) {
                        showCustomSnackBar(context, "Error creating user: Sorry! Account annot be created", Colors.red.shade400);
                        print("Error creating user: ${error.toString()}");

                      });
                    }),

                    const SizedBox(
                      height: 10,
                    ),
                    // google sign up button
                    ElevatedButton(
                      onPressed: () async {
                        UserCredential? userCred = await FirebaseServices().signInWithGoogleForSignup(context);
                        if (userCred != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        }
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
                              "Sign Up with Google",
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
                    loginOption()
                  ],
                ),
              ))),
    );
  }

  Row loginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have account?",
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 15)),
        GestureDetector(
          onTap: () {
            style: TextStyle(color: Colors.black);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: const Text(
            " Log In",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16 ),
          ),
        )
      ],
    );
  }

}

