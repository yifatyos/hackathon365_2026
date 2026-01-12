class Bookmaker {
  final String id;
  final String name;
  final String url;
  final String primaryColor; // hex color (e.g., "#003366")
  final String secondaryColor; // hex color (e.g., "#10B981")
  final String? logoUrl; // URL ללוגו
  final DateTime createdAt;
  final DateTime? updatedAt;

  Bookmaker({
    required this.id,
    required this.name,
    required this.url,
    required this.primaryColor,
    required this.secondaryColor,
    this.logoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  // המרה מ-JSON
  factory Bookmaker.fromJson(Map<String, dynamic> json) {
    return Bookmaker(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      logoUrl: json['logoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
    );
  }

  // המרה ל-JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'logoUrl': logoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // יצירת עותק מעודכן
  Bookmaker copyWith({
    String? id,
    String? name,
    String? url,
    String? primaryColor,
    String? secondaryColor,
    String? logoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bookmaker(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // המרת hex color ל-RGB
  List<int> hexToRgb(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return [
      int.parse(hexCode.substring(0, 2), radix: 16),
      int.parse(hexCode.substring(2, 4), radix: 16),
      int.parse(hexCode.substring(4, 6), radix: 16),
    ];
  }
}
