import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:todo_app/utils/device_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        // appBar: _buildAppBarWidget(context),
        appBar: AppBar(leading: SizedBox(),toolbarHeight: 0,backgroundColor: ModColorStyle.primary,),
        body: _buildBody(context),
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
  // AppBar _buildAppBarWidget(BuildContext context) {
  //   final langProvider = context.read<LanguageProvider>();
  //
  //   final locale = langProvider.locale.toString();
  //   final date = _formatDate(DateTime.now(), locale);
  //   return AppBar(
  //     backgroundColor: ModColorStyle.primary,
  //     title: Text(
  //       date,
  //       style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
  //     ),
  //     leading: InkWell(
  //       onTap: () => changeLang(langProvider),
  //       child: const Icon(CupertinoIcons.globe, size: 24, color: ModColorStyle.white),
  //     ),
  //     actions: [
  //       Padding(
  //         padding: const EdgeInsets.only(right: 16.0),
  //         child: InkWell(
  //           onTap: () {
  //             onLogout(context);
  //           },
  //           child: const Icon(Icons.logout, size: 24, color: ModColorStyle.white),
  //         ),
  //       ),
  //     ],
  //     centerTitle: true,
  //     bottom: PreferredSize(
  //         preferredSize: const Size.fromHeight(50),
  //         child: Text(
  //           S.of(context).home_Title,
  //           style: ModTextStyle.title1.copyWith(color: ModColorStyle.white),
  //         )),
  //   );
  // }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final width = size.width;
    final height = size.height;

    final langProvider = context.read<LanguageProvider>();

    final locale = langProvider.locale.toString();
    final date = _formatDate(DateTime.now(), locale);

    final todoList = context.watch<HomeViewModel>().todoList;
    final completedList = context.watch<HomeViewModel>().completedList;
    return SafeArea(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: ModColorStyle.primary,
                expandedHeight: 116.0,
                // title: LayoutBuilder(
                //   builder: (context, constraints) {
                //     final isCollapsed = constraints.maxHeight <= kToolbarHeight;
                //     return isCollapsed
                //         ? SizedBox.shrink()
                //         : Text(
                //             date,
                //             style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
                //           );
                //   },
                // ),
                // bottom: PreferredSize(
                //     preferredSize: Size.fromHeight(20),
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text(
                //         S.of(context).home_Title,
                //         style: ModTextStyle.title1.copyWith(color: ModColorStyle.white),
                //       ),
                //     )),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  centerTitle: true,
                  title: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final isCollapsed = constraints.maxHeight <= 76;
                      return isCollapsed
                          ? Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                                S.of(context).home_Title,
                                style: ModTextStyle.title1.copyWith(color: ModColorStyle.white),
                              ),
                          )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 8,),
                                Text(
                                  date,
                                  style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
                                ),
                                Text(
                                  S.of(context).home_Title,
                                  style: ModTextStyle.title1.copyWith(color: ModColorStyle.white),
                                )
                              ],
                            );
                    },
                  ),
                  expandedTitleScale: 1.2,
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
                ],              ),
              SliverPadding(
                padding: (DeviceInfo().isIos && width > height)
                    ? EdgeInsets.fromLTRB(padding.left + 8, 16, padding.right + 8, 16)
                    : const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: ListTodo(listItem: todoList, isCompleteList: false),
              ),
              if (completedList.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).home_Complete,
                        style: ModTextStyle.title2.copyWith(color: CupertinoColors.label),
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                  padding: (DeviceInfo().isIos && width > height)
                      ? EdgeInsets.fromLTRB(padding.left + 8, 16, padding.right + 8, 16)
                      : const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: ListTodo(listItem: completedList, isCompleteList: true))
              // SliverList(
              //     delegate: SliverChildBuilderDelegate((context, index) {
              //   return Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       ListTodo(
              //         height: height,
              //         listItem: todoList,
              //         isCompleteList: false,
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 16),
              //         child: Align(
              //           alignment: Alignment.centerLeft,
              //           child: Text(
              //             S.of(context).home_Complete,
              //             style: ModTextStyle.title2.copyWith(color: CupertinoColors.label),
              //           ),
              //         ),
              //       ),
              //       ListTodo(height: height, listItem: completedList, isCompleteList: true),
              //     ],
              //   );
              // }, childCount: 1)),
            ],
          ),
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
    );
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
