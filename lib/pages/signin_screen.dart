
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project_at_etec/pages/googlesignin_screen.dart';
import 'package:flutter_final_project_at_etec/pages/signup_screen.dart';
import '../util/colors_util.dart';



class SignInScreen extends StatefulWidget {
   const SignInScreen({Key? key}) : super(key: key);
 
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {


  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();

  void onListen(){
    return setState(() {
      
    });
  }
  @override
  void initState() {
    super.initState();
    passwordTextController.addListener(onListen);
    emailTextController.addListener(onListen);
  }
  @override
  void dispose() {
    super.dispose();
    passwordTextController.removeListener(onListen);
    emailTextController.removeListener(onListen);
  }
  Future signIN() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('No user found for that email.')),
          );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(' Wrong password provided for that user.'),
            ),
          );
      }
    }
  }
  
  Future<void> showLoading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              Text('Loading...'),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:[
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                logoWidget('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2s62ladt6F75ss9x_LHrUiMvt03Kker72og&usqp=CAU'),
                const SizedBox(
                  height: 30.0,
                ),
                reusableTextField(
                  'Enter Your Email',
                  Icons.verified_user_sharp,
                  false,
                  emailTextController,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                reusableTextField(
                  'Enter Your Password',
                  Icons.lock_outline_sharp,
                  false,
                  passwordTextController,
                ),
                const SizedBox(
                  height: 0.0,
                ),
                signInUPButton(
                  context,
                  true,
                  (){
                   signIN();
                }),
                const SizedBox(
                  height: 0.0,
                ),
                googleSignInScreenOption(),
                const SizedBox(
                  height: 10.0,
                ),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Image logoWidget(String imageName){
    return Image.network(
      imageName,
      fit: BoxFit.fitWidth,
      width: 200.0,
      height: 200.0,
    );
  }

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

   Container signInUPButton(BuildContext context,bool isLoading, Function onTap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color.fromARGB(35, 0, 0, 0);
            }
            return const Color.fromARGB(139, 255, 255, 255);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
          child: Text(
            isLoading?'Log In':'Sign Up',
            style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
          ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
          style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Color.fromARGB(255, 4, 72, 229), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
  Row googleSignInScreenOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Sign in with Google?",
          style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const GoogleSignINScreen()));
          },
          child: const Text(
            " Sign In",
            style: TextStyle(color: Color.fromARGB(255, 4, 72, 229), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
  
  

} 
