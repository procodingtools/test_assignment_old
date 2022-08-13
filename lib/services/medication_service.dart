import 'package:dio/dio.dart';
import 'package:test_assignment/models/medication_model.dart';

class MedicationService {
  late Dio dio;

  MedicationService() {
    dio = Dio();
  }

  Future<List<MedicationModel>> getMedications() async {
    final response = (await dio.get(
            'https://run.mocky.io/v3/55feede9-58c6-4dad-a609-6426e91b72f8'))
        .data;

    List<MedicationModel> medications = [];

    for (var problems in List.of(response['problems'] ?? [])) {
      Map.of(problems).forEach((key, problem) {
        for (var pb in List.of(problem)) {
          for (var medication in List.of(pb['medications'] ?? [])) {
            for (var names in List.of(medication['medicationsClasses'] ?? {})) {
              Map.of(names).forEach((key, classes) {
                for (var className in List.of(classes)) {
                  Map.of(className).forEach((key, name) {
                    for (var med in List.of(name)) {
                      medications.add(MedicationModel.fromJson(med));
                    }
                  });
                }
              });
            }
          }
        }
      });
    }

    return medications;
  }
}
