import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';

enum EnumTypeDialog { success, error , warning }

class CommonDialog extends StatelessWidget {
  const CommonDialog({super.key, required this.type, required this.title, this.subtitle});

  final EnumTypeDialog type;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(
                  _buildType(),
                  size: 48,
                  color: _getTypeColor(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  title,
                  style: ModTextStyle.title2.copyWith(color: ModColorStyle.title),
                  textAlign: TextAlign.center,
                ),
              ),
              if (subtitle?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    subtitle ?? '',
                    style: ModTextStyle.label.copyWith(color: ModColorStyle.title.withOpacity(0.8)),
                    textAlign: TextAlign.center,
                  ),
                ),
              CupertinoButton(
                onPressed: () => Navigator.of(context).pop(true),
                padding: EdgeInsets.all(16),
                child: const Text('OK'),
              )
            ],
          ),
        ),
      ),
    );
  }

  IconData _buildType() {
    switch (type) {
      case EnumTypeDialog.error:
        return Icons.error;
      case EnumTypeDialog.success:
        return Icons.check_circle;
      case EnumTypeDialog.warning:
        return Icons.warning;
      default:
        return Icons.check_circle;
    }
  }

  Color _getTypeColor() {
    switch (type) {
      case EnumTypeDialog.error:
        return ModColorStyle.error;
      case EnumTypeDialog.success:
        return ModColorStyle.success;
      case EnumTypeDialog.warning:
        return ModColorStyle.warning;
      default:
        return ModColorStyle.primary;
    }
  }
}
