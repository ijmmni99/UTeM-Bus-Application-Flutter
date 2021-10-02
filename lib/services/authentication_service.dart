import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utem_bus_app/shared/loading.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);
  CollectionReference pemandu = FirebaseFirestore.instance.collection('pemandu');
  CollectionReference pelajar = FirebaseFirestore.instance.collection('pelajar');
  bool userStatus = false;

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> checkUser() async {
    DocumentSnapshot snapshots = await pemandu.doc(_firebaseAuth.currentUser.uid).get();
    
    return snapshots.exists;
  }

  Future<String> signIn({String email, String password}) async {
    try{
      Loading();
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  Future<String> signUp({String email, String password, String staffNumber, String firstName, String lastName, String icNumber, String fonNumber, String licenseNumber, bool type}) async{
    try{

      if(type == false){
        await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        pemandu.doc(value.user.uid).set({
          "DriverID": staffNumber,
          "Email" : email,
          "FirstName" : firstName.toUpperCase(),
          "IdentityCard" : icNumber,
          "LastName" : lastName.toUpperCase(),
          "License" : licenseNumber.toUpperCase(),
          "Password" : password,
          "PhoneNumber" : fonNumber,
          "authID" : value.user.uid,
          "id" : value.user.uid
          });
        });
        return "Berjaya Mendaftar Pemandu";
      }
      else {
        await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        pelajar.doc(value.user.uid).set({
          "StudentID": staffNumber,
          "Email" : email,
          "FirstName" : firstName.toUpperCase(),
          "LastName" : lastName.toUpperCase(),
          "Faculty" : icNumber.toUpperCase(),
          "Course" : fonNumber.toUpperCase(),
          "Password" : password,
          "authID" : value.user.uid,
          "id" : value.user.uid
          });
        });
        return "Berjaya Mendaftar Pelajar";
      }
      
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> editProfile({String email, String password, String staffNumber, String firstName, String lastName, String icNumber, String fonNumber, String licenseNumber, bool type}) async{
    try{

      if(type == false){
        pemandu.doc(_firebaseAuth.currentUser.uid).set({
          "DriverID": staffNumber,
          "Email" : email,
          "FirstName" : firstName.toUpperCase(),
          "IdentityCard" : icNumber,
          "LastName" : lastName.toUpperCase(),
          "License" : licenseNumber.toUpperCase(),
          "Password" : password,
          "PhoneNumber" : fonNumber,
          "authID" : _firebaseAuth.currentUser.uid,
          "id" : _firebaseAuth.currentUser.uid
          });
        return "Berjaya Mendaftar Pemandu";
      }
      else {
        pelajar.doc(_firebaseAuth.currentUser.uid).set({
          "StudentID": staffNumber,
          "Email" : email,
          "FirstName" : firstName.toUpperCase(),
          "LastName" : lastName.toUpperCase(),
          "Faculty" : icNumber.toUpperCase(),
          "Course" : fonNumber.toUpperCase(),
          "Password" : password,
          "authID" : _firebaseAuth.currentUser.uid,
          "id" : _firebaseAuth.currentUser.uid
          });
        return "Berjaya Mendaftar Pelajar";
      }
      
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}


