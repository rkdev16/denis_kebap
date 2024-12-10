// To parse this JSON data, do
//
//     final timeSlotsResModel = timeSlotsResModelFromJson(jsonString);

import 'dart:convert';

TimeSlotsResModel timeSlotsResModelFromJson(String str) => TimeSlotsResModel.fromJson(json.decode(str));

String timeSlotsResModelToJson(TimeSlotsResModel data) => json.encode(data.toJson());

class TimeSlotsResModel {
  final bool success;
  final String message;
  final List<TimeSlot>? timeSlots;

  TimeSlotsResModel({
   required this.success,
   required this.message,
    this.timeSlots,
  });

  factory TimeSlotsResModel.fromJson(Map<String, dynamic> json) => TimeSlotsResModel(
    success: json["success"],
    message: json["message"],
    timeSlots: json["data"] == null ? [] : List<TimeSlot>.from(json["data"]!.map((x) => TimeSlot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": timeSlots == null ? [] : List<dynamic>.from(timeSlots!.map((x) => x.toJson())),
  };
}

class TimeSlot {
  final String? time;
  final bool isAvailable ;
  bool isSelected;

  TimeSlot({
    this.time,
    this.isAvailable = true,
    this.isSelected  =false
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    time: json["time"],
    isAvailable: json["isAvailable"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "isAvailable": isAvailable,
  };
}
