import 'package:akcosky/models/TypeEnum.dart';

String getColumnName(TypeEnum type){
  switch(type){
    case TypeEnum.place:{
      return "Miesto";
    }
    case TypeEnum.transport:{
      return "Transport";
    }
    case TypeEnum.accommodation:{
      return "Ubytovanie";
    }
    case TypeEnum.estimatedAmount:{
      return "OdhadovanaCena";
    }
    default:{
      return "Else";
    }
  }
}