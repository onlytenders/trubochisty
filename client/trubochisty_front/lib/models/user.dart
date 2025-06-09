class User {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String role; // 'admin', 'engineer', 'viewer'
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.role = 'engineer',
    required this.createdAt,
    this.lastLoginAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      role: json['role'] ?? 'engineer',
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt']) 
          : null,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  String get initials {
    final names = name.split(' ');
    return names.length >= 2 
        ? '${names[0][0]}${names[1][0]}'.toUpperCase()
        : name.length >= 2 
            ? name.substring(0, 2).toUpperCase()
            : name.toUpperCase();
  }

  bool get isAdmin => role == 'admin';
  bool get canEdit => role == 'admin' || role == 'engineer';
  bool get canView => true; // all authenticated users can view
} 