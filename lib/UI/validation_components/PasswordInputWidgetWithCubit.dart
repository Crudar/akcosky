import 'package:flutter/cupertino.dart';

import '../../cubit/validation/validation_cubit.dart';
import 'PasswordInputWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordInputWidgetWithCubit extends StatelessWidget {
  const PasswordInputWidgetWithCubit({Key? key, required this.focusNode, required this.passwordAgain}) : super(key: key);

  final bool passwordAgain;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValidationCubit, ValidationState>(
        builder: (context, state) {
          return Column(
            children: [
              PasswordInputWidget(focusNode: focusNode, passwordAgain: passwordAgain),
            ],
          );
        }
    );
  }
}