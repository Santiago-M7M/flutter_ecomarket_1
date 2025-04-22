import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSignInProvider {
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Cierra sesión previa para que se muestre el selector de cuentas
      await GoogleSignIn().signOut();

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      // Guardar en Firestore si es nuevo
      final usersRef = FirebaseFirestore.instance.collection('users');
      final existingUser = await usersRef.doc(user!.uid).get();

      if (!existingUser.exists) {
        await usersRef.doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? 'Sin nombre',
          'email': user.email ?? 'Sin email',
          'paymentMethod': 'Google',
        });
      }

      return userCredential;
    } catch (e) {
      print("Error al iniciar sesión con Google: $e");
      return null;
    }
  }
}
