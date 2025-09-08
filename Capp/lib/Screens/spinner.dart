
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Platform.isIOS
            ? const CupertinoActivityIndicator(radius: 16) 
            : const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), 
              ),
      ),
    );
  }
}
