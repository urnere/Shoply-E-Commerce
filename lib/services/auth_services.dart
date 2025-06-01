import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserCredential> loginWithGoogle() async {
    try {
       final googleUser = await GoogleSignIn().signIn();
       final googleAuth = await googleUser?.authentication;
       final credential = GoogleAuthProvider.credential(
         accessToken: googleAuth?.accessToken,
         idToken: googleAuth?.idToken,
       );

       return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Google ile giriş başarısız: $e');
      
    }
  }
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      throw Exception('Çıkış yaparken hata: $e');
    }
  }
}