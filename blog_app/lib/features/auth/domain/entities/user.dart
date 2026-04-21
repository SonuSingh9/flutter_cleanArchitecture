import 'package:blog_app/features/auth/data/models/user_models.dart';

class User {
  final String id;
  final String email;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });
}