import 'package:akcosky/UI/validation_components/VerificationCodeInputWidget.dart';
import 'package:akcosky/cubit/registerfinal/registerfinal_cubit.dart';
import 'package:akcosky/models/validation/VerificationCodeInput.dart';
import 'package:akcosky/models/validation/VerificationCodeSuccess.dart';
import 'package:akcosky/resources/RegisterRepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import '../cubit/validation/validation_cubit.dart';
import '../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailVerification extends StatelessWidget {

  const EmailVerification({Key? key, required this.registerRepository}) : super(key: key);

  final RegisterRepository registerRepository;

  @override
  Widget build(BuildContext context) {

    Map<ValidationElement, FormzInput> input = {
      ValidationElement.verificationCode: VerificationCodeInput.pure(""),
      ValidationElement.verificationCodeFailure: VerificationCodeFailure.pure()
    };

    return BlocProvider<ValidationCubit>(
      create: (BuildContext context) => ValidationCubit(inputsMap: input),
      child: EmailVerificationForm(registerRepository: registerRepository),
    );
  }
}

class EmailVerificationForm extends StatefulWidget{
  const EmailVerificationForm({Key? key, required this.registerRepository}) : super(key: key);
  final RegisterRepository registerRepository;

  @override
  State<EmailVerificationForm> createState() => _VerificationState();
}

class _VerificationState extends State<EmailVerificationForm>{
  final _verificationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _verificationFocusNode.addListener(() {
      if (!_verificationFocusNode.hasFocus) {
        context.read<ValidationCubit>().onVerificationCodeUnfocused();
        //FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _verificationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterFinalCubit(widget.registerRepository),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0xff240b36),
                        Color(0xffc31432)
                      ]
                  )
              ),
            child: BlocConsumer<RegisterFinalCubit, RegisterFinalState>(
              listener: (context, state){
                if(state is RegisterFinalInitial){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Overovací kód bol odoslaný na email") //TODO show snackbar on navigation to authentication screen
                      )
                  );
                }
                else if (state is RegisterFinalError){
                  context.read<ValidationCubit>().onVerificationCodeFailure();
                }
                else if (state is RegisterFinalSuccess){
                  //Navigator.popUntil(context, ModalRoute.withName('/'));
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                }
              },
              builder: (context, state){
                return buildInitialRegisterFinalForm();
              }
            )
          )
        )
      );
    }
  Widget buildInitialRegisterFinalForm(){

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Text(
            'Overenie \n e-mailom',
            style: Theme_.lightTextTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
               VerificationCodeInputWidget(focusNode: _verificationFocusNode),
              const Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: SubmitButtonWidget()
                  )
              )
            ],
          ),
        ),
      ],
    );
  }
}

class SubmitButtonWidget extends StatelessWidget{
  const SubmitButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValidationCubit, ValidationState>(
      //buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state){
          return ElevatedButton(
              onPressed: context.read<ValidationCubit>().status.isValidated
                  ? () => BlocProvider.of<RegisterFinalCubit>(context).checkVerificationCode(context.read<ValidationCubit>().inputsMap[ValidationElement.verificationCode]?.value)
                  : null,
              child: const Icon(FontAwesomeIcons.arrowRight),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                primary: Color(0xff000428), // <-- Button color
                onSurface: Colors.black,
                onPrimary: Colors.white, // <-- Splash color
              )
          );
        }
    );
  }
}