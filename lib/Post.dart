import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Post extends StatefulWidget {

  final String id;
  final String userId;
  final String picUrl;
  final String postUsername;
  final String profilePicture;
  final List<String>? userLikes;
  bool like = false;

  Post({super.key, required this.id, required this.userId,  required this.picUrl, required this.userLikes,
        required this.postUsername,required this.profilePicture});

  Post.fromJson(Map<String, dynamic> json, {super.key})
    : id = json['post_id'].toString(),
      userId = json['post_details']['user_id'].toString(),
      picUrl = json['post_details']['url'].toString(),
      userLikes = json['post_details']['likes'],
      postUsername = json['user_details']['username'],
      profilePicture = json['user_details']['profile_picture'];

  Future<String> insertLike() async
  {
    var url = Uri.http('192.168.1.132:3000', '/like', {"userId":userId,"postId":id});
    var response = await http.post(url);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return response.body;
    } else {
      if (response.body.contains("post_id_1_user_id_1"))
      {
        print("Like already inserted");
      }
      return "";
    }
  }

  @override
  State<Post> createState() => _PostState();
}


class _PostState extends State<Post> {  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 10, right: 10),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Row(
              spacing: 10,
              children: [
                //Text('Post ID: ${widget.id}'),
                Container(
                    padding: EdgeInsets.all(5), // Border width
                    decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: ClipOval(
                        child: SizedBox.fromSize(
                            size: Size.fromRadius(20), // Image radius
                            child: Image.network(widget.profilePicture, fit: BoxFit.cover),
                        ),
                    ),
                ),
                Text(widget.postUsername)
              ]
              ),
              Row(
              spacing: 2,
              children: [
                MaterialButton( 
                    child: Text("Seguir"), 
                    onPressed: () => {}
                  ),
                  IconButton(onPressed: () => {}, icon: Icon(Icons.more_vert))
                ]
              )
          ],
            ),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(widget.picUrl),
              ],
            ),
            Row(
              children: [
                // LIKE
                IconButton(
                  iconSize: 20,
                  color: widget.like ? Colors.red : null,
                  icon: widget.like ? Icon(Icons.favorite) : Icon(Icons.favorite_border_outlined),
                  onPressed:  () async {
                    await widget.insertLike();
                    setState(() {
                      widget.like = !widget.like;
                    });
                  },
                ),
                IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.comment_bank_outlined),
                  onPressed: () {
                    setState(() {
                      widget.like = !widget.like;
                    });
                  },
                ),
                IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.send_outlined),
                  onPressed: () {
                    setState(() {
                      widget.like = !widget.like;
                    });
                  },
                )
              ],
            )
            

      ],
    )
    );
  }

}