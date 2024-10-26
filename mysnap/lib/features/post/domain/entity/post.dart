import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysnap/features/post/domain/entity/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments,
    );
  }

  // post -> json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

  // json -> post
  factory Post.fromJson(Map<String, dynamic> jsonUser) {
    final List<Comment> comments = (jsonUser['comments'] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];

    return Post(
      id: jsonUser['id'],
      userId: jsonUser['userId'],
      userName: jsonUser['userName'],
      text: jsonUser['text'],
      imageUrl: jsonUser['imageUrl'],
      timestamp: (jsonUser['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(jsonUser['likes'] ?? []),
      comments: comments,
    );
  }
}
