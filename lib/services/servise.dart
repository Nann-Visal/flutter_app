import 'package:http/http.dart';

import '../models/post.dart';

class Sevise {
  // ignore: body_might_complete_normally_nullable
  Future <List<Post>?> getPost() async{
    Client http = Client();
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    var response = await http.get(uri);
      if(response.statusCode==200){
        var json = response.body;
        return postFromJson(json);
      }else{
        return null;
      }
  }
}