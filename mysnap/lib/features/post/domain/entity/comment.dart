import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

  // post -> json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // json -> post
  factory Comment.fromJson(Map<String, dynamic> jsonUser) {
    return Comment(
      id: jsonUser['id'],
      postId: jsonUser['postId'],
      userId: jsonUser['userId'],
      userName: jsonUser['userName'],
      text: jsonUser['text'],
      timestamp: (jsonUser['timestamp'] as Timestamp).toDate(),
    );
  }
}
