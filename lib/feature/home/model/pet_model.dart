class Pet {
  final int id;
  final String name;
  final int age;
  final double price;
  final String imageUrl;
  final String gender;
  final String color;
  final String breed;
  final bool vaccinated;
  final double weightKg;
  final bool isAdopted;
  final String description;
  final String category;

  Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.price,
    required this.imageUrl,
    required this.gender,
    required this.color,
    required this.breed,
    required this.vaccinated,
    required this.weightKg,
    required this.isAdopted,
    required this.description,
    required this.category,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      gender: json['gender'] as String,
      color: json['color'] as String,
      breed: json['breed'] as String,
      vaccinated: json['vaccinated'] as bool,
      weightKg: (json['weightKg'] as num).toDouble(),
      isAdopted: json['isAdopted'] as bool,
      description: json['description'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'price': price,
      'imageUrl': imageUrl,
      'gender': gender,
      'color': color,
      'breed': breed,
      'vaccinated': vaccinated,
      'weightKg': weightKg,
      'isAdopted': isAdopted,
      'description': description,
      'category': category,
    };
  }

  // Add copyWith method
  Pet copyWith({
    int? id,
    String? name,
    int? age,
    double? price,
    String? imageUrl,
    String? gender,
    String? color,
    String? breed,
    bool? vaccinated,
    double? weightKg,
    bool? isAdopted,
    String? description,
    String? category,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      color: color ?? this.color,
      breed: breed ?? this.breed,
      vaccinated: vaccinated ?? this.vaccinated,
      weightKg: weightKg ?? this.weightKg,
      isAdopted: isAdopted ?? this.isAdopted,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pet &&
        other.id == id &&
        other.name == name &&
        other.age == age &&
        other.price == price &&
        other.imageUrl == imageUrl &&
        other.gender == gender &&
        other.color == color &&
        other.breed == breed &&
        other.vaccinated == vaccinated &&
        other.weightKg == weightKg &&
        other.isAdopted == isAdopted &&
        other.description == description &&
        other.category == category;
  }

  @override
  String toString() {
    return 'Pet{id: $id, name: $name, age: $age, price: $price, imageUrl: $imageUrl, '
        'gender: $gender, color: $color, breed: $breed, vaccinated: $vaccinated, '
        'weightKg: $weightKg, isAdopted: $isAdopted, description: $description, '
        'category: $category}';
  }
}
