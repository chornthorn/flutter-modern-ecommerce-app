import 'package:flutter/foundation.dart';

@immutable
class Category {
  final String id;
  final String name;
  final String iconName;

  const Category({
    required this.id,
    required this.name,
    required this.iconName,
  });

  Category copyWith({
    String? id,
    String? name,
    String? iconName,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.iconName == iconName;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ iconName.hashCode;

  @override
  String toString() => 'Category(id: $id, name: $name, iconName: $iconName)';
}
