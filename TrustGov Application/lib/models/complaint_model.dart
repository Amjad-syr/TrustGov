import 'package:get/get.dart';

class ComplaintModel {
  final int id;
  final String desc;
  final String location;
  final String picturePath1;
  final String picturePath2;
  final int totalVotes;
  final String status;
  var isUpvoted = false.obs;
  var isDownvoted = false.obs;

  ComplaintModel({
    required this.id,
    required this.desc,
    required this.location,
    required this.picturePath1,
    required this.picturePath2,
    required this.totalVotes,
    required this.status,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'],
      desc: json['desc'],
      location: json['location'],
      picturePath1: json['picture_path1'],
      picturePath2: json['picture_path2'],
      totalVotes: json['total_votes'],
      status: json['status'],
    );
  }
}
