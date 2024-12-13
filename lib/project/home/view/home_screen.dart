import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/create_route.dart';
import 'package:todo_app/components/buttons.dart';
import 'package:todo_app/model/todo_model.dart';

import 'package:todo_app/localization/language_provider.dart';
import 'package:todo_app/project/home/view/list_todo.dart';
import 'package:todo_app/project/home/view_model/home_viewmodel.dart';
import 'package:todo_app/project/newtask/view/addtask_screen.dart';
import 'package:todo_app/project/settings/view/setting_screen.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/utils/convert_utils.dart';
import 'package:todo_app/utils/device_info.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<AnimatedListState> todoListKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> completedListKey = GlobalKey<AnimatedListState>();

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
        appBar: AppBar(
          leading: SizedBox(),
          toolbarHeight: 0,
          backgroundColor: ModColorStyle.primary,
        ),
        body: _buildBody(context),
        bottomNavigationBar: BottomAppBar(
            color: ModColorStyle.background,
            child: CircularCupertinoButton(
                onPress: () async {
                  final res = await Navigator.of(context)
                      .push(createRoute(const AddTaskScreen(), dx: 0, dy: 1));
                  if (res is TodoModel) {
                    context.read<HomeViewModel>().addTodo(res);
                  }
                },
                title: S.of(context).addTask_AddTask)),
      ),
    );
  }

  ///Widgets
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
                expandedHeight: 146.0,
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
                                // SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text(
                                      date,
                                      style:
                                          ModTextStyle.title2.copyWith(color: ModColorStyle.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: InkWell(
                                        onTap: () => Navigator.of(context).push(
                                          createRoute(SettingScreen()),
                                        ),
                                        child: const Icon(CupertinoIcons.settings,
                                            size: 24, color: ModColorStyle.white),
                                      ),
                                    )
                                  ],
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
                leading: SizedBox.shrink(),
              ),
              SliverPadding(
                padding: (DeviceInfo().isIos && width > height)
                    ? EdgeInsets.fromLTRB(padding.left + 8, 16, padding.right + 8, 16)
                    : const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: ListTodo(listItem: todoList, isCompleteList: false,listKey: todoListKey,),
              ),
              if (completedList.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                      : const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  sliver: ListTodo(listItem: completedList, isCompleteList: true,listKey: completedListKey,))
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
}
