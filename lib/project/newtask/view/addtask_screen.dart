import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/components/buttons.dart';
import 'package:todo_app/components/text_field.dart';
import 'package:todo_app/project/newtask/view_model/newtask_viewmodel.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';
import 'package:todo_app/utils/convert_utils.dart';
import 'package:todo_app/utils/device_info.dart';
import 'package:todo_app/utils/loading.dart';
import 'package:todo_app/utils/show_dialog.dart';

import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/utils/validate.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, this.item});

  final TodoModel? item;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController _titleTEC = TextEditingController();
  TextEditingController _dateTEC = TextEditingController();
  TextEditingController _timeTEC = TextEditingController();
  TextEditingController _notesTEC = TextEditingController();
  Category? _category;
  bool _hasInteracted = false;
  bool _isUpdate = false;
  DateTime? _now;

  @override
  void initState() {
    super.initState();
    _isUpdate = widget.item != null;
    if (_isUpdate) {
      _titleTEC.text = widget.item?.title ?? '';
      _dateTEC.text = widget.item?.dueDate ?? '';
      _timeTEC.text = widget.item?.dueTime ?? '';
      _notesTEC.text = widget.item?.notes ?? '';
      _category = Category.values.firstWhere((element) => element.name == widget.item?.category);
    }
  }

  bool _getOpacity(Category cat) {
    return _category == cat || _category == null;
  }

  Future<void> _getDate(TextEditingController tec) async {
    final res = await showDatePicker(
        context: context,
        currentDate: _now ?? DateTime.now(),
        initialDate: _now ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 2));
    if (res != null) {
      _now = res;
      tec.text = ConvertUtils.dMy(_now);
    }
  }

  Future<void> _getTime(TextEditingController tec) async {
    final res =
        await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
    if (res != null) {
      tec.text = ConvertUtils.hms(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NewTaskViewModel()..setCategory(_category),
      builder: (context, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: ModColorStyle.background,
          appBar: _buildAppBar,
          body: _buildBody(context),
          bottomNavigationBar: BottomAppBar(
              color: ModColorStyle.background,
              child: Selector<NewTaskViewModel,bool>(
                selector: (context, vm) => vm.emptyCategory,
                builder: (context, value, child) {
                  print('build button');
                  return normalCupertinoButton(
                      onPress: value
                          ? null
                          : () {
                              if (!_hasInteracted) {
                                _hasInteracted = true;
                                setState(() {});
                              }
                              if (_key.currentState!.validate()) {
                                onButtonPress(context);
                              }
                            },
                      title: _isUpdate ? S.of(context).addTask_Update : S.of(context).addTask_Save);
                },

                // child: normalCupertinoButton(
                //     onPress: _category == null
                //         ? null
                //         : () {
                //             if (!_hasInteracted) {
                //               _hasInteracted = true;
                //               setState(() {});
                //             }
                //             if (_key.currentState!.validate()) {
                //               onButtonPress(context);
                //             }
                //           },
                //     title: _isUpdate ? S.of(context).addTask_Update : S.of(context).addTask_Save),
              )),
        ),
      ),
    );
  }

  ///Widgets
  AppBar get _buildAppBar {
    return AppBar(
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
                  S.of(context).addTask_AddTask,
                  style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
                ),
                const SizedBox(
                  height: 48,
                  width: 48,
                )
              ],
            ),
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final width = size.width;
    final height = size.height;
    return Form(
        key: _key,
        autovalidateMode:
            _hasInteracted ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: (DeviceInfo().isIos && width > height)
              ? EdgeInsets.fromLTRB(padding.left + 8, 16, padding.right + 8, 16)
              : const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              _buildTaskTitle,
              const SizedBox(
                height: 24,
              ),
              _buildCategory(context),
              const SizedBox(
                height: 24,
              ),
              _buildDateAndTime,
              const SizedBox(
                height: 24,
              ),
              _buildNotes
            ],
          ),
        ));
  }

  Widget get _buildTaskTitle {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetLabel(label: S.of(context).addTask_TaskTitle),
        const SizedBox(
          height: 4,
        ),
        normalTextFormField(
          S.of(context).addTask_TaskTitle,
          _titleTEC,
          validator: (value) {
            if (_hasInteracted) {
              return CommonValidate.validateEmpty(value, context);
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget get _buildDateAndTime {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetLabel(label: S.of(context).addTask_Date),
              const SizedBox(
                height: 4,
              ),
              normalTextFormField(
                S.of(context).addTask_Date,
                _dateTEC,
                readOnly: true,
                image: Image.asset('assets/images/calendar.png'),
                onTap: () {
                  _getDate(_dateTEC);
                },
                validator: (value) {
                  if (_hasInteracted) {
                    return CommonValidate.validateEmpty(value, context);
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
              GetLabel(label: S.of(context).addTask_Time),
              const SizedBox(
                height: 4,
              ),
              normalTextFormField(S.of(context).addTask_Time, _timeTEC,
                  readOnly: true, image: Image.asset('assets/images/clock.png'), onTap: () {
                _getTime(_timeTEC);
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(BuildContext context) {
    return Row(
      children: [
        GetLabel(label: S.of(context).addTask_Category),
        const SizedBox(
          width: 16,
        ),
        for (int i = 0; i < Category.values.length; i++)
          Selector<NewTaskViewModel, Category?>(
              selector: (context, vm) => vm.category,
              builder: (context, value, child) {
                print('build category');
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      if (_category == null || _category != Category.values[i]) {
                        _category = Category.values[i];
                      } else {
                        _category = null;
                      }
                      context.read<NewTaskViewModel>().setCategory(_category);
                      // setState(() {});
                    },
                    child: Opacity(
                        opacity: _getOpacity(Category.values[i]) ? 1 : 0.3,
                        child: Image.asset('assets/images/${Category.values[i].name}.png')),
                  ),
                );
              }

              // child: Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: InkWell(
              //     onTap: () {
              //       if (_category == null || _category != Category.values[i]) {
              //         _category = Category.values[i];
              //       } else {
              //         _category = null;
              //       }
              //       context.read<NewTaskViewModel>().setCategory(_category);
              //       // setState(() {});
              //     },
              //     child: Opacity(
              //         opacity: _getOpacity(Category.values[i]) ? 1 : 0.3,
              //         child: Image.asset('assets/images/${Category.values[i].name}.png')),
              //   ),
              // ),
              )
      ],
    );
  }

  Widget get _buildNotes {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetLabel(label: S.of(context).addTask_Notes),
        const SizedBox(
          height: 4,
        ),
        normalTextFormField(S.of(context).addTask_Notes, _notesTEC, maxLine: 6)
      ],
    );
  }

  ///Function
  Future<void> onButtonPress(BuildContext context) async {
    ShowLoading.loadingDialog(context);
    final provider = context.read<NewTaskViewModel>();
    final todo = TodoModel(

        ///Id is auto incremented in db
        id: _isUpdate ? widget.item?.id : null,
        title: _titleTEC.text,
        category: _category!.name,
        dueDate: _dateTEC.text,
        dueTime: _timeTEC.text,
        notes: _notesTEC.text,
        userId: Supabase.instance.client.auth.currentUser!.id,
        deviceId: widget.item?.deviceId ?? DeviceInfo().deviceId);
    final res = _isUpdate ? await provider.updateTodo(todo) : await provider.addTodo(todo);
    if (context.mounted) {
      Navigator.pop(context);
      if (res is TodoModel) {
        Navigator.of(context).pop(res);
        showDialog(
          context: context,
          builder: (context) =>
              CommonDialog(type: EnumTypeDialog.success, title: S.of(context).common_Success),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => CommonDialog(
            type: EnumTypeDialog.error,
            title: S.of(context).common_Error,
            subtitle: provider.errorMessage,
          ),
        );
      }
    }
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
