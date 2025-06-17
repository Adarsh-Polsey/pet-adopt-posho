import 'package:flutter_test/flutter_test.dart';
import 'package:pet_adopt_posha/shared/model/pet_model.dart';

void main() {
  group('Pet model', () {
    test('fromJson returns correct Pet instance', () {
      final json = {
        'id': 1,
        'name': 'Charlie',
        'age': 2,
        'price': 250.0,
        'imageUrl': 'http://image.url',
        'gender': 'Male',
        'color': 'Brown',
        'breed': 'Labrador',
        'vaccinated': true,
        'weightKg': 20.5,
        'isAdopted': false,
        'description': 'Friendly dog',
        'category': 'Dog',
      };
      final pet = Pet.fromJson(json);
      expect(pet.id, 1);
      expect(pet.name, 'Charlie');
      expect(pet.age, 2);
      expect(pet.price, 250.0);
      expect(pet.imageUrl, 'http://image.url');
      expect(pet.gender, 'Male');
      expect(pet.color, 'Brown');
      expect(pet.breed, 'Labrador');
      expect(pet.vaccinated, true);
      expect(pet.weightKg, 20.5);
      expect(pet.isAdopted, false);
      expect(pet.description, 'Friendly dog');
      expect(pet.category, 'Dog');
    });

    test('toJson returns correct Map', () {
      final pet = Pet(
        id: 2,
        name: 'Lucy',
        age: 3,
        price: 300.0,
        imageUrl: 'http://img.com',
        gender: 'Female',
        color: 'White',
        breed: 'Poodle',
        vaccinated: false,
        weightKg: 10.0,
        isAdopted: true,
        description: 'Calm and cute',
        category: 'Dog',
      );
      final json = pet.toJson();
      expect(json['id'], 2);
      expect(json['name'], 'Lucy');
      expect(json['isAdopted'], true);
      expect(json['category'], 'Dog');
    });
    test('equality operator returns true for identical pets', () {
      final pet1 = Pet(
        id: 3,
        name: 'Buddy',
        age: 4,
        price: 100.0,
        imageUrl: 'img.jpg',
        gender: 'Male',
        color: 'Black',
        breed: 'Beagle',
        vaccinated: true,
        weightKg: 12.0,
        isAdopted: false,
        description: 'Active and smart',
        category: 'Dog',
      );

      final pet2 = Pet(
        id: 3,
        name: 'Buddy',
        age: 4,
        price: 100.0,
        imageUrl: 'img.jpg',
        gender: 'Male',
        color: 'Black',
        breed: 'Beagle',
        vaccinated: true,
        weightKg: 12.0,
        isAdopted: false,
        description: 'Active and smart',
        category: 'Dog',
      );

      expect(pet1, equals(pet2));
    });
    test('copyWith updates selected fields only', () {
      final original = Pet(
        id: 5,
        name: 'Tom',
        age: 1,
        price: 200,
        imageUrl: 'url',
        gender: 'Male',
        color: 'Gray',
        breed: 'Siamese',
        vaccinated: false,
        weightKg: 4.2,
        isAdopted: false,
        description: 'Playful kitten',
        category: 'Cat',
      );

      final updated = original.copyWith(isAdopted: true, name: 'Tommy');

      expect(updated.name, 'Tommy');
      expect(updated.isAdopted, true);
      expect(updated.breed, original.breed); // unchanged
    });
  });
}
