import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../cubit/validation/validation_cubit.dart';
import '../../models/validation/VerificationCodeInput.dart';
import '../../theme.dart';

class VerificationCodeInputWidget extends StatelessWidget {
  const VerificationCodeInputWidget({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: BlocBuilder<ValidationCubit, ValidationState>(
        builder: (context, state) {
          VerificationCodeInput verificationCode = context.read<ValidationCubit>().inputsMap[ValidationElement.verificationCode] as VerificationCodeInput;

          return TextFormField(
            initialValue: verificationCode.value,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Zadaj overovací kód z e-mailu',
              prefixIcon: const Icon(FontAwesomeIcons.key, color: Colors.white),
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
                  ),
              ),
              errorText: verificationCode.invalid ? returnErrorText(verificationCode) : null,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {

              context.read<ValidationCubit>().onVerificationCodeChanged(value);
            },
            style: Theme_.lightTextTheme.headline3,
          );
      }
      )
    );
  }

  String returnErrorText(VerificationCodeInput verificationError){
    switch(verificationError.error){
      case VerificationCodeInputError.empty: {
        return "Overovací kód nesmie byť prázdny";
      }

      case VerificationCodeInputError.wrongDigitCount:{
        return "Overovací kód musí byť 6 miestny";
      }

      case VerificationCodeInputError.isString:{
        return "Overovací kód musí byť číslo";
      }

      default :{
        return "";
      }
    }
  }

}

