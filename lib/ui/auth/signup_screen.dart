import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/bloc/user_bloc/user_bloc.dart';
import 'package:test_assignment/ui/home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late UserCubit _userCubit;


  @override
  void initState() {
    super.initState();
    _userCubit = context.read<UserCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test assignment'),
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is LoggedInUserState) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false,);
          } else if (state is ErrorUserState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          return SignupWidget(state: state, onSignup: _signup);
        },
      ),
    );
  }

  _signup(String username, String password) {
    _userCubit.signup(username, password);
  }
}


class SignupWidget extends StatelessWidget {
  SignupWidget({super.key, required this.state, required this.onSignup});

  final UserState state;
  final Function(String, String) onSignup;
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  final _passwdController = TextEditingController();
  final _passwdFocus = FocusNode();
  final _rPasswdFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (state is LoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Center(
        child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (txt) =>
                    txt?.isEmpty ?? true ? 'Required' : null,
                    onFieldSubmitted: (txt) => _passwdFocus.requestFocus(),
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    onSaved: (txt) {
                      _username = txt!;
                    },
                    decoration:
                    const InputDecoration(labelText: 'E-mail/Username'),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    controller: _passwdController,
                    validator: (txt) =>
                    txt?.isEmpty ?? true ? 'Required' : null,
                    focusNode: _passwdFocus,
                    onFieldSubmitted: (txt) => _rPasswdFocus.requestFocus(),
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    autofillHints: const [AutofillHints.newPassword],
                    onSaved: (txt) {
                      _password = txt!;
                    },
                    decoration:
                    const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    validator: (txt) =>
                    txt != _passwdController.text ? 'Password doesn\'t match' : null,
                    focusNode: _rPasswdFocus,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  MaterialButton(
                    onPressed: _signup,
                    color: Colors.black,
                    textColor: Colors.white,
                    minWidth: double.infinity,
                    child: const Text('Signup'),
                  )
                ],
              ),
            )),
      ),
    );
  }


  _signup() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      onSignup(_username, _password);
    }
  }

}
