// To parse this JSON data, do
//
//     final uploadProfileImgResModel = uploadProfileImgResModelFromJson(jsonString);

import 'dart:convert';

UploadProfileImgResModel uploadProfileImgResModelFromJson(String str) => UploadProfileImgResModel.fromJson(json.decode(str));

String uploadProfileImgResModelToJson(UploadProfileImgResModel data) => json.encode(data.toJson());

class UploadProfileImgResModel {
  final bool success;
  final String message;
  final ProfileImgData? profileImgData;

  UploadProfileImgResModel({
   required this.success,
   required this.message,
    this.profileImgData,
  });

  factory UploadProfileImgResModel.fromJson(Map<String, dynamic> json) => UploadProfileImgResModel(
    success: json["success"],
    message: json["message"],
    profileImgData: json["data"] == null ? null : ProfileImgData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": profileImgData?.toJson(),
  };
}

class ProfileImgData {
  final String? image;

  ProfileImgData({
    this.image,
  });

  factory ProfileImgData.fromJson(Map<String, dynamic> json) => ProfileImgData(
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
  };
}
