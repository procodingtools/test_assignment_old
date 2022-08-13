part of 'medication_cubit.dart';

abstract class MedicationState {
  final medications;

  MedicationState({this.medications});

  List<Object?> get props => [];
}

class SetMedicationsState extends MedicationState {
  @override
  List<MedicationModel> medications;

  SetMedicationsState(this.medications)
      : super(medications: medications);

  @override
  List<Object?> get props => [];
}

class InitialMedicationState extends MedicationState {}

class LoadingMedicationsState extends MedicationState {
  LoadingMedicationsState();

  @override
  List<Object?> get props => [];
}

class ErrorMedicationState extends MedicationState {
  Exception exception;

  ErrorMedicationState(this.exception);

  @override
  List<Object?> get props => [];
}
