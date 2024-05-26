
class Notes {
  int? id;
  String? titre;
  String description;
  String date;
  Notes({
     this.id,
     this.titre,
    required this.description,
    required this.date,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'titre': titre,
      'description': description,
      'date': date,
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id'] as int,
      titre: map['titre'] as String,
      description: map['description'] as String,
      date: map['date'] as String
    );
  }

}