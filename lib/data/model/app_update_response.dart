class AppUpdateResponse {
  final bool isForceUpdate;
  final String version;
  final String releaseNotes;
  final String storeUrl;

  AppUpdateResponse({
    required this.isForceUpdate,
    required this.version,
    required this.releaseNotes,
    required this.storeUrl,
  });
}