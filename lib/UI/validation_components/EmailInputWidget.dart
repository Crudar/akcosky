import 'package:akcosky/cubit/validation/validation_cubit.dart';
import 'package:akcosky/models/validation/EmailAdditional.dart';
import 'package:flutter/material.dart';
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

            EmailAdditional? emailAdditional = context.read<ValidationCubit>().inputsMap[ValidationElement.emailAdditional] as EmailAdditional?;

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
                errorText: determineErrorMessage(emailValue, emailAdditional),
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

  String? determineErrorMessage(EmailInput emailValue, EmailAdditional? emailAdditional){
    if(emailAdditional != null){
      if(emailAdditional.invalid){
        if(emailAdditional.error == EmailAdditionalError.collision){
          return "Zadaný email sa už používa.";
        }
      }
    }

    if(emailValue.invalid){
      return "Zadaný e-mail je v zlom formáte";
    }

    return null;
  }
}