import 'package:flutter/material.dart';
import 'package:flutter_final_project_at_etec/util/colors_util.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class GoogleSignINScreen extends StatefulWidget {
  const GoogleSignINScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignINScreen> createState() => _GoogleSignINScreenState();
}
GoogleSignInAccount? _currentUser;
String contactText = '';
GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

class _GoogleSignINScreenState extends State<GoogleSignINScreen> {
  
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      debugPrint('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        contactText = 'I see you know $namedContact!';
      } else {
        contactText = 'No contacts to display.';
      }
    });
  }

  String? pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      debugPrint('$error');
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();

  
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
                logoWidget('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFPV7WsVNOFL4_1CVRakSxUFW7TC26PXjWHw&usqp=CAU'),
                const SizedBox(
                  height: 30.0,
                ),
               builGooglSignInOption(),
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
      width: 400.0,
      height: 400.0,
    );
  }
 
  Widget builGooglSignInOption(){
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
        child:Column(
          children: [
            ElevatedButton(
              onPressed: ()=>handleSignOut,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(35, 0, 0, 0);
                  }
                  return const Color.fromARGB(139, 255, 255, 255);
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: const Text(
                'Sign Out',
                style:  TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed:() => handleGetContact(user),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(35, 0, 0, 0);
                  }
                  return const Color.fromARGB(139, 255, 255, 255);
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: const Text(
                'Refresh',
                style:  TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ],
        ),
      );
    } else {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
          child:ElevatedButton(
              onPressed:handleSignIn,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(35, 0, 0, 0);
                  }
                  return const Color.fromARGB(139, 255, 255, 255);
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: const Text(
                'Sign In',
                style:  TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
       );
    }
  }
}



          