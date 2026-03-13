import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Story extends StatefulWidget {

  final String id;
  final String userId;
  final String username;
  final String profilePicture;

  Story({super.key, required this.id, required this.userId, required this.username, required this.profilePicture});

  Story.fromJson(Map<String, dynamic> json, {super.key})
    : id = json['_id'].toString(),
      userId = json['user_id'].toString(),
      username = json['user_details']['username'].toString(),
      profilePicture = json['user_details']['profile_picture'];

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {  
  @override
  Widget build(BuildContext context) {
    return Container(
    width: 100,
    height: 100,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.pink, // borde
    ),
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(widget.profilePicture),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
  }
}