class DocUtils {
  static bool checkIfDrivingLicense(int? docId) {
    // Big long list of driving license IDs
    List<int> licenseIds = [38, 39, 40, 41, 46, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 71, 72, 73, 74, 84, 85, 105, 107, 108, 109, 110, 112, 113, 114, 120, 126, 127, 132, 135, 136, 138, 139, 140, 148, 149, 156, 157, 158, 163, 164, 165, 169, 170, 171, 176, 187, 230, 234, 235];

    return licenseIds.contains(docId);
  }
}