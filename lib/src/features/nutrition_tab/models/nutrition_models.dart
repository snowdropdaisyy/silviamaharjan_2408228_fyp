class FoodItem {
  final String name;
  final String description;
  final List<String> tags;
  final String image;

  FoodItem({required this.name, required this.description, required this.tags, required this.image});

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      image: map['image'] ?? 'avocado',
    );
  }
}

class MealOption {
  final String title;
  final List<String> points;
  final String optional;

  MealOption({required this.title, required this.points, required this.optional});

  factory MealOption.fromMap(Map<String, dynamic> map) {
    return MealOption(
      title: map['title'] ?? '',
      points: List<String>.from(map['points'] ?? []),
      optional: map['optional'] ?? '',
    );
  }
}