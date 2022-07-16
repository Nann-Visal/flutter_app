import 'package:flutter/material.dart';
import 'package:flutter_final_project_at_etec/services/servise.dart';

import '../models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post>? postList;
  late  bool isloaded = false;
  getPost()async{
    postList = await Sevise().getPost();
    if(postList != null){
      setState(() {
        isloaded = true;
      });
    }
  }
  @override
  void initState() {
    getPost();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title:const Text('HomePage'),
        ),
        body:Visibility(
            visible: isloaded,
            // ignore: sort_child_properties_last
            child: ListView.builder(
              itemCount: postList!.length,
              itemBuilder: ((context, index) {
               var data = postList![index];
               return   ListTile(
                 leading: CircleAvatar(
                   child:Text(data.id.toString())
                 ),
                 title:Text(data.title),
                 subtitle: Text(data.body),
                 trailing: Text(data.userId.toString()),
               );
            })),
            replacement:const Center(
              child: CircularProgressIndicator(),
            ),
        ),
    );
  }
}

