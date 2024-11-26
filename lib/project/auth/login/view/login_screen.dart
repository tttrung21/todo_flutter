import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/text_field.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/project/auth/provider/auth_provider.dart';
import 'package:todo_app/project/auth/register/view/register_screen.dart';
import 'package:todo_app/project/task/home/view/home_screen.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/utils/loading.dart';
import 'package:todo_app/utils/show_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();
  bool _hasInteracted = false;

  @override
  void dispose() {
    super.dispose();
    _emailTEC.dispose();
    _passwordTEC.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailTEC.text = 'trung@test.com';
    _passwordTEC.text = 'password';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ModColorStyle.primary,
        appBar: _buildAppBar,
        body: _buildBody,
      ),
    );
  }

  ///Widget
  AppBar get _buildAppBar {
    return AppBar(
      backgroundColor: ModColorStyle.primary,
      leading: const SizedBox(),
    );
  }

  Widget get _buildBody {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _key,
        autovalidateMode:
            _hasInteracted ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(16), color: ModColorStyle.white),
          child: Column(
            children: [
              normalTextFormField(
                'Email',
                _emailTEC,
                validator: (value) {
                  if (_hasInteracted) {
                    if (value!.isEmpty) {
                      return S.of(context).common_EmptyField;
                    }
                    if (!EmailValidator.validate(value)) {
                      return S.of(context).common_InvalidEmail;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              normalTextFormField(
                S.of(context).auth_Password,
                _passwordTEC,
                isObscure: true,
                validator: (value) {
                  if (_hasInteracted) {
                    if (value!.isEmpty) {
                      return S.of(context).common_EmptyField;
                    }
                    if (value.length < 8) {
                      return S.of(context).common_PasswordErrorLength;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              _buildButtons
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildButtons {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRegisterButton,
        _buildLoginButton,
        const SizedBox(
          width: 80,
        ),
      ],
    );
  }

  Widget get _buildRegisterButton {
    return TextButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const RegisterScreen()));
          _emailTEC.clear();
          _passwordTEC.clear();
        },
        child: Text(
          S.of(context).auth_Register,
          style: ModTextStyle.label.copyWith(color: ModColorStyle.primary),
        ));
  }

  Widget get _buildLoginButton {
    return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: ModColorStyle.primary,
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (!_hasInteracted) {
            setState(() {
              _hasInteracted = true;
            });
          }
          if (_key.currentState!.validate()) {
            onLogin(context);
          }
        },
        child: Text(
          S.of(context).auth_SignIn,
          style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
        ));
  }

  ///Function
  Future<void> onLogin(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    ShowLoading.loadingDialog(context);
    final res = await provider.signIn(_emailTEC.text, _passwordTEC.text);
    if (context.mounted) {
      Navigator.pop(context);
      if (res) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      } else {
        showDialog(
          context: context,
          builder: (context) => CommonDialog(
            type: EnumTypeDialog.error,
            title: S.of(context).common_Error,
            subtitle: provider.errorMessage,
          ),
        );
      }
    }
  }
}
