import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/button.dart';
import 'package:todo_app/model/todo_model.dart';

import 'package:todo_app/project/auth/provider/auth_provider.dart';
import 'package:todo_app/localization/language_provider.dart';
import 'package:todo_app/project/task/home/view/todo_item.dart';
import 'package:todo_app/project/task/newtask/view/addtask_screen.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/project/auth/login/view/login_screen.dart';
import 'package:todo_app/project/task/providers/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<TodoProvider>(context, listen: false).fetchTodos();
      },
    );
  }

  bool _isIos() {
    return Platform.isIOS;
  }

  String _formatDate(DateTime date, String locale) {
    if (locale == 'vi') {
      return '${date.day} Tháng ${date.month}, ${date.year}';
    } else {
      return DateFormat('MMMM dd, yyyy', locale).format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      backgroundColor: ModColorStyle.background,
      appBar: _buildAppBarWidget,
      body: Stack(
        children: [
          const SizedBox(
              height: 80, width: double.infinity, child: ColoredBox(color: ModColorStyle.primary)),
          _buildBody(provider),
          if (provider.isLoading)
            const Center(
                child: CircularProgressIndicator(
              color: ModColorStyle.primary,
            ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: ModColorStyle.background,
          child: normalCupertinoButton(
              onPress: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddTaskScreen(),
                ));
              },
              title: S.of(context).addTask_AddTask)),
    );
  }

  ///Widgets
  AppBar get _buildAppBarWidget {
    final langProvider = Provider.of<LanguageProvider>(context);

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

  Widget _buildBody(TodoProvider provider) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;
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
                  _buildListItem(height, provider.todoList, false),
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
                  _buildListItem(height, provider.completedList, true),
                ],
              );
            }, childCount: 1)),
          ],
        ));
  }

  Widget _buildListItem(double height, List<TodoModel> listItem, bool isCompleteList) {
    return Flexible(
      child: Container(
        height: height / 3.5,
        decoration:
            BoxDecoration(color: ModColorStyle.white, borderRadius: BorderRadius.circular(16)),
        child: ListView.separated(
          itemBuilder: (context, index) {
            final item = listItem[index];
            return isCompleteList
                ? TodoItem(item: item)
                : InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => AddTaskScreen(item: item)));
                    },
                    child: TodoItem(item: item));
          },
          itemCount: listItem.length,
          separatorBuilder: (context, index) =>
              const Divider(color: ModColorStyle.disable, thickness: 0.1),
        ),
      ),
    );
  }

  ///Function
  void onLogout(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();
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
}
