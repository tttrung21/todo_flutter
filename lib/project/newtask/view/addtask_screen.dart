import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/components/text_field.dart';
import 'package:todo_app/project/providers/todo_provider.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/utils/convert_utils.dart';
import 'package:todo_app/utils/loading.dart';
import 'package:todo_app/utils/show_dialog.dart';

import '../../../generated/l10n.dart';
import '../../../model/todo_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController titleTEC = TextEditingController();
  TextEditingController dateTEC = TextEditingController();
  TextEditingController timeTEC = TextEditingController();
  TextEditingController notesTEC = TextEditingController();
  Category? _category;
  bool _hasInteracted = false;
  DateTime? now;

  bool getOpacity(Category cat) {
    return _category == cat || _category == null;
  }

  bool isIos() {
    return Platform.isIOS;
  }

  Future<void> getDate(TextEditingController tec) async {
    final res = await showDatePicker(
        context: context,
        currentDate: now ?? DateTime.now(),
        initialDate: now ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 2));
    if (res != null) {
      now = res;
      tec.text = ConvertUtils.dMy(now);
    }
  }

  Future<void> getTime(TextEditingController tec) async {
    final res = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(now ?? DateTime.now()));
    if (res != null) {
      // final min = res.minute < 10 ? '0${res.minute}' : '${res.minute}';
      // tec.text = '${res.hour}:$min ${res.period.name.toUpperCase()}';
      tec.text = ConvertUtils.hms(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ModColorStyle.background,
        appBar: AppBar(
          toolbarHeight: 86,
          backgroundColor: ModColorStyle.primary,
          leading: const SizedBox(),
          leadingWidth: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 20, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/images/back.png',
                          width: 48,
                        )),
                    Text(
                      S.of(context).addTask_ThemViec,
                      style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
                    ),
                    const SizedBox(
                      height: 48,
                      width: 48,
                    )
                  ],
                ),
              )),
        ),
        body: Form(
            key: _key,
            autovalidateMode:
                _hasInteracted ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: (isIos() && width > height)
                  ? EdgeInsets.fromLTRB(mq.padding.left, 16, mq.padding.right, 16)
                  : const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  GetLabel(label: S.of(context).addTask_TieuDeViec),
                  const SizedBox(
                    height: 4,
                  ),
                  normalTextFormField(
                    S.of(context).addTask_TieuDeViec,
                    titleTEC,
                    validator: (value) {
                      if (value!.isEmpty && _hasInteracted) {
                        return S.of(context).common_LoiThongTinTrong;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      GetLabel(label: S.of(context).addTask_Loai),
                      const SizedBox(
                        width: 16,
                      ),
                      for (int i = 0; i < Category.values.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: () {
                              if (_category == null || _category != Category.values[i]) {
                                _category = Category.values[i];
                              } else {
                                _category = null;
                              }
                              setState(() {});
                            },
                            child: Opacity(
                                opacity: getOpacity(Category.values[i]) ? 1 : 0.3,
                                child: Image.asset('assets/images/${Category.values[i].name}.png')),
                          ),
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GetLabel(label: S.of(context).addTask_Ngay),
                            const SizedBox(
                              height: 4,
                            ),
                            normalTextFormField(
                              S.of(context).addTask_Ngay,
                              dateTEC,
                              readOnly: true,
                              image: Image.asset('assets/images/calendar.png'),
                              onTap: () {
                                getDate(dateTEC);
                              },
                              validator: (value) {
                                if (value!.isEmpty && _hasInteracted) {
                                  return S.of(context).common_LoiThongTinTrong;
                                }
                                return null;
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GetLabel(label: S.of(context).addTask_Gio),
                            const SizedBox(
                              height: 4,
                            ),
                            normalTextFormField(S.of(context).addTask_Gio, timeTEC,
                                readOnly: true,
                                image: Image.asset('assets/images/clock.png'), onTap: () {
                              getTime(timeTEC);
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GetLabel(label: S.of(context).addTask_GhiChu),
                  const SizedBox(
                    height: 4,
                  ),
                  normalTextFormField(S.of(context).addTask_Gio, notesTEC, maxLine: 6)
                ],
              ),
            )),
        bottomNavigationBar: BottomAppBar(
          color: ModColorStyle.background,
          child: CupertinoButton(
            borderRadius: BorderRadius.circular(50),
            padding: EdgeInsets.zero,
            disabledColor: ModColorStyle.disable,
            color: ModColorStyle.primary,
            onPressed: _category == null
                ? null
                : () async {
                    if (!_hasInteracted) {
                      _hasInteracted = true;
                      setState(() {});
                    }
                    if (_key.currentState!.validate()) {
                      ShowLoading.loadingDialog(context);
                      final provider = Provider.of<TodoProvider>(context, listen: false);
                      final res = await provider.addTodo(TodoModel(
                          title: titleTEC.text,
                          category: _category!.name,
                          dueDate: dateTEC.text,
                          dueTime: timeTEC.text,
                          notes: notesTEC.text,
                          userId: Supabase.instance.client.auth.currentUser!.id));
                      if (context.mounted) {
                        Navigator.pop(context);
                        if (res) {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => CommonDialog(
                                type: EnumTypeDialog.success,
                                title: S.of(context).common_ThanhCong),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => CommonDialog(
                              type: EnumTypeDialog.error,
                              title: S.of(context).common_LoiXayRa,
                              subtitle: provider.errorMessage,
                            ),
                          );
                        }
                      }
                    }
                  },
            child: Text(
              S.of(context).addTask_Luu,
              style: ModTextStyle.button1.copyWith(),
            ),
          ),
        ),
      ),
    );
  }
}

class GetLabel extends StatelessWidget {
  const GetLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: ModTextStyle.label.copyWith(color: ModColorStyle.title),
    );
  }
}
