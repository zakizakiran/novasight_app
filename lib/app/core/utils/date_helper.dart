import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../styles/colors/color_constant.dart';
import 'snackbar_helper.dart';

class DateHelper {
  static String dateFormat(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }
  static String dateTimeFormat(DateTime date) {
    return DateFormat('d MMM yyyy, HH:mm:ss').format(
      date.toLocal(),
    );
  }

  static Future<void> pickDateTime(BuildContext context, bool isStart, Rx<DateTime> startTime, Rx<DateTime> endTime) async {
    final initialDate = isStart
        ? startTime.value
        : endTime.value;


    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorConstant.primary,
              onPrimary: ColorConstant.white,
              onSurface: ColorConstant.textDarkGreyColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorConstant.primary,
              onPrimary: ColorConstant.white,
              onSurface: ColorConstant.textDarkGreyColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (isStart) {
      // if (fullDateTime.isBefore(DateTime.now().subtract(const Duration(minutes: 1)))) {
      //   SnackbarHelper.showError(
      //     title: 'Perhatian',
      //     message: 'Waktu mulai tidak boleh di masa lalu.',
      //   );
      //   return;
      // }
      startTime.value = fullDateTime;
      if (endTime.value.isBefore(fullDateTime)) {
        endTime.value = fullDateTime.add(const Duration(hours: 2));
      }
    } else {
      if (fullDateTime.isBefore(startTime.value)) {
        SnackbarHelper.showError(
          title: 'Perhatian',
          message: 'Waktu selesai harus setelah waktu mulai.',
        );
        return;
      }
      endTime.value = fullDateTime;
    }
  }
}