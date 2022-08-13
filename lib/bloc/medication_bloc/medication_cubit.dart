import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/bloc/user_bloc/user_bloc.dart';
import 'package:test_assignment/models/medication_model.dart';
import 'package:test_assignment/repositories/medication_repository.dart';

part 'medication_state.dart';

class MedicationCubit extends Cubit<MedicationState> {
  MedicationCubit(this._repository) :super (InitialMedicationState()) {
    getMedications();
  }

  final MedicationRepository _repository;
  static StreamSubscription<UserState>? _userCubitStream;




  Future<void> getMedications() async {
    emit(LoadingMedicationsState());
    try {
      final medications = await _repository.getMedications();
      emit(SetMedicationsState(medications));
    } on Exception catch(e) {
      emit(ErrorMedicationState(e));

    }
  }

}