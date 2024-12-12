import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/create_route.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/project/home/view/todo_item.dart';
import 'package:todo_app/project/home/view_model/home_viewmodel.dart';
import 'package:todo_app/project/newtask/view/addtask_screen.dart';
import 'package:todo_app/style/color_style.dart';

class ListTodo extends StatelessWidget {
  const ListTodo(
      {super.key,
      required this.listItem,
      required this.isCompleteList});

  final List<TodoModel> listItem;
  final bool isCompleteList;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration:
            BoxDecoration(color: ModColorStyle.white, borderRadius: BorderRadius.circular(16)),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = listItem[index];
            return isCompleteList
                ? TodoItem(item: item)
                : InkWell(
                    onTap: () async {
                      final res = await Navigator.of(context)
                          .push(createRoute(AddTaskScreen(item: item)));
                      if (res is TodoModel) {
                        context.read<HomeViewModel>().updateTodo(res);
                      }
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
}
