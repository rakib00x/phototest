import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhotoListScreen(),
    );
  }
}

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  List<dynamic> photos = [];

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/photos');

    if (response.statusCode == 200) {
      setState(() {
        photos = json.decode(response.body);
      });
    } else {
      // Implement error handling, e.g., show a snackbar with an error message.
      print('Failed to load photos: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo List'),
      ),
      body: ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(photos[index]['title']),
            leading: Image.network(
              photos[index]['thumbnailUrl'],
              width: 50,
              height: 50,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetailScreen(photo: photos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PhotoDetailScreen extends StatelessWidget {
  final dynamic photo;

  PhotoDetailScreen({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(photo['url']),
          SizedBox(height: 20),
          Text('ID: ${photo['id']}'),
          SizedBox(height: 10),
          Text('Title: ${photo['title']}'),
        ],
      ),
    );
  }
}