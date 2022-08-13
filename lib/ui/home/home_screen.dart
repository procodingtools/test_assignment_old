
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/bloc/medication_bloc/medication_cubit.dart';
import 'package:test_assignment/bloc/user_bloc/user_bloc.dart';
import 'package:test_assignment/repositories/medication_repository.dart';
import 'package:test_assignment/ui/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserCubit _userCubit;

  @override
  void initState() {
    super.initState();
    _userCubit = context.read<UserCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is LoggedOutUserState) {

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
          );
        }
      },
      child: BlocProvider<MedicationCubit>(
        create: (context) => MedicationCubit(
            context.read<MedicationRepository>()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(greeting(_userCubit.state)),
            actions: [
              PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
                onSelected: (txt) {
                  if (txt == 'logout') {
                    context.read<UserCubit>().logout();
                  }
                },
              )
            ],
          ),
          body: BlocConsumer<MedicationCubit, MedicationState>(
            listener: (context, medicationState) {
              if (medicationState is ErrorMedicationState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(medicationState.exception is DioError
                        ? 'Please check your internet connection'
                        : 'Something went wrong')));
              }
            },
            builder: (context, medicationState) {
              if (medicationState is LoadingMedicationsState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (medicationState is SetMedicationsState) {
                return _listView(medicationState);
              } else if (medicationState is ErrorMedicationState) {
                return Center(
                  child: Text(medicationState.exception is DioError
                      ? 'Please check your internet connection'
                      : 'Something went wrong'),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  String greeting(UserState state) {
    final hour = DateTime.now().hour;
    late String msg;
    if (hour < 12) {
      msg = 'morning';
    }
    if (hour < 17) {
      msg = 'afternoon';
    } else {
      msg = 'evening';
    }
    return 'Good $msg ${state.user?.username}';
  }

  Widget _listView(SetMedicationsState state) {
    return ListView.builder(
      itemCount: state.medications.length,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      itemBuilder: (context, index) {
        final medication = state.medications[index];
        return ListTile(
          isThreeLine: true,
          title: Text('Name: ${medication.name}'),
          subtitle: Text('Dose: ${medication.dose}'),
          trailing: Text('Strength: ${medication.strength}'),
        );
      },
    );
  }
}
