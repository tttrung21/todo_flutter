import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/create_route.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/localization/language_provider.dart';
import 'package:todo_app/project/login/view/login_screen.dart';
import 'package:todo_app/project/settings/view_model/setting_viewmodel.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final vm = SettingViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).setting_Settings,
            style: ModTextStyle.title3.copyWith(color: ModColorStyle.white),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.navigate_before,
              color: ModColorStyle.white,
              size: 32,
            ),
          ),
          backgroundColor: ModColorStyle.primary,
        ),
        body: Column(
          children: [
            Consumer<LanguageProvider>(
              builder: (context, langProvider, child) {
                return ListTile(
                    leading: Icon(
                      Icons.language,
                      color: ModColorStyle.primary,
                      size: 24,
                    ),
                    title: Text(
                      S.of(context).setting_Language,
                      style: ModTextStyle.title2.copyWith(color: ModColorStyle.label,fontWeight: FontWeight.w400),
                    ),
                    trailing: InkWell(
                        onTap: () {
                          if (langProvider.locale == const Locale('vi')) {
                            langProvider.setLanguage('en');
                          } else {
                            langProvider.setLanguage('vi');
                          }
                        },
                        child: Image.asset(
                          langProvider.locale == Locale('vi')
                              ? 'assets/images/language/Icon_Flag_VN.png'
                              : 'assets/images/language/Icon_Flag_EN.png',
                          width: 32,
                        )));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.person,
                color: ModColorStyle.primary,
                size: 24,
              ),
              title: Text(
                S.of(context).setting_LogOut,
                style: ModTextStyle.title2.copyWith(color: ModColorStyle.label,fontWeight: FontWeight.w400),
              ),
              trailing: InkWell(
                  onTap: () {
                    onLogout(context);
                  },
                  child: const Icon(Icons.logout, size: 24, color: ModColorStyle.error)),
            ),
          ],
        ),
    );
  }

  void onLogout(BuildContext context) {
    vm.logout();
    Navigator.of(context).pushReplacement(createRoute(LoginScreen()));
  }
}
