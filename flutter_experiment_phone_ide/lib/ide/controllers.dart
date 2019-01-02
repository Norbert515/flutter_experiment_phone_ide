import 'package:flutter/material.dart';
import 'package:flutter_experiment_phone_ide/ide/ide.dart';
import 'package:flutter_experiment_phone_ide/ide/live-reload-controllers.dart';

// TODO this stays the same, only the type changes
ControllableDouble $DEFAULT_DOUBLE_CONTROLLER$ = ControllableDouble(20.0);
ControllableColor $DEFAULT_COLOR_CONTROLLER$ = ControllableColor(Colors.red);
ControllableMaterialColor $DEFAULT_MATERIAL_COLOR_CONTROLLER$ = ControllableMaterialColor(Colors.red);
//Color $DEFAULT_CONTROLLER$ = Color(0xffff0000);


ControllableValue getController(ReloadType selectedReloadType) {
  switch(selectedReloadType) {
      case ReloadType.DOUBLE:
        return $DEFAULT_DOUBLE_CONTROLLER$;
      case ReloadType.COLOR:
        return $DEFAULT_COLOR_CONTROLLER$;
      case ReloadType.MATERIAL_COLOR:
        return $DEFAULT_MATERIAL_COLOR_CONTROLLER$;
    }
}


void setController(ControllableValue value, ReloadType selectedReloadType) {
  switch(selectedReloadType) {
    case ReloadType.DOUBLE:
      $DEFAULT_DOUBLE_CONTROLLER$ = value;
      return;
    case ReloadType.COLOR:
      $DEFAULT_COLOR_CONTROLLER$ = value;
      return;
    case ReloadType.MATERIAL_COLOR:
      $DEFAULT_MATERIAL_COLOR_CONTROLLER$ = value;
      return;
  }
}