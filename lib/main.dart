import 'dart:convert';
import 'package:app/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

Future<List<Post>> getPosts() async
{
  var url = Uri.http('192.168.1.132:3000', '/feed', {"userId":"69a09fba38da0ec8f9ef5f7b"});
  var response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Error al cargar los posts');
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}


class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<List<Post>>(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.hasData) {
              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  Post post = posts[index];
                  return Padding(padding: EdgeInsetsGeometry.all(10),
                    child: post
                  );
                },
              );
            }

            return const Text("Sin datos");
          },
        ),
        ),
      ),
    );
  }
}
