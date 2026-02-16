class LoginModel {
  bool? success;
  String? token;
  int? employeeId;
  String? employeeName;
  bool? isCheckedIn;
  List<Locations>? locations;

  LoginModel({
    this.success,
    this.token,
    this.employeeId,
    this.employeeName,
    this.isCheckedIn,
    this.locations,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
    employeeId = json['employee_id'];
    employeeName = json['employee_name'];
    isCheckedIn = json['is_checked_in'];
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(Locations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['token'] = token;
    data['employee_id'] = employeeId;
    data['employee_name'] = employeeName;
    data['is_checked_in'] = isCheckedIn;
    if (locations != null) {
      data['locations'] = locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Locations {
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  int? radius;

  Locations({this.id, this.name, this.latitude, this.longitude, this.radius});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['radius'] = radius;
    return data;
  }
}
