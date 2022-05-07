import 'TypeEnum.dart';

class Info<T>{
  TypeEnum type;
  T value;

  Info(this.type, this.value);
}