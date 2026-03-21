import 'package:flutter/material.dart';
import 'package:app/Common.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Post extends StatefulWidget {

  final String id;
  final String postUserId;
  final String picUrl;
  final String postUsername;
  final String profilePicture;
  final List<dynamic>? userLikes;
  bool like = false;

  Post.fromJson(Map<String, dynamic> json, {super.key})
    : id = json['post_id'].toString(),
      postUserId = json['post_details']['user_id'].toString(),
      picUrl = json['post_details']['url'].toString(),
      userLikes = json['likes_details'],
      postUsername = json['user_details']['username'],
      profilePicture = json['user_details']['profile_picture'],
      like = (json['likes_details'] as List).any(
          (l) => l['user_id'].toString() == currentUserId);

  Future<String> insertLike() async
  {
    //TODO
    return "";
  }

  @override
  State<Post> createState() => _PostState();
}


class _PostState extends State<Post> {  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 20),
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
                    // decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
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