import 'package:akcosky/cubit/validation/validation_cubit.dart';
import 'package:flutter/material.dart';
import '../../cubit/registerstart/registerstart_cubit.dart';
import '../../models/validation/PasswordAgainInput.dart';
import '../../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordAgainInputWidget extends StatelessWidget {
  const PasswordAgainInputWidget({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    PasswordAgainInput passwordAgainValue = context.read<ValidationCubit>().inputsMap[ValidationElement.passwordAgain] as PasswordAgainInput;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: TextFormField(
          initialValue: passwordAgainValue.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Zadaj heslo znova',
            prefixIcon: const Icon(FontAwesomeIcons.lock, color: Colors.white),
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
            errorText: passwordAgainValue.invalid ? returnErrorText(passwordAgainValue) : null,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {

            context.read<ValidationCubit>().onPasswordAgainChanged(value);
          },
          textInputAction: TextInputAction.next,
          style: Theme_.lightTextTheme.headline3,
        )
    );
  }

  String returnErrorText(PasswordAgainInput inputError){
    switch(inputError.error){
      case PasswordAgainInputError.invalid: {
        return "Heslo nesmie byť prázdne";
      }

      case PasswordAgainInputError.mismatch:{
        return "Heslá nie sú rovnaké";
      }

      default :{
        return "";
      }
    }
  }
}