import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/text_field.dart';
import 'package:todo_app/project/auth/provider/auth_provider.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/utils/loading.dart';
import 'package:todo_app/utils/show_dialog.dart';

import '../../../../generated/l10n.dart';
import '../../../task/home/view/home_screen.dart';
import '../../register/view/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  final TextEditingController emailTEC = TextEditingController();
  final TextEditingController passwordTEC = TextEditingController();
  bool _hasInteracted = false;

  @override
  void dispose() {
    super.dispose();
    emailTEC.dispose();
    passwordTEC.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailTEC.text = 'trung@test.com';
    passwordTEC.text = 'password';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ModColorStyle.primary,
        appBar: AppBar(
          backgroundColor: ModColorStyle.primary,
          leading: const SizedBox(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
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
                    emailTEC,
                    validator: (value) {
                      if (_hasInteracted) {
                        if (value!.isEmpty) {
                          return S.of(context).common_LoiThongTinTrong;
                        }
                        if (!EmailValidator.validate(value)) {
                          return S.of(context).common_LoiEmailKhongHopLe;
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  normalTextFormField(
                    S.of(context).auth_MatKhau,
                    passwordTEC,
                    isObscure: true,
                    validator: (value) {
                      if (value!.isEmpty && _hasInteracted) {
                        return S.of(context).common_LoiThongTinTrong;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const RegisterScreen()));
                            emailTEC.clear();
                            passwordTEC.clear();
                          },
                          child: Text(
                            S.of(context).auth_DangKy,
                            style: ModTextStyle.label.copyWith(color: ModColorStyle.primary),
                          )),
                      CupertinoButton(
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
                            S.of(context).auth_DangNhap,
                            style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
                          )),
                      const SizedBox(
                        width: 80,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onLogin(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    ShowLoading.loadingDialog(context);
    final res = await provider.signIn(emailTEC.text, passwordTEC.text);
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
            title: S.of(context).common_LoiXayRa,
            subtitle: provider.errorMessage,
          ),
        );
      }
    }
  }
}
