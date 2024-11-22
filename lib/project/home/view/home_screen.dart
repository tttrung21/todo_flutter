import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/project/home/view/todo_item.dart';
import 'package:todo_app/project/newtask/view/addtask_screen.dart';
import 'package:todo_app/project/auth/provider/auth_provider.dart';
import 'package:todo_app/project/providers/language_provider.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';

import '../../../generated/l10n.dart';
import '../../auth/login/view/login_screen.dart';
import '../../providers/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String date;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<TodoProvider>(context, listen: false).fetchTodos();
      },
    );
  }

  bool isIos() {
    return Platform.isIOS;
  }
  String formatDate(DateTime date, String locale) {
    if (locale == 'vi') {
      return '${date.day} Tháng ${date.month}, ${date.year}';
    } else {
      return DateFormat('MMMM dd, yyyy', locale).format(date);
    }
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context);

    final locale = langProvider.locale.toString();
    date = formatDate(now, locale);

    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;
    return Scaffold(
      backgroundColor: ModColorStyle.background,
      appBar: AppBar(
        backgroundColor: ModColorStyle.primary,
        title: Text(
          date,
          style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
        ),
        leading: InkWell(
          onTap: () {
            if (langProvider.locale == const Locale('vi')) {
              langProvider.setLanguage('en');
            } else {
              langProvider.setLanguage('vi');
            }
          },
          child: const Icon(CupertinoIcons.globe, size: 24, color: ModColorStyle.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
              },
              child: const Icon(Icons.logout, size: 24, color: ModColorStyle.white),
            ),
          ),
        ],
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Text(
              S.of(context).home_TieuDe,
              style: ModTextStyle.title1.copyWith(color: ModColorStyle.white),
            )),
      ),
      body: Stack(
        children: [
          const SizedBox(
              height: 80, width: double.infinity, child: ColoredBox(color: ModColorStyle.primary)),
          Padding(
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16), color: ModColorStyle.white),
              // margin: (isIos() && width > height)
              //     ? EdgeInsets.fromLTRB(mq.padding.left, 16, mq.padding.right, 16)
              //     : const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: (isIos() && width > height)
                  ? EdgeInsets.fromLTRB(mq.padding.left, 16, mq.padding.right, 16)
                  : const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: CustomScrollView(
                physics: width > height ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            height: height/3.5,
                            decoration: BoxDecoration(
                                color: ModColorStyle.white, borderRadius: BorderRadius.circular(16)),
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final item = provider.todoList[index];
                                return TodoItem(item: item);
                              },
                              itemCount: provider.todoList.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(color: ModColorStyle.disable, thickness: 0.1),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Align(
                            alignment : Alignment.centerLeft,
                            child: Text(
                              S.of(context).home_HoanThanh,
                              style: ModTextStyle.title2.copyWith(color: CupertinoColors.label),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            height: height/3.5,
                            decoration: BoxDecoration(
                                color: ModColorStyle.white, borderRadius: BorderRadius.circular(16)),
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final item = provider.completedList[index];
                                return TodoItem(item: item);
                              },
                              itemCount: provider.completedList.length,
                              separatorBuilder: (context, index) =>
                              const Divider(color: ModColorStyle.disable, thickness: 0.1),
                            ),
                          ),
                        ),
                      ],
                    );
                    // final item = provider.todoList[index];
                    // return TodoItem(item: item);
                  }, childCount: 1)),
                  // SliverToBoxAdapter(
                  //   child: ColoredBox(
                  //     color: ModColorStyle.background,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(16),
                  //       child: Text(
                  //         S.of(context).home_HoanThanh,
                  //         style: ModTextStyle.title2.copyWith(color: CupertinoColors.label),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SliverList(
                  //     delegate: SliverChildBuilderDelegate((context, index) {
                  //   final item = provider.completedList[index];
                  //   return TodoItem(item: item);
                  // }, childCount: provider.completedList.length)),
                ],
              )
              // Column(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         // height: 500,
              //         // width: DeviceUtils.screenWidth - 32,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(16), color: ModColorStyle.white),
              //         child: ListView.separated(
              //           itemBuilder: (context, index) {
              //             if (provider.todos.isEmpty) {
              //               return Center(
              //                 child: Text(
              //                   S.of(context).home_KhongCoDuLieu,
              //                   style: ModTextStyle.title1.copyWith(color: ModColorStyle.label),
              //                 ),
              //               );
              //             }
              //             final item = provider.todos[index];
              //             return TodoItem(item: item);
              //           },
              //           itemCount: provider.todos.length,
              //           separatorBuilder: (context, index) =>
              //               const Divider(color: Colors.grey, thickness: 0.1),
              //         ),
              //       ),
              //     ),
              //   ],
              // )
              ),
          if (provider.isLoading)
            const Center(
                child: CircularProgressIndicator(
              color: ModColorStyle.primary,
            ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: ModColorStyle.background,
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(50),
          padding: EdgeInsets.zero,
          color: ModColorStyle.primary,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ));
          },
          child: Text(
            S.of(context).addTask_ThemViec,
            style: ModTextStyle.button1.copyWith(color: ModColorStyle.white),
          ),
        ),
      ),
    );
  }
}
