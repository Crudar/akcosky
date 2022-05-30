import 'package:akcosky/cubit/validation/validation_cubit.dart';
import 'package:flutter/material.dart';
import '../../cubit/registerstart/registerstart_cubit.dart';
import '../../models/validation/EmailInput.dart';
import '../../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmailInputWidget extends StatelessWidget {
  const EmailInputWidget({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: BlocBuilder<ValidationCubit, ValidationState>(
          builder: (context, state) {
            EmailInput emailValue = context.read<ValidationCubit>().inputsMap[ValidationElement.email] as EmailInput;

            return TextFormField(
              initialValue: emailValue.value,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Zadaj e-mail',
                prefixIcon: const Icon(FontAwesomeIcons.envelope, color: Colors.white),
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
                errorText: emailValue.invalid
                    ? 'Zadaný e-mail je v zlom formáte'
                    : null,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {

                context.read<ValidationCubit>().onEmailChanged(value);
              },
              textInputAction: TextInputAction.next,
              style: Theme_.lightTextTheme.headline3,
            );
          },
        )
    );
  }
}