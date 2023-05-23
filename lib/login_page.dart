// ignore_for_file: prefer_function_declarations_over_variables, avoid_print, sort_child_properties_last, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veli_bilgilendirme_yeni/database_service.dart';

class PhoneLoginPage extends StatefulWidget {
  @override
  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  String _verificationId = "";

  Future<void> _verifyPhone() async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      FirebaseAuth.instance.signInWithCredential(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceCodeResend]) {
      _verificationId = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      _verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        timeout: const Duration(seconds: 90),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  Future<void> _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _codeController.text,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _checkPhoneNumber(String phoneNumber) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    final QuerySnapshot snapshot =
        await usersCollection.where('phone', isEqualTo: phoneNumber).get();

    if (snapshot.docs.isNotEmpty) {
      final String id = snapshot.docs.first.id;
      Database.userIDSave(id);

      _verifyPhone();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration: InputDecoration(
                    hintText: '+90 ekleyerek numaranızı giriniz.'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Numarayı Kontrol Et'),
                onPressed: () => _checkPhoneNumber(_phoneController.text),
              ),
              SizedBox(height: 32),
              TextField(
                keyboardType: TextInputType.phone,
                controller: _codeController,
                decoration:
                    InputDecoration(hintText: 'Güvenlik kodunu giriniz.'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Kodu Kontrol Et'),
                onPressed: _signInWithPhoneNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
