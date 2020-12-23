import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
//could not get dependencies for this package due to the SDK version
//import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:reddit_client/detail.dart';
import 'package:reddit_client/data.dart';
import 'package:reddit_client/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]
    );
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

    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.grey[700],
          appBar: AppBar(
            title: Text('Flutter Reddit'),
            backgroundColor: Colors.deepOrangeAccent,

          ),

          body: ListView.builder(
            itemBuilder: (context, index) {
              return CustomCard(data: _notes[index]);
            },
            itemCount: _notes.length,
          )

      ),
    );
  }
}

class CustomCard extends StatelessWidget {

  final Data data;

  const CustomCard({
    @required this.data,
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(

            context,
            MaterialPageRoute(
                builder: (context) => DetailView(data: data))
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 20.0, left: 16.0, right: 16.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

          FadeInImage(
            placeholder: NetworkImage('https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg'),
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
      ),
    );
  }
}

