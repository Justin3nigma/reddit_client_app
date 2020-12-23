import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:reddit_client/homepage.dart';

void main(){
  runApp(Login());
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: LoginPage(),
      
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController etUsername = new TextEditingController();
  String nUsername = "";
  //final myController = TextEditingController();
  ProgressDialog progressDialog; //progress dialog

  @override
  Widget build(BuildContext context) {
    progressDialog =  ProgressDialog(
      context,
      textDirection: TextDirection.rtl,
      isDismissible: true,
    );

    progressDialog.style(
      message: 'In Progress',
      progressWidget: CircularProgressIndicator(),
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );

    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Builder(
        builder:(context)=> SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            children: <Widget>[
              Column(
              children: <Widget>[
              SizedBox(height: 120.0,),
                Image.asset('assets/logo.png'),
                SizedBox(height: 10.0,),
                Text('client',
                style: TextStyle(
                    fontSize: 30.0,
                    letterSpacing: 5.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                ),
                ),
               ],
              ),
              SizedBox(height: 100.0,),

              Text('Only user names consisting of 20 alphabets are allowed.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.deepOrange,
                ),
              ),

              Form(
                key: _formkey,
                child: Column(
                  children:<Widget>[
                    TextFormField(
                      controller: etUsername,
                      //controller: myController,
                      decoration: InputDecoration(
                          labelText: 'username'
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      ],
                      validator: (value){
                        if (value.isEmpty){
                          return 'Please Enter Your Username';
                        }
                        else if(value.length > 20){
                          return 'Length of your username cannot be longer than 20 digits';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),

              SizedBox(height: 80.0,),
              Column(
                children: <Widget>[
                  ButtonTheme(
                    height: 50,
                    disabledColor: Colors.deepOrange,
                    child: RaisedButton(
                      disabledElevation: 4.0,
                      onPressed:(){
                        print(etUsername);
                        //print(myController);
                        if(_formkey.currentState.validate()) {
                         progressDialog.show();
                        }

                        Future.delayed(Duration(seconds: 4)).then((value){
                          progressDialog.hide();
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => MyApp()
                          ));
                        });

                        /*
                        //Even if the process is completed, Progress Dialog still remains before tap
                        progressDialog.hide().whenComplete(() {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => MyApp()
                          ));
                        });*/

                      },
                      child: Text('Login',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
