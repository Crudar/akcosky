import 'package:akcosky/cubit/validation/validation_cubit.dart';
import 'package:flutter/material.dart';
import '../../cubit/registerstart/registerstart_cubit.dart';
import '../../models/validation/NonAuthenticated.dart';
import '../../models/validation/StringInput.dart';
import '../../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordInputWidget extends StatelessWidget {
  const PasswordInputWidget({Key? key, required this.focusNode, required this.passwordAgain}) : super(key: key);

  final bool passwordAgain;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    StringInput passwordValue = context.read<ValidationCubit>().inputsMap[ValidationElement.password] as StringInput;
    NonAuthenticated nonauthenticated = context.read<ValidationCubit>().inputsMap[ValidationElement.nonauthenticated] as NonAuthenticated;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: TextFormField(
          initialValue: passwordValue.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Zadaj heslo',
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
            errorText: determineErrorMessage(passwordValue, nonauthenticated),
          ),
          keyboardType: TextInputType.text,
          obscureText: true,
          onChanged: (value) {

            context.read<ValidationCubit>().onPasswordChanged(value);

            if(passwordAgain) {
              context.read<ValidationCubit>().onPasswordAgainUnfocused();
            }
          },
          textInputAction: TextInputAction.next,
          style: Theme_.lightTextTheme.headline3,
        )
    );
  }

  String? determineErrorMessage(StringInput passwordValue, NonAuthenticated nonauthenticated){
    if(passwordValue.invalid){
      return "Heslo nesmie byť prázdne";
    }

    if(nonauthenticated.invalid){
      return "Zadané používateľské meno alebo heslo je neplatné";
    }

    return null;

  }

}