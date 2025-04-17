// Loge Printer
   import 'dart:developer' as dev show log;

import 'package:flutter/foundation.dart' show kDebugMode;

void logV(dynamic tag, dynamic message) {
    dev.log("Verbose =============>    $tag    <============= \n =============>\n $message \n<=============  \n ${DateTime.now()}");
  }

   void logE(dynamic tag, dynamic message, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      dev.log(
        "$tag",
        stackTrace: stackTrace,
        error: "$message",

      );
    }

    }


   void logD(dynamic tag, dynamic message) {
    if (kDebugMode) {
      dev.log("=====================> $tag <===================== \n =====================> $message <=====================");
    }
  }

   void logI(dynamic tag, dynamic message) {
    if (kDebugMode) {
      dev.log("Information \n=====================> $tag <===================== \n =====================> $message <=====================");
    }

  }