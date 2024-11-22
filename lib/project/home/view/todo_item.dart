import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/project/providers/todo_provider.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/utils/show_dialog.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.item});

  final TodoModel item;

  bool isCompleted() {
    return item.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return Dismissible(
          key: Key(item.id.toString()),
          confirmDismiss: (direction) async {
            final res = await showDialog(
              context: context,
              builder: (context) =>
                  const CommonDialog(type: EnumTypeDialog.warning, title: 'Detele item'),
            );
            if (res == true) {
              final res = await provider.deleteTodo(item.id);
              return res;
            } else {
              return false;
            }
          },
          direction: DismissDirection.endToStart,
          child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
              leading: Opacity(
                  opacity: isCompleted() ? 0.3 : 1,
                  child: Image.asset('assets/images/${item.category}.png')),
              title: Text(
                item.title,
                style: ModTextStyle.item1.copyWith(
                    color: isCompleted() ? ModColorStyle.subTitle : ModColorStyle.title,
                    decoration: isCompleted() ? TextDecoration.lineThrough : null,
                    decorationColor: isCompleted() ? ModColorStyle.subTitle : null),
              ),
              subtitle: item.dueDate.isNotEmpty
                  ? Text(
                      item.dueTime ?? '',
                      style: ModTextStyle.item2.copyWith(
                          color: ModColorStyle.subTitle,
                          decoration: isCompleted() ? TextDecoration.lineThrough : null,
                          decorationColor: isCompleted() ? ModColorStyle.subTitle : null),
                    )
                  : null,
              trailing: Checkbox(
                  value: item.isCompleted,
                  onChanged: (val) async {
                    await provider.toggleComplete(item.id);
                  })),
        );
      },
    );
  }
}
