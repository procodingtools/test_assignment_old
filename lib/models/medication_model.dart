class MedicationModel {

  String? name;
  String? dose;
  String? strength;

  MedicationModel({this.name, this.dose, this.strength});

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      name: json["name"],
      dose: json["dose"],
      strength: json["strength"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "dose": dose,
      "strength": strength,
    };
  }
}