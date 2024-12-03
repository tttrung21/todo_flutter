import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/buttons.dart';
import 'package:todo_app/components/text_field.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/project/login/view_model/login_viewmodel.dart';
import 'package:todo_app/project/register/view/register_screen.dart';
import 'package:todo_app/project/home/view/home_screen.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/utils/loading.dart';
import 'package:todo_app/utils/show_dialog.dart';
import 'package:todo_app/utils/validate.dart';

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
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      builder: (context, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: ModColorStyle.primary,
          appBar: _buildAppBar,
          body: _buildBody(context),
        ),
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

  Widget _buildBody(BuildContext context) {
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
                    return CommonValidate.validateEmail(value, context);
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
                    return CommonValidate.validatePassword(value, context);
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              _buildButtons(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRegisterButton(context),
        _buildLoginButton(context),
        const SizedBox(
          width: 80,
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _hasInteracted = false;
          _key.currentState?.reset();
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

  Widget _buildLoginButton(BuildContext context) {
    return authCupertinoButton(
      title: S.of(context).auth_SignIn,
      onPress: () {
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
    );
  }

  ///Function
  Future<void> onLogin(BuildContext context) async {
    final provider = context.read<LoginViewModel>();
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
