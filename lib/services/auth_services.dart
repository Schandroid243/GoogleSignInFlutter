import 'package:google_sign_in/google_sign_in.dart';

class AuthService {


  //Google signi in

  signInWithGoogle() async {
    //begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //Obtain user information from the request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for the user
   
    //finally, let's sign in 
  }
}