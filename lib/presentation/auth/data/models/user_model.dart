class UserModel {
  final int adminuserid;
  final int employeeType;
  final String employeeTypeName;
  final int empoloyeeid;
  final int companyid;
  final int departmentid;

  final String namebangla;
  final String nameenglish;
  final String email;
  final String username;
  final String companyName;
  final String departmentname;
  final String designationname;
  final String joiningdate;
  final String mobile;
  final String image;

  // live tracking related fields
  final int isGpsTrackingMe;
  final String trackingFormTime; // String
  final String trackingToTime;
  final int isEmployeeTracking;
  final int apiCallingTime;

  UserModel({
    required this.adminuserid,
    required this.employeeType,
    required this.employeeTypeName,
    required this.empoloyeeid,
    required this.companyid,
    required this.departmentid,

    required this.namebangla,
    required this.nameenglish,
    required this.email,
    required this.username,
    required this.companyName,
    required this.departmentname,
    required this.designationname,
    required this.joiningdate,
    required this.mobile,
    required this.image,

    required this.isGpsTrackingMe,
    required this.trackingFormTime,
    required this.trackingToTime,
    required this.isEmployeeTracking,
    required this.apiCallingTime,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      adminuserid: int.tryParse(jsonData["adminuserid"].toString()) ?? 0,
      employeeType: int.tryParse(jsonData["employee_type"].toString()) ?? 0,
      employeeTypeName: jsonData["employee_type_name"]?.toString() ?? "",
      empoloyeeid: int.tryParse(jsonData["emp_id"].toString()) ?? 0,
      companyid: int.tryParse(jsonData["company_id"].toString()) ?? 0,
      departmentid: int.tryParse(jsonData["department_id"].toString()) ?? 0,
      namebangla: jsonData["name_bn"].toString(),
      nameenglish: jsonData["name_en"]?.toString() ?? "",
      email: jsonData["email"]?.toString() ?? "",
      username: jsonData["username"]?.toString() ?? "",
      companyName: jsonData["companyName"]?.toString() ?? "",
      departmentname: jsonData["department"]?.toString() ?? "",
      designationname: jsonData["designation"]?.toString() ?? "",
      joiningdate: jsonData["joining_date"]?.toString() ?? "",
      mobile: jsonData["mobile"]?.toString() ?? "",
      image: jsonData['image'] != null
          ? jsonData['image'].toString().replaceAll(
              "storageimages",
              "storage/images",
            )
          : '',

      isGpsTrackingMe:
          int.tryParse(jsonData["is_gps_tracking_me"].toString()) ?? 0,
      trackingFormTime: jsonData["tracking_form_time"]?.toString() ?? "",
      trackingToTime: jsonData["tracking_to_time"]?.toString() ?? "",
      isEmployeeTracking:
          int.tryParse(jsonData["is_employee_tracking"].toString()) ?? 0,
      apiCallingTime:
          int.tryParse(jsonData["api_calling_time"].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "adminuserid": adminuserid,
      "employee_type": employeeType,
      "employee_type_name": employeeTypeName,
      "emp_id": empoloyeeid,
      "company_id": companyid,
      "department_id": departmentid,
      "name_bn": namebangla,
      "name_en": nameenglish,
      "email": email,
      "username": username,
      "companyName": companyName,
      "department": departmentname,
      "designation": designationname,
      "joining_date": joiningdate,
      "mobile": mobile,
      "image": image,
      "is_gps_tracking_me": isGpsTrackingMe,
      "tracking_form_time": trackingFormTime,
      "tracking_to_time": trackingToTime,
      "is_employee_tracking": isEmployeeTracking,
      "api_calling_time": apiCallingTime,
    };
  }
}
