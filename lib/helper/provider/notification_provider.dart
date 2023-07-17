import 'dart:async';

import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  final _notificationList = [];
  get notificationList => _notificationList;

  showNotification({type = 0, required message}) {
    _notificationList.add(notification(message: message, type: type));
    notifyListeners();
    Timer(const Duration(seconds: 5), () {
      _notificationList.removeAt(0);
      notifyListeners();
    });
  }

  Widget notification({type = 0, String? message}) {
    IconData icon = type == 0
        ? Icons.done_outline_sharp
        : type == 1
            ? Icons.error_outline_sharp
            : Icons.help_outline_sharp;
    MaterialColor color = type == 0
        ? Colors.green
        : type == 1
            ? Colors.orange
            : Colors.red;
    return Container(
      height: 80,
      width: 350,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Icon(
            icon,
            color: color,
            size: 45,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
