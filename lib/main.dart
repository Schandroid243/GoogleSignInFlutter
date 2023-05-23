import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';


void main() {
  runApp(MyApp());
}
// ignore: constant_identifier_names
const GOOGLE_CLIENT_DEV_KEY = '908020662248-4avibqhg0tk2eledufh7jokj8thhtjgn.apps.googleusercontent.com';
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: GOOGLE_CLIENT_DEV_KEY,
  serverClientId: GOOGLE_CLIENT_DEV_KEY
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Auth Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Google Auth Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isSignedIn = false;

  

  void _signIn() async {
  try {
    GoogleSignInAccount? account = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account!.authentication;
    String? idToken = authentication.idToken;
    //String? idToken = authentication.accessToken;
    print("The token is: $idToken");
    // Send the token to the server
    // Make an HTTP POST request to your backend endpoint '/api/google-auth'
    // Pass the idToken as a parameter in the request body
    final msg = jsonEncode({'token': idToken});
    print('The body is: $msg');
    var response = await http.post(
      Uri.parse('http://192.168.18.13:3000/api/google-auth'),
      headers: {
          'Content-Type': 'application/json', 
        }, // Replace with your backend endpoint URL
      body: msg,
    );

    if (response.statusCode == 200) {
      // Authentication successful
      print('Successfully authenticated response: ${response.body}');
      setState(() {
        _isSignedIn = true;
      });
    } else {
      // Authentication failed
      print('Authentication failed. Server response: ${response.body}');
    }
  } catch (error) {
    print('Error signing in: $error');
  }
}

  void _signOut() async {
    await _googleSignIn.signOut();
    setState(() {
      _isSignedIn = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _isSignedIn = account != null;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _isSignedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'You are signed in!',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: const Text('Sign Out'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _signIn,
                child: const Text('Sign In with Google'),
              ),
      ),
    );
  }
}

/* class MyApp extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Successfully signed in, handle the user data
        // You can send the googleUser.idToken to your Express.js server for further authentication and authorization
        print('Signed in: ${googleUser.email}');
        final ggAuth = await googleUser.authentication;
        final String? idToken = ggAuth.accessToken; 
        print('token: $idToken');
        await sendIdTokenToServer(idToken!);
      } else {
        // User canceled the sign-in process
        print('Sign-in canceled');
      }
    } catch (error) {
      // Handle sign-in errors
      print('Error signing in: $error');
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  Future<void> sendIdTokenToServer(String idToken) async {
    final Uri url = Uri.parse('http://192.168.18.13:3000/verifyToken');
    var token = jsonEncode(idToken);
    final response = await http.post(
      url,
      headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      body: token,
    );
    
    if (response.statusCode == 200) {
      // Token sent successfully
      print('Token sent to server');
    } else {
      // Error sending token to server
      print('Error sending token to server');
    }
    print('${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign-In'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _handleSignIn,
                child: const Text('Sign In with Google'),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: _handleSignOut,
                child: const Text('Sign Out with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
