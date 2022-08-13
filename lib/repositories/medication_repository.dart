import 'package:test_assignment/models/medication_model.dart';
import 'package:test_assignment/services/medication_service.dart';

class MedicationRepository {

  late MedicationService _service;

  MedicationRepository(this._service);

  Future<List<MedicationModel>> getMedications() async {
    return await _service.getMedications();
  }
}