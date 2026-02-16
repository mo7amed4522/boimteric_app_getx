// ignore_for_file: strict_top_level_inference

import 'package:boimteric_app_getx/core/constants/statusrequest.dart';

dynamic handlingData(response) {
  if (response is StatusRequest) {
    return response;
  } else {
    return StatusRequest.success;
  }
}
