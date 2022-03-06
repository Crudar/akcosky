import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class VerificationCodeSender{

  static Future<bool> Send(String whomToSend, String verificationCode) async {
    const String emailLogin = "akcoskyapp@gmail.com";
    const String emailPass = "qcfuqujisxidsxyq";

    final smtpServer = gmail(emailLogin, emailPass);

    final message = Message();
    message.recipients.add(whomToSend);
    message.from = emailLogin;
    message.subject = "Akcošky - verifikačný kód";
    message.html = "<!DOCTYPE html><html><head><link href='https://fonts.googleapis.com/css?family=Open Sans' rel='stylesheet'></head><body><div style=\"display: flex; align-items: center; background-image: linear-gradient(#240b36, #c31432)\">		<div style=\"font-family: 'Open Sans'; font-size: 35px; padding-left: 15px; color: white\">		<p>AKCOŠKY</p>	</div></div><h2>Verifikačný kód</h2><hr><p>Pre verifikáciu tohto emailu zadaj v aplikácií nasledujúci kód:</p><b style=\"padding-top:20px; padding-bottom:40px; font-size: 30px\">{VerificationCode}</b><p>V prípade, že kód nebol vyžiadaný tebou nemusíš nič robiť.</p>	<p style=\"color:gray\">Automatická správa. Prosím, neodpovedaj na ňu.</p></body></html>";
    message.html = message.html?.replaceFirst("{VerificationCode}", verificationCode);

    try{
      final send_ = await send(message, smtpServer);
      return true;
    }on SocketException{
      return false;
    }
  }
}