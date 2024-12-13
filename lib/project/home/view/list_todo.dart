import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/create_route.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/project/home/view/todo_item.dart';
import 'package:todo_app/project/home/view_model/home_viewmodel.dart';
import 'package:todo_app/project/newtask/view/addtask_screen.dart';
import 'package:todo_app/style/color_style.dart';

// class ListTodo extends StatelessWidget {
//   const ListTodo(
//       {super.key,
//       required this.listItem,
//       required this.isCompleteList});
//
//   final List<TodoModel> listItem;
//   final bool isCompleteList;
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Container(
//         decoration:
//             BoxDecoration(color: ModColorStyle.white, borderRadius: BorderRadius.circular(16)),
//         child: ListView.separated(
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             final item = listItem[index];
//             return isCompleteList
//                 ? TodoItem(item: item)
//                 : InkWell(
//                     onTap: () async {
//                       final res = await Navigator.of(context)
//                           .push(createRoute(AddTaskScreen(item: item)));
//                       if (res is TodoModel) {
//                         context.read<HomeViewModel>().updateTodo(res);
//                       }
//                     },
//                     child: TodoItem(item: item));
//           },
//           itemCount: listItem.length,
//           separatorBuilder: (context, index) =>
//               const Divider(color: ModColorStyle.disable, thickness: 0.1),
//         ),
//       ),
//     );
//   }
// }
class ListTodo extends StatefulWidget {
  const ListTodo({
    super.key,
    required this.listItem,
    required this.isCompleteList,
    required this.listKey, // Add this parameter
  });

  final List<TodoModel> listItem;
  final bool isCompleteList;
  final GlobalKey<AnimatedListState> listKey;

  @override
  _ListTodoState createState() => _ListTodoState();
}

class _ListTodoState extends State<ListTodo> {
  @override
  void didUpdateWidget(covariant ListTodo oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldItems = oldWidget.listItem;
    final newItems = widget.listItem;

    // Determine added and removed items
    final removedItems = oldItems.where((item) => !newItems.contains(item)).toList();
    final addedItems = newItems.where((item) => !oldItems.contains(item)).toList();

    for (var removedItem in removedItems) {
      final index = oldItems.indexOf(removedItem);
      widget.listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildRemovedItem(removedItem, animation),
        duration: Duration(milliseconds: 300)
      );
    }

    for (var addedItem in addedItems) {
      final index = newItems.indexOf(addedItem);
      widget.listKey.currentState?.insertItem(index,duration: Duration(milliseconds: 300));
    }
  }

  Widget _buildRemovedItem(TodoModel item, Animation<double> animation) {
    final begin = widget.isCompleteList ? Offset(0, -1) : Offset(0, 1);
    const end = Offset.zero;
    const curve = Curves.ease;

    final tween = Tween(begin: begin, end: end);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: TodoItem(item: item),
    );
    // );
  }

  Widget _buildItemWithAnimation(
      BuildContext context, TodoModel item, Animation<double> animation) {
    final begin = widget.isCompleteList ? Offset(0, -1) : Offset(0, 1);
    const end = Offset.zero;
    const curve = Curves.ease;

    final tween = Tween(begin: begin, end: end);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: TodoItem(item: item),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: ModColorStyle.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedList(
          key: widget.listKey,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          initialItemCount: widget.listItem.length,
          itemBuilder: (context, index, animation) {
            final item = widget.listItem[index];
            return widget.isCompleteList
                ? _buildItemWithAnimation(context, item, animation)
                : InkWell(
                    onTap: () async {
                      final res =
                          await Navigator.of(context).push(createRoute(AddTaskScreen(item: item)));
                      if (res is TodoModel) {
                        context.read<HomeViewModel>().updateTodo(res);
                      }
                    },
                    child: _buildItemWithAnimation(context, item, animation),
                  );
          },
        ),
      ),
    );
  }

}
