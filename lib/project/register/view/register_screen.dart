import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/text_field.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/project/register/view_model/register_viewmodel.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/utils/loading.dart';
import 'package:todo_app/utils/show_dialog.dart';
import 'package:todo_app/utils/validate.dart';

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
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(CupertinoIcons.back, size: 24, color: ModColorStyle.white),
      ),
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
              normalTextFormField(
                S.of(context).auth_ConfirmPassword,
                _confirmTEC,
                isObscure: true,
                validator: (value) {
                  if (_hasInteracted) {
                    return CommonValidate.validateConfirm(value, _passwordTEC.text, context);
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              _buildRegisterButton
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildRegisterButton {
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
            onRegister(context);
          }
        },
        child: Text(
          S.of(context).auth_Register,
          style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
        ));
  }

  ///Function
  Future<void> onRegister(BuildContext context) async {
    final provider = Provider.of<RegisterViewModel>(context, listen: false);
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
}
