
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project_at_etec/util/colors_util.dart';

import 'signin_screen.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('users').snapshots();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const Text('Read and Write '),
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
          padding:const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
                const Text('Read Data from Cloud Firebase',
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                ),
                Container(
                  height: 300.0,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child:StreamBuilder<QuerySnapshot>(
                    stream: users,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot>snapshot,
                    ){
                      if(snapshot.hasError){
                        return const Text('something went wrong');
                      }
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const Text('loading');
                      }
                      final data = snapshot.requireData;
                      return ListView.builder(
                        itemCount: data.size,
                        itemBuilder:(context,index){
                          return  Text('My Name is ${data.docs[index]['name']} and I am ${data.docs[index]['age']} Years old');
                        }
                      );
                    },
                  ),
                ),
                const Text('Write Data to Cloud Firestore',
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                  ),
                const MyCustomForm(),
              ] 
            ), 
          ),
        ),
      ),
    );
  }
} 
class  MyCustomForm extends StatefulWidget {
  const  MyCustomForm({Key? key}) : super(key: key);

  @override
  State< MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State< MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  var name ='';
  var age =0;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users'); 
    return Form(
      key: _formKey,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'What is your name?',
                labelText: 'Name',
            ),
            onChanged: ((value) {
              name = value;
            }),
            validator: (value) {
              if(value==null||value.isEmpty){
                return 'Please Enter Your Name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'How Many Years Old?',
                labelText: 'Age',
            ),
            onChanged: ((value) {
              age = int.parse(value);
            }),
            validator: (value) {
              if(value==null||value.isEmpty){
                return 'Please Enter Your Age';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                         content:Text('Sending Data to Cloud Firestore'),
                        ),
                      );
                      users
                       .add({'name':name,'age':age})
                       .then((value) => debugPrint('user added'))
                       .catchError((error)=>debugPrint('false to add user:$error'));
                    }
                  },
                  child:const Text('submit'),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      debugPrint("Signed Out");
                      Navigator.push(context,
                       MaterialPageRoute(builder: (context) => const SignInScreen()));
                    });
                  },
                  child: const Text("Logout"),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}