import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/buttons.dart';
import 'package:todo_app/components/text_field.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/project/login/view/login_screen.dart';
import 'package:todo_app/project/register/view_model/register_viewmodel.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/utils/loading.dart';
import 'package:todo_app/utils/show_dialog.dart';
import 'package:todo_app/utils/validate.dart';

import '../../../style/text_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();

  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();
  final _confirmTEC = TextEditingController();
  bool _hasInteracted = false;

  @override
  void dispose() {
    super.dispose();
    _emailTEC.dispose();
    _passwordTEC.dispose();
    _confirmTEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterViewModel(),
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
  AppBar get _buildAppBar{
    return AppBar(backgroundColor: ModColorStyle.white, leading: SizedBox());
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
                    isLabelText: true,
                    isObscure: true,
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
                  normalTextFormField(
                    S.of(context).auth_ConfirmPassword,
                    _confirmTEC,
                    isLabelText: true,
                    isObscure: true,
                    validator: (value) {
                      if (_hasInteracted) {
                        return CommonValidate.validateConfirm(value, _passwordTEC.text, context);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildRegisterButton(context)
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Column(
      children: [
        authCupertinoButton(
          title: S.of(context).auth_Register,
          onPress: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (!_hasInteracted) {
              setState(() {
                _hasInteracted = true;
              });
            }
            if (_key.currentState!.validate()) {
              onRegister(context);
            }
          },
        ),
        SizedBox(
          height: 16,
        ),
        _buildLoginButton()
      ],
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).auth_AlreadyHaveAccount,
            style: ModTextStyle.item2.copyWith(color: ModColorStyle.label)),
        GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              _hasInteracted = false;
              _key.currentState?.reset();
              Navigator.of(context).pushReplacement(_createRouteLogin());
            },
            child: Text(
              S.of(context).auth_SignIn,
              style: ModTextStyle.item2.copyWith(color: ModColorStyle.primary),
            )),
      ],
    );
  }

  ///Function
  Future<void> onRegister(BuildContext context) async {
    final provider = context.read<RegisterViewModel>();
    ShowLoading.loadingDialog(context);
    final res = await provider.signUp(_emailTEC.text, _passwordTEC.text);
    if (context.mounted) {
      Navigator.pop(context);
      if (res) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => CommonDialog(
            type: EnumTypeDialog.success,
            title: S.of(context).common_Success,
            subtitle: S.of(context).auth_CreateSuccess,
          ),
        );
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

  Route _createRouteLogin() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }
}
