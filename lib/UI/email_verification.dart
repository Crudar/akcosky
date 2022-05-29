import 'package:akcosky/cubit/registerfinal/registerfinal_cubit.dart';
import 'package:akcosky/resources/RegisterRepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailVerification extends StatelessWidget{
  final RegisterRepository registerRepository;
  const EmailVerification({Key? key, required this.registerRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterFinalCubit(registerRepository),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    //TODO ADD KEYBOARD VISIBILITY - IF OFF SHOW AT BOTTOM
                      const SnackBar(
                          content: Text("Chybný overovací kód"),
                      )
                  );
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
    var verificationInput = TextEditingController();

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: TextField(
                  controller: verificationInput,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Zadaj overovací kód z e-mailu',
                    prefixIcon: Icon(FontAwesomeIcons.key, color: Colors.white),
                  ),
                  style: Theme_.lightTextTheme.headline3,
                ),
              ),
              Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Builder(builder: (context) => ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<RegisterFinalCubit>(context).checkVerificationCode(verificationInput.text);
                          },
                          child: const Icon(FontAwesomeIcons.arrowRight),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            primary: Color(0xff000428), // <-- Button color
                            onPrimary: Colors.white, // <-- Splash color
                          )
                      )
                    )
                  )
              )
            ],
          ),
        ),
      ],
    );
  }
}