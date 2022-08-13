import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/bloc/user_bloc/user_bloc.dart';
import 'package:test_assignment/ui/auth/signup_screen.dart';
import 'package:test_assignment/ui/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          } else if (state is ErrorUserState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          return LoginWidget(state: state, onLogin: _login);
        },
      ),
    );
  }

  _login(String username, String password) {
    _userCubit.login(username, password);
  }
}

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key, required this.state, required this.onLogin});

  final Function(String, String) onLogin;
  final UserState state;
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  final _passwdFocus = FocusNode();

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
                    decoration: const InputDecoration(labelText: 'E-mail/Username'),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    validator: (txt) =>
                        txt?.isEmpty ?? true ? 'Required' : null,
                    focusNode: _passwdFocus,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    onSaved: (txt) {
                      _password = txt!;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  MaterialButton(
                    onPressed: _login,
                    color: Colors.black,
                    textColor: Colors.white,
                    minWidth: double.infinity,
                    child: const Text('Login'),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen())),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Signup'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  _login() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      onLogin(_username, _password);
    }
  }
}
