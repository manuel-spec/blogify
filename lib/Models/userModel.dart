class Blog {
  final int id;
  final String title;
  final String description;
  final String content;
  final int userId;
  final int categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final User user;
  final Category category;

  Blog({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.userId,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.user,
    required this.category,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      likesCount: json['likes_count'],
      user: User.fromJson(json['user']),
      category: Category.fromJson(json['category']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String username;

  User({
    required this.id,
    required this.name,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
