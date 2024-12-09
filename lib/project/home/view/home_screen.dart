import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/buttons.dart';
import 'package:todo_app/model/todo_model.dart';

import 'package:todo_app/localization/language_provider.dart';
import 'package:todo_app/project/home/view/list_todo.dart';
import 'package:todo_app/project/home/view_model/home_viewmodel.dart';
import 'package:todo_app/project/newtask/view/addtask_screen.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/project/login/view/login_screen.dart';
import 'package:todo_app/utils/convert_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  bool _isIos() {
    return Platform.isIOS;
  }

  String _formatDate(DateTime date, String locale) {
    if (locale == 'vi') {
      return '${date.day} Tháng ${date.month}, ${date.year}';
    } else {
      return ConvertUtils.Mdy(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeViewModel()..fetchTodos(),
      builder: (context, child) => Scaffold(
        backgroundColor: ModColorStyle.background,
        appBar: _buildAppBarWidget(context),
        body: Stack(
          children: [
            const SizedBox(
                height: 80,
                width: double.infinity,
                child: ColoredBox(color: ModColorStyle.primary)),
            _buildBody(context),
            Selector<HomeViewModel, bool>(
              builder: (context, value, child) {
                if (value) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: ModColorStyle.primary,
                  ));
                }
                return SizedBox.shrink();
              },
              selector: (context, vm) => vm.isLoading,
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            color: ModColorStyle.background,
            child: normalCupertinoButton(
                onPress: () async {
                  final res = await Navigator.of(context).push(_createRouteAddTask());
                  if (res is TodoModel) {
                    context.read<HomeViewModel>().addTodo(res);
                  }
                },
                title: S.of(context).addTask_AddTask)),
      ),
    );
  }

  ///Widgets
  AppBar _buildAppBarWidget(BuildContext context) {
    final langProvider = context.read<LanguageProvider>();

    final locale = langProvider.locale.toString();
    final date = _formatDate(DateTime.now(), locale);
    return AppBar(
      backgroundColor: ModColorStyle.primary,
      title: Text(
        date,
        style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
      ),
      leading: InkWell(
        onTap: () => changeLang(langProvider),
        child: const Icon(CupertinoIcons.globe, size: 24, color: ModColorStyle.white),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              onLogout(context);
            },
            child: const Icon(Icons.logout, size: 24, color: ModColorStyle.white),
          ),
        ),
      ],
      centerTitle: true,
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Text(
            S.of(context).home_Title,
            style: ModTextStyle.title1.copyWith(color: ModColorStyle.white),
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;
    final todoList = context.watch<HomeViewModel>().todoList;
    final completedList = context.watch<HomeViewModel>().completedList;
    return Padding(
        padding: (_isIos() && width > height)
            ? EdgeInsets.fromLTRB(mq.padding.left, 16, mq.padding.right, 16)
            : const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: CustomScrollView(
          physics:
              width > height ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTodo(
                    height: height,
                    listItem: todoList,
                    isCompleteList: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).home_Complete,
                        style: ModTextStyle.title2.copyWith(color: CupertinoColors.label),
                      ),
                    ),
                  ),
                  ListTodo(height: height, listItem: completedList, isCompleteList: true),
                ],
              );
            }, childCount: 1)),
          ],
        ));
  }

  ///Function
  void onLogout(BuildContext context) {
    context.read<HomeViewModel>().logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  void changeLang(LanguageProvider langProvider) {
    if (langProvider.locale == const Locale('vi')) {
      langProvider.setLanguage('en');
    } else {
      langProvider.setLanguage('vi');
    }
  }

  Route _createRouteAddTask() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AddTaskScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
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
