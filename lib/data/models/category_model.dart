class CategoryModel {
  final String slug;
  final String name;
  final String url;

  CategoryModel({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoryModel.fromJson(dynamic json) {
    if (json is String) {
      return CategoryModel(
        slug: json,
        name: json[0].toUpperCase() + json.substring(1),
        url: '',
      );
    } else if (json is Map<String, dynamic>) {
      return CategoryModel(
        slug: json['slug'] ?? '',
        name: json['name'] ?? '',
        url: json['url'] ?? '',
      );
    } else {
      return CategoryModel(slug: 'unknown', name: 'Unknown', url: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'url': url,
    };
  }
}