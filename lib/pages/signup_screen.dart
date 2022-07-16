
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../util/colors_util.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController userNameTextController = TextEditingController();
  bool isPassword = true;
  void onListen(){
    return setState(() {
      
    });
  }
  @override
  void initState() {
    super.initState();
    passwordTextController.addListener(onListen);
    emailTextController.addListener(onListen);
    userNameTextController.addListener(onListen);
  }
  @override
  void dispose() {
    super.dispose();
    passwordTextController.removeListener(onListen);
    emailTextController.removeListener(onListen);
    userNameTextController.removeListener(onListen);
  }
  
  Future signUP() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      )
          .then((value) async {
        showDialog(
          context: context,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
      });
    } on FirebaseAuthException catch (erro) {
      if (erro.code == 'weak-password') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Weak password')));
      } else if (erro.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('The account already exists for that email.'),
            ),
          );
      }
    } catch (erro) {
      debugPrint(erro.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            )),
          child: SingleChildScrollView(
            child: Padding(
             padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
             child: Column(
              children: <Widget>[
                logoWidget('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2s62ladt6F75ss9x_LHrUiMvt03Kker72og&usqp=CAU'),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  userNameTextController
                ),
                const SizedBox(
                  height: 10,
                ),
                reusableTextField(
                  "Enter Email Id",
                  Icons.person_outline,
                  false,
                  emailTextController
                ),
                const SizedBox(
                  height: 10,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  passwordTextController
                ),
                const SizedBox(
                  height: 0.0,
                ),
                signInUPButton(
                  context,
                  false,
                  (){
                   signUP();
                }),
              ],
            ),
          ))),
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
}