// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';
import 'package:flutter_application_1/api.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_core/credo_app_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_android_account/module.dart';
import 'package:flutter_android_application/module.dart';
import 'package:flutter_android_audio/module.dart';
import 'package:flutter_android_video/module.dart';
import 'package:flutter_android_images/module.dart';
import 'package:flutter_android_calendar/module.dart';
import 'package:flutter_android_contact/module.dart';
import 'package:flutter_android_iovation/module.dart';
import 'package:flutter_android_sms/module.dart';

import 'package:flutter_ios_contact/module.dart';
import 'package:flutter_ios_calendar_reminders/module.dart';
import 'package:flutter_ios_calendar_events/module.dart';
import 'package:flutter_ios_music/module.dart';
import 'package:flutter_ios_media/module.dart';
import 'package:flutter_ios_iovation/module.dart';

void main() {
  runApp(const MyApp());
}

Map<String, dynamic> _auth = {
  "authKey": "",
  "referenceNumber": '',
  "uploadDate": '',
  "source": '',
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', auth: _auth),
    );
  }
}
