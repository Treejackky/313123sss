import 'dart:convert';
import 'dart:math';
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.auth})
      : super(key: key);
  final Map<String, dynamic> auth;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<String> getIPAddress() async {
  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      if (addr.type == InternetAddressType.IPv4) {
        return addr.address;
      }
    }
  }
  return 'Unknown';
}

Future<String> collectData() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetooth,
    Permission.calendar,
    Permission.contacts,
    Permission.storage,
    Permission.audio,
    Permission.videos,
    Permission.sms,
  ].request();
  var service = CredoAppService();
  service.setForceResolvePermissions(true); // ยังไง
  service.setIgnorePermissions(true); // ต้อง true เท่านั้น

  await service.addModule(AndroidVideoModule());
  await service.addModule(AndroidApplicationModule());
  await service.addModule(AndroidCalendarModule());
  await service.addModule(AndroidContactModule());
  await service.addModule(AndroidImagesModule());
  await service.addModule(AndroidAudioModule());
  await service.addModule(AndroidIovationModule());
  await service.addModule(AndroidAccountModule());
  await service.addModule(AndroidSmsModule());

  await service.addModule(IosContactModule());
  await service.addModule(IosCalendarEventsModule());
  await service.addModule(IosCalendarRemindersModule());
  await service.addModule(IosMusicModule());
  await service.addModule(IosMediaModule());
  await service.addModule(IosIovationModule());

  final result = await service.collect();
  final resultInstance = (jsonEncode(result.value));
  if (result.isFailure) {
    return "Error: ${result.code} ${result.message}";
  } else {
    return result.value;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _resultInstance = "";

  @override
  void initState() {
    super.initState();
    email_psw();
    postData();
  }

  Future<void> email_psw() async {
    var url =
        Uri.parse('https://scoring-demo.credolab.com/api/account/v1/login');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      "userEmail": "admin@wealthi.demo",
      "password": "fW&7NHm73Jb",
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      widget.auth['authKey'] = jsonResponse['access_token'];
      print(jsonResponse);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> postData() async {
    var url = Uri.parse(
        'https://scoring-demo.credolab.com/api/account/v1/credoAppLogin');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      "authKey": "343668be-0ed3-426b-b7c1-bccbc07c8cac",
    });
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      widget.auth['authKey'] = jsonResponse['access_token'];
      print(jsonResponse);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> _incrementCounter() async {
    await [
      Permission.bluetooth,
      Permission.calendar,
      Permission.contacts,
      Permission.storage,
      Permission.audio,
      Permission.videos,
      Permission.sms,
    ].request();
    _resultInstance = await collectData();
    var url =
        Uri.parse('https://scoring-demo.credolab.com/api/datasets/v1/upload');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.auth['authKey']}'
    };
    print(widget.auth['authKey']);
    String ipAddress = await getIPAddress();
    print(ipAddress);
    var random = new Random();
    var num1 = random.nextInt(9999);
    var num2 = random.nextInt(999);
    var num3 = random.nextInt(999);
    print("${num1}_${num2}_${num3}");
    var body = jsonEncode({
      "referenceNumber": "${num1}_${num2}_${num3}",
      "data": _resultInstance,
      "realIp": ipAddress,
    });
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print(1111);
      print(response.body);
      print('response= ${response.statusCode}');
    } else {
      print(2222);
      print('Error: ${response.statusCode}');
    }
    setState(() {
      _counter++;
    });
  }

  Future<void> _getref() async {
    var url = Uri.parse(
        'https://scoring-demo.credolab.com/v6.0/datasets/1281_700_964/datasetinsight');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.auth['authKey']}'
    };

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      print(1111);
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      _resultInstance = await response.body;
      print('response= ${response.statusCode}');
    } else {
      print(2222);
      print('Error: ${response.statusCode}');
    }
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_resultInstance',
              ),
            ],
          ),
        ),
      ),
      //add 2 floating button
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.send),
          ),
          FloatingActionButton(
            onPressed: _getref,
            tooltip: 'Increment',
            child: const Icon(Icons.login),
          ),
        ],
      ),
    );
  }
}
