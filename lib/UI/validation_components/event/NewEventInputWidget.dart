import 'package:akcosky/UI/validation_components/PasswordInputWidget.dart';
import 'package:akcosky/UI/validation_components/PasswordInputWidgetWithCubit.dart';
import 'package:akcosky/UI/validation_components/UsernameInputWidget.dart';
import 'package:akcosky/cubit/authentication/authentication_cubit.dart';
import 'package:akcosky/models/validation/StringInput.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:akcosky/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../cubit/validation/validation_cubit.dart';

class NewEventInputWidget extends StatelessWidget{
  const NewEventInputWidget({Key? key, required this.focusNode, required this.element_, this.keyboard = TextInputType.text, required this.icon,
    required this.hintText, required this.errorText}) : super(key: key);

  final FocusNode focusNode;
  final ValidationElement element_;

  final TextInputType keyboard;
  final IconData icon;
  final String hintText;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: BlocBuilder<ValidationCubit, ValidationState>(
          builder: (context, state) {
            StringInput input = context.read<ValidationCubit>().inputsMap[element_] as StringInput;

            return TextFormField(
              initialValue: input.value,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: Icon(icon, color: Colors.white),
                errorStyle: const TextStyle(color: Colors.yellow),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.white,
                    )
                ),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.yellow,
                    )
                ),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.yellow,
                    )
                ),
                errorText: input.invalid
                    ? errorText
                    : null,
              ),
              keyboardType: keyboard,
              maxLines: null,
              onChanged: (value) {

                context.read<ValidationCubit>().onNewEventInputChanged(value, element_);
              },
              textInputAction: TextInputAction.next,
              style: Theme_.lightTextTheme.headline3,
            );
          },
        )
    );
  }
}