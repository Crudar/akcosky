import 'package:akcosky/cubit/validation/validation_cubit.dart';
import 'package:flutter/material.dart';
import '../../cubit/registerstart/registerstart_cubit.dart';
import '../../models/validation/StringInput.dart';
import '../../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UsernameInputWidget extends StatelessWidget {
  const UsernameInputWidget({Key? key, required this.focusNode})
      : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: BlocBuilder<ValidationCubit, ValidationState>(
          builder: (context, state) {
            StringInput usernameValue = context
                .read<ValidationCubit>()
                .inputsMap[ValidationElement.username] as StringInput;

            return TextFormField(
              initialValue: usernameValue.value,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Zadaj prihlasovacie meno',
                prefixIcon:
                    const Icon(FontAwesomeIcons.user, color: Colors.white),
                errorStyle: const TextStyle(color: Colors.yellow),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                  width: 1,
                  color: Colors.white,
                )),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                  width: 1,
                  color: Colors.yellow,
                )),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                  width: 1,
                  color: Colors.yellow,
                )),
                errorText: usernameValue.invalid
                    ? 'Prihlasovacie meno nesmie byť prázdne'
                    : null,
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                context.read<ValidationCubit>().onUsernameChanged(value);
              },
              textInputAction: TextInputAction.next,
              style: Theme_.lightTextTheme.headline3,
            );
          },
        ));
  }
}
