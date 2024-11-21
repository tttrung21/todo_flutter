import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/text_field.dart';
import 'package:todo_app/project/auth/provider/auth_provider.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/utils/loading.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/show_dialog.dart';
import '../../login/view/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();

  final TextEditingController emailTEC = TextEditingController();
  final TextEditingController passwordTEC = TextEditingController();
  final TextEditingController confirmTEC = TextEditingController();
  bool _hasInteracted = false;

  @override
  void dispose() {
    super.dispose();
    emailTEC.dispose();
    passwordTEC.dispose();
    confirmTEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context,listen: false);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ModColorStyle.primary,
        appBar: AppBar(
          backgroundColor: ModColorStyle.primary,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back, size: 24, color: ModColorStyle.white),
          ),
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
                      if(_hasInteracted){
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
                  normalTextFormField(
                    S.of(context).auth_XacNhanMK,
                    confirmTEC,
                    isObscure: true,
                    validator: (value) {
                      if(_hasInteracted){
                        if (value!.isEmpty) {
                          return S.of(context).common_LoiThongTinTrong;
                        }
                        if (passwordTEC.text.isNotEmpty && value != passwordTEC.text) {
                          return S.of(context).common_LoiMKKhac;
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
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
                          ShowLoading.loadingDialog(context);
                          final res = await provider.signUp(emailTEC.text, passwordTEC.text);
                          if (context.mounted) {
                            Navigator.pop(context);
                            if (res) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                              showDialog(
                                context: context,
                                builder: (context) =>  CommonDialog(
                                  type: EnumTypeDialog.success,
                                  title: S.of(context).common_ThanhCong,
                                  subtitle: S.of(context).auth_ThanhCongTaoTK,
                                ),
                              );
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
                      },
                      child: Text(
                        S.of(context).auth_DangKy,
                        style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
