import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/create_route.dart';
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
          backgroundColor: ModColorStyle.white,
          appBar: _buildAppBar,
          body: _buildBody(context),
        ),
      ),
    );
  }

  ///Widget
  AppBar get _buildAppBar {
    return AppBar(
      backgroundColor: ModColorStyle.white,
      leading: const SizedBox(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Hero(
              tag: 'AppIcon',
              child: Image.asset('assets/images/todo.png', width: 150, height: 150)),
          SizedBox(
            height: 16,
          ),
          Hero(
            tag: 'Welcome',
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: S.of(context).auth_Welcome,
                    children: [
                      TextSpan(text: '\n${S.of(context).auth_To}'),
                      TextSpan(
                          text: 'Todo App',
                          style: ModTextStyle.title3.copyWith(color: ModColorStyle.primary))
                    ],
                    style: ModTextStyle.title3.copyWith(color: ModColorStyle.label))),
          ),
          SizedBox(
            height: 8,
          ),
          Form(
            key: _key,
            autovalidateMode:
                _hasInteracted ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: ModColorStyle.white),
              child: Column(
                children: [
                  normalTextFormField(
                    'Email',
                    _emailTEC,
                    isLabelText: true,
                    validator: (value) {
                      if (_hasInteracted) {
                        return CommonValidate.validateEmail(value, context);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  normalTextFormField(
                    S.of(context).auth_Password,
                    _passwordTEC,
                    isObscure: true,
                    isLabelText: true,
                    validator: (value) {
                      if (_hasInteracted) {
                        return CommonValidate.validatePassword(value, context);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildButtons(context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        _buildLoginButton(context),
        SizedBox(
          height: 16,
        ),
        _buildRegisterButton(context),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).auth_NotHaveAccount,
            style: ModTextStyle.item2.copyWith(color: ModColorStyle.label)),
        GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              _hasInteracted = false;
              _key.currentState?.reset();
              Navigator.of(context).pushReplacement(createRoute(const RegisterScreen()));
              _emailTEC.clear();
              _passwordTEC.clear();
            },
            child: Text(
              S.of(context).auth_Register,
              style: ModTextStyle.item2.copyWith(color: ModColorStyle.primary),
            )),
      ],
    );
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
        Navigator.of(context).pushReplacement(createRoute(HomeScreen()));
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
