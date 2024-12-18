import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/project/home/view_model/home_viewmodel.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/utils/show_dialog.dart';

import 'package:todo_app/generated/l10n.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.item});

  final TodoModel item;

  bool _isCompleted() {
    return item.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, provider, child) {
        return Dismissible(
            key: Key(item.id.toString()),
            confirmDismiss: (direction) async {
              final res = await showDialog(
                context: context,
                builder: (context) =>
                    CommonDialog(type: EnumTypeDialog.warning, title: S.of(context).common_Delete,isDelete: true,),
              );
              if (res == true) {
                final res = await provider.deleteTodo(item.id);
                return res;
              } else {
                return false;
              }
            },
            direction: DismissDirection.endToStart,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16,16,8,8),
              child: Row(
                children: [
                  Opacity(
                      opacity: _isCompleted() ? 0.3 : 1,
                      child: Image.asset('assets/images/${item.category}.png', width: 48)),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ModTextStyle.item1.copyWith(
                              color: _isCompleted() ? ModColorStyle.subTitle : ModColorStyle.title,
                              decoration: _isCompleted() ? TextDecoration.lineThrough : null,
                              decorationColor: _isCompleted() ? ModColorStyle.subTitle : null),
                        ),
                        if (item.dueTime != '')
                          Text(
                            item.dueTime ?? '',
                            style: ModTextStyle.item2.copyWith(
                                color: ModColorStyle.subTitle,
                                decoration: _isCompleted() ? TextDecoration.lineThrough : null,
                                decorationColor: _isCompleted() ? ModColorStyle.subTitle : null),
                          ),
                      ],
                    ),
                  ),
                  Checkbox(
                      value: item.isCompleted,
                      onChanged: (val) async {
                        await provider.toggleComplete(item.id);
                      })
                ],
              ),
            ));
      },
    );
  }
}
