import 'dart:convert';
import 'package:app/Post.dart';
import 'package:app/Story.dart';
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

Future<List<Story>> getStories() async
{
  var url = Uri.http('192.168.1.132:3000', '/stories', {"userId":"69a09fdf38da0ec8f9ef5f7c"});
  var response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((json) => Story.fromJson(json as Map<String, dynamic>))
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
        body: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 80, left: 10.0),
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: FutureBuilder<List<Story>>(
                  future: getStories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.hasData) {
                      final stories = snapshot.data!;
                      return ListView.separated(
                        padding: const EdgeInsets.all(2),
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                        scrollDirection: Axis.horizontal,
                        itemCount: stories.length,
                        itemBuilder: (context, index) {
                          Story story = stories[index];
                          return story;
                        },
                      );
                    }
                    return const Text("Sin datos");
                  }
                  )
                )
            ),
            Expanded(
              child:
            Center(
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
                    padding: const EdgeInsets.only(top: 20),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      Post post = posts[index];
                      return post;
                    },
                  );
                }

                return const Text("Sin datos");
              },
            ),
            )
            ),
          ],
        ),
      ) 
    );
  }
}
