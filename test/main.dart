import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../lib/data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _url = 'https://www.reddit.com/r/all.json';
  List<Data> _notes = List<Data>();

  Future<List<Data>> fetchNotes() async { // future function produces result which can be either error or potential value
    List<Data> notes = List<Data>();

    //get Jsondata from URL
    var response = await http.get(_url);

    //if sucessfully get json from url, decode it.
    if (response.statusCode == 200) {
      //decode Json data, and store in variable.
      var notesJson = json.decode(response.body);
      //extract children Array from data;
      var children = notesJson['data']['children'];
      //Add Data class thorugh loop
      for (var child in children) {
        notes.add(Data.fromJson(child));
      }
    } else {
      print('Fail to fetch Json.');
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          title: Text('Flutter Reddit'),
          backgroundColor: Colors.deepOrangeAccent,
        ),

        //body: ListView.builder(
          body: GridView.count(
            crossAxisCount: 1,
              children: List.generate(_notes.length, (index) {
                return Stack(
                          children: <Widget>[
                            Column (
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  FadeInImage(
                                    placeholder: NetworkImage('https://lh3.googleusercontent.com/proxy/H36rriOMHx83cOzfIp2zGwS_V3E91UZCRKdrjAXAxT4rq3zMVXApWwIr1g9NIbMgJ20yYOVTuAnjJPL7NCFmwX0Naaqt79Kfw-0pRoNB9ch3hWaqdYNm6AsOx_gHFqjPNxBHUEnen3EbfUbETQ'),
                                    image: new NetworkImage(_notes[index].thumbnailUrl),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ]
                            ),

                               Text(
                                  _notes[index].title,
                                  style: TextStyle(
                                      fontSize: 10,
                                      backgroundColor: Colors.white,
                                      fontWeight: FontWeight.bold),
                                    ),


                              Text(
                                _notes[index].author,
                                style: TextStyle(
                                    fontSize: 15,
                                    backgroundColor: Colors.white,
                                    color: Colors.grey.shade600

                              ),
                            ),
                          ],
                    );
          },
          )

        )
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    @required this.data,
    Key key,
  }) : super(key: key);
  final Data data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 20.0, left: 16.0, right: 16.0
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            FadeInImage(
              placeholder: NetworkImage('https://lh3.googleusercontent.com/proxy/H36rriOMHx83cOzfIp2zGwS_V3E91UZCRKdrjAXAxT4rq3zMVXApWwIr1g9NIbMgJ20yYOVTuAnjJPL7NCFmwX0Naaqt79Kfw-0pRoNB9ch3hWaqdYNm6AsOx_gHFqjPNxBHUEnen3EbfUbETQ'),
              image: new NetworkImage(data.thumbnailUrl),
              fit: BoxFit.fitWidth,
            ),

            SizedBox(height: 10),

            Text(
              data.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              data.author,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

