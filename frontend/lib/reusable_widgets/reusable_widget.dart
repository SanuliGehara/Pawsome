import 'package:flutter/material.dart';

/// Image widget to reuse in anywhere of the application
Image logoWidget (String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240, // Can use a parameter value for width & height
    //   to fit into any image size. NO need to Put 240
    height: 240,
    //color: Colors.orangeAccent,
  );
}

/// Reusable method to show a SnackBar with custom background color
void showCustomSnackBar(BuildContext context, String message, Color bgColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Reusable widget for Text field
TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

/// Reusable widget for Button
Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.red;  // when click on it
            }
            return Colors.deepOrange;  // default color
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

/// view profile pic
class ProfilePictureViewer {
  static void show(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imageUrl.isNotEmpty
                    ? (imageUrl.startsWith("http")
                    ? Image.network(imageUrl, fit: BoxFit.contain)
                    : Image.asset(imageUrl, fit: BoxFit.contain))
                    : Image.asset("assets/images/no_profile_pic.png", fit: BoxFit.contain),
              ),
            ),
          ),
        );
      },
    );
  }
}