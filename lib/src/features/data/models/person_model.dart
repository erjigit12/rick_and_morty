// ignore_for_file: use_super_parameters

import 'package:rick_morty/src/features/data/models/location_model.dart';
import 'package:rick_morty/src/features/domain/entities/person_entity.dart';

class PersonModel extends PersonEntity {
  const PersonModel({
    required int id,
    required String name,
    required String status,
    required String species,
    required String type,
    required String gender,
    required LocationModel origin,
    required LocationModel location,
    required String image,
    required List<String> episode,
    required DateTime created,
  }) : super(
         id: id,
         name: name,
         status: status,
         species: species,
         type: type,
         gender: gender,
         origin: origin,
         location: location,
         image: image,
         episode: episode,
         created: created,
       );

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      origin: LocationModel.fromJson(json['origin']),
      location: LocationModel.fromJson(json['location']),
      image: json['image'],
      episode: (json['episode'] as List<dynamic>).map((e) => e as String).toList(),
      created: DateTime.parse(json['created'] as String),
    );
  }

  factory PersonModel.fromEntity(PersonEntity entity) {
    return PersonModel(
      id: entity.id,
      name: entity.name,
      status: entity.status,
      species: entity.species,
      type: entity.type,
      gender: entity.gender,
      origin: LocationModel(name: entity.origin.name, url: entity.origin.url),
      location: LocationModel(name: entity.location.name, url: entity.location.url),
      image: entity.image,
      episode: List<String>.from(entity.episode),
      created: entity.created,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': {
        'name': origin.name,
        'url': origin.url,
      },
      'location': {
        'name': location.name,
        'url': location.url,
      },
      'image': image,
      'episode': episode,
      'created': created.toIso8601String(),
    };
  }
}
