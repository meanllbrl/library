import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:mean_lib/logger.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationHandler {
  final flutterLocalNotificationsPlugin;

  LocalNotificationHandler(this.flutterLocalNotificationsPlugin);
  static init() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    return InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  Future<void> scheduleDailyNotification(
      {hour,
      minute,
      required String image,
      required int id,
      required String title,
      required String desc,
      Color? backgroundColor}) async {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    tz.TZDateTime _nextInstanceOfHour(hour, minute) {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    }

    var androidBildirim = AndroidNotificationDetails(
      "notification",
      "Remember",
      icon: "ic_launcher",
      largeIcon: DrawableResourceAndroidBitmap(image),
      playSound: true,
      color: backgroundColor ?? Colors.white,
      enableLights: true,
      enableVibration: true,
      importance: Importance.high,
      styleInformation: const BigTextStyleInformation(''),
      priority: Priority.high,
    );
    var iosBildirim = IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    var platformSpecific =
        NotificationDetails(android: androidBildirim, iOS: iosBildirim);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, desc, _nextInstanceOfHour(hour, minute), platformSpecific,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static tz.TZDateTime _nextInstanceOfClock(
      int hour, int minute, currentTimeZone) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfWeekDay(
      {required int weekDay,
      required int hour,
      required int min,
      required currnetTimeZone}) {
    tz.TZDateTime scheduledDate =
        _nextInstanceOfClock(hour, min, currnetTimeZone);
    while (scheduledDate.weekday != weekDay) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  cancelNotification(NotificationModel not) {
    for (var i = 1; i < 4; i++) {
      flutterLocalNotificationsPlugin.cancel((not.id + i.toString()).hashCode);
    }
  }

  Future<void> createReminder(
      {required NotificationModel reminder, required currentTimeZone}) async {
    try {
      flutterLocalNotificationsPlugin.cancelAll();
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      log(reminder.id);
      DateTime now = DateTime.now();
      DateTime notDate =
          DateTime.fromMillisecondsSinceEpoch(reminder.millisecondsEach);
      if (notDate.compareTo(now) > 0) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            (reminder.id).hashCode,
            reminder.title,
            reminder.desc,
            tz.TZDateTime(tz.getLocation(currentTimeZone), notDate.year,
                notDate.month, notDate.day, notDate.hour, notDate.minute),
            NotificationDetails(
              android: AndroidNotificationDetails(
                '${reminder.id}',
                'Kidvo Reminder',
                channelDescription: 'Hatırlatma işlemi gerçekleştiriliyor.',
                color: Colors.white,
                fullScreenIntent: false,
                largeIcon: const DrawableResourceAndroidBitmap("logo"),
                playSound: true,
                priority: Priority.high,
                importance: Importance.max,
                styleInformation: const BigTextStyleInformation(''),
                enableVibration: true,
                autoCancel: true,
              ),
              iOS: IOSNotificationDetails(
                  presentAlert: true, presentBadge: true, presentSound: true),
            ),
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
            androidAllowWhileIdle: true);
      }

      log(
        "Başlık ${reminder.title} ${notDate.hour}:${notDate.minute}  Bildirim Oluşturuldu",
      );
    } catch (e) {
      log("createReminder HATA ");
      Logger.error(e.toString());
    }
  }

  void scheduledNot({
    required int id,
    required Duration duration,
    required String desc,
    required String title,
    Color? backgroundColor,
  }) async {
    var bildirimZaman = DateTime.now().add(duration);
    var androidBildirim = AndroidNotificationDetails(
      "Alartm id",
      "alarm ismi",
      icon: "ic_launcher",
      color: backgroundColor ?? Colors.white,
      fullScreenIntent: true,
      subText: desc,
      largeIcon: const DrawableResourceAndroidBitmap("logo"),
      playSound: true,
      priority: Priority.high,
      importance: Importance.max,
      enableVibration: true,
      autoCancel: true,
    );
    var iosBildirim = const IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    var platformSpecific =
        NotificationDetails(android: androidBildirim, iOS: iosBildirim);
    await flutterLocalNotificationsPlugin.schedule(
        id, title, desc, bildirimZaman, platformSpecific);
  }
}

class NotificationModel {
  final int millisecondsEach;
  final String title;
  final String desc;
  final String id;
  final DateTime createdAt;
  NotificationModel(
      {required this.id,
      required this.createdAt,
      required this.millisecondsEach,
      required this.title,
      required this.desc});
}
