import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  void init(
      {required Function(Map<String, dynamic> data) onInitMessage,
      required Function(Map<String, dynamic> data) onBackgroundMessage,
      required Function(Map<String, dynamic> data) onLocalNotiMessage,
      required Function(Map<String, dynamic> data) onForeGroundMessage}) async {
    await _initLocalNotificationListener(
        onForeGroundMessage: onLocalNotiMessage);
    if (Platform.isIOS) {
      await _setupIosNotification();
    }
    //when app killed
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        onInitMessage(message.data);
      }
    });

    //when app on background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      onBackgroundMessage(message.data);
    });

    //when app on foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      onForeGroundMessage(message.data);
      final isAndroid = message.notification?.android;
      if (notification != null && isAndroid != null) {
        _showLocalNotification(message);
      }
    });
  }

  Future<void> unRegister() async {
    return await FirebaseMessaging.instance.deleteToken();
  }

  Future<void> _initLocalNotificationListener(
      {required Function(Map<String, dynamic> data)
          onForeGroundMessage}) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    await FlutterLocalNotificationsPlugin().initialize(initSettings,
        onSelectNotification: (payload) async {
      onForeGroundMessage(json.decode(payload!));
      return null;
    });
  }

  void _showLocalNotification(RemoteMessage message) async {
    await FlutterLocalNotificationsPlugin().show(
      message.notification?.hashCode ?? 0,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          // 'channelDescription',
          icon: '@mipmap/ic_launcher',
          importance: Importance.max, priority: Priority.high,
        ),
      ),
      payload: json.encode(message.data),
    );
  }

  Future<void> _setupIosNotification() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> sendNotification(String subject, {String? title}) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final topic = "new_task";
    String toParams = "/topics/" + topic;
    // final token = await FirebaseMessaging.instance.getToken();

    final data = {
      "notification": {"body": subject, "title": title ?? "NID"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "sound": 'default',
        "screen": "new task",
      },
      "to": toParams,
    };
    // print(token);

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAADG8gLdg:APA91bHdJyYgIBbiPPjMKIMZgdWx8-ZyIQxKNxmrsDw9yig4ysgIjrdtw415eoxSy1ZgoaI1lIIeUsODkOfFcuCxJtbNU9RuaeSFLt5CJOu5J3F7FDojoQVhe19hWKXLK4b1xLnjoKAk'
    };

    await Dio().post(
      postUrl,
      data: json.encode(data),
      options: Options(headers: headers),
    );
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Future<String?> get token async =>
      await FirebaseMessaging.instance.getToken();

  static NotificationHelper? _instance;

  factory NotificationHelper() {
    _instance ??= NotificationHelper._internal();
    return _instance!;
  }

  NotificationHelper._internal();
}
