class Urls {
  static const _baseUrl = "https://software.digonta.space/api";

  static const loginUrl = "$_baseUrl/auth/login";
  static const updatePasswordUrl = "$_baseUrl/password/update";

  // live tracking
  static const liveTrackingUrl = "$_baseUrl/employee-live-tracking";

  // individual get api drop dwon
  static const employeefromUrl = "$_baseUrl/employees";

  // home screen
  static const savepostattendancetUrl = "$_baseUrl/attendance-store";
  static const phonebookUrl = "$_baseUrl/phone-book";
  static const jobcardUrl = "$_baseUrl/job-card";
  static const calendarUrl = "$_baseUrl/calendar";
  static const noticesUrl = "$_baseUrl/notices";
  static const noticesNotificationUrl = "$_baseUrl/notice-notifications";
  static const attendanceReportUrl = "$_baseUrl/daily-attendance-report";

  // leaveinfo
  static const leavetypefromUrl = "$_baseUrl/leave-types";
  static const leaveHistoryUrl = "$_baseUrl/leave-history";
  static const leaveBalanceUrl = "$_baseUrl/leave-balance";
  static const leaveRequestUrl = "$_baseUrl/leave-store";
  static updateleaveRequestUrl(String id) => "$_baseUrl/leave/edit/$id";
  static deleteleaveRequestUrl(String id) => "$_baseUrl/leave/delete/$id";
  static const leaveCategoryUrl = "$_baseUrl/leave-category-list";

  // visit
  static const visitcustomerUrl = "$_baseUrl/customer/store";
  static const visittranspotUrl = "$_baseUrl/vehicles";
  static const clientfromUrl = "$_baseUrl/client-list";
  static const purposefromUrl = "$_baseUrl/visit-purpose-list";
  static const visitstoreUrl = "$_baseUrl/visit/store";
  static const visitpendingUrl = "$_baseUrl/visit/pending";
  static const visithistoryUrl = "$_baseUrl/visit/history";
  static const conveyanceUrl = "$_baseUrl/conveyance-list";
  static const sentbillApprovalUrl = "$_baseUrl/send-for-approval";

  static visitUpdateUrl(String id) => "$_baseUrl/visit/update/$id";

  static visitstartUrl(String id) => "$_baseUrl/visit/start/$id";
  static visitreachUrl(String id) => "$_baseUrl/visit/reach/$id";
  static visitcompleteUrl(String id) => "$_baseUrl/visit/complete/$id";

  static const visitspotstoreUrl = "$_baseUrl/visit/spot/store";
  static visitSpotUpdateUrl(String id) => "$_baseUrl/visit/spot/update/$id";
  static visitSpotGetUrl(String id) => "$_baseUrl/visit/show/$id";
}
