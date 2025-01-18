import 'package:flutter/material.dart';

class TimeAgo extends StatelessWidget {
  const TimeAgo(
    this.time, {
    this.style,
    super.key,
  });

  final DateTime time;
  final TextStyle? style;

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'только что';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${_pluralize(minutes, 'минуту', 'минуты', 'минут')} назад';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${_pluralize(hours, 'час', 'часа', 'часов')} назад';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${_pluralize(days, 'день', 'дня', 'дней')} назад';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${_pluralize(weeks, 'неделю', 'недели', 'недель')} назад';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${_pluralize(months, 'месяц', 'месяца', 'месяцев')} назад';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${_pluralize(years, 'год', 'года', 'лет')} назад';
    }
  }

  static String _pluralize(int number, String one, String few, String many) {
    final n = number % 100;
    if (n >= 11 && n <= 14) return many;

    switch (n % 10) {
      case 1:
        return one;
      case 2:
      case 3:
      case 4:
        return few;
      default:
        return many;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: '$time'.split('.').first,
        child: Text(
          timeAgo(time),
          style: style,
        ));
  }
}
