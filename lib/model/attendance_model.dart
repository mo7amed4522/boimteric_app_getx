class BxUserCheckInResponse {
  final bool success;
  final int attendanceId;
  final String message;
  final String checkIn;
  final String location;

  BxUserCheckInResponse({
    required this.success,
    required this.attendanceId,
    required this.message,
    required this.checkIn,
    required this.location,
  });

  // Get message from either 'message' or 'error' field

  factory BxUserCheckInResponse.fromJson(Map<String, dynamic> json) {
    return BxUserCheckInResponse(
      success: json['success'] ?? false,
      attendanceId: json['attendance_id'],
      message: json['message'],
      checkIn: json['check_in'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['attendance_id'] = attendanceId;
    data['message'] = message;
    data['check_in'] = checkIn;
    data['location'] = location;
    return data;
  }
}

class BxUserCheckOutResponse {
  final bool success;
  final int attendanceId;
  final String message;
  final String checkOut;
  final String location;

  BxUserCheckOutResponse({
    required this.success,
    required this.attendanceId,
    required this.message,
    required this.checkOut,
    required this.location,
  });

  factory BxUserCheckOutResponse.fromJson(Map<String, dynamic> json) {
    return BxUserCheckOutResponse(
      success: json['success'] ?? false,
      attendanceId: json['attendance_id'],
      message: json['message'],
      checkOut: json['check_out'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['attendance_id'] = attendanceId;
    data['message'] = message;
    data['check_out'] = checkOut;
    data['location'] = location;
    return data;
  }
}
