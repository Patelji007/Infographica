class Infographic {
  final String id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;

  Infographic({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
  });

  factory Infographic.fromJson(Map<String, dynamic> json) {
    return Infographic(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'image_url': imageUrl,
    };
  }
}
