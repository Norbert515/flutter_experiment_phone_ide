import 'package:flutter/material.dart';
import 'package:flutter_experiment_phone_ide/ide/ide.dart';
import 'package:flutter_experiment_phone_ide/ide/live-reload-controllers.dart';

// TODO this stays the same, only the type changes
ControllableDouble $DEFAULT_DOUBLE_CONTROLLER$ = ControllableDouble(20.0);
ControllableColor $DEFAULT_COLOR_CONTROLLER$ = ControllableColor(Colors.red);
ControllableMaterialColor $DEFAULT_MATERIAL_COLOR_CONTROLLER$ = ControllableMaterialColor(Colors.red);
ControllableString $DEFAULT_STRING_CONTROLLER$ = ControllableString("");
//Color $DEFAULT_CONTROLLER$ = Color(0xffff0000);


// TODO move this into some sort of registry

ControllableValue getController(ReloadType selectedReloadType) {
  switch(selectedReloadType) {
      case ReloadType.DOUBLE:
        return $DEFAULT_DOUBLE_CONTROLLER$;
      case ReloadType.COLOR:
        return $DEFAULT_COLOR_CONTROLLER$;
      case ReloadType.MATERIAL_COLOR:
        return $DEFAULT_MATERIAL_COLOR_CONTROLLER$;
      case ReloadType.STRING:
        return $DEFAULT_STRING_CONTROLLER$;
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
    case ReloadType.STRING:
      $DEFAULT_STRING_CONTROLLER$ = value;
  }
}

String getControllerCode(ReloadType selectedReloadType) {
  switch(selectedReloadType) {
    case ReloadType.DOUBLE:
      return'\$DEFAULT_DOUBLE_CONTROLLER\$.value';
    case ReloadType.COLOR:
      return'\$DEFAULT_COLOR_CONTROLLER\$.value';
    case ReloadType.MATERIAL_COLOR:
      return'\$DEFAULT_MATERIAL_COLOR_CONTROLLER\$.value';
    case ReloadType.STRING:
      return'\$DEFAULT_STRING_CONTROLLER\$.value';

  }
}

Widget getControllerWidget(ReloadType selectedReloadType, ValueChanged changeValue) {
  switch(selectedReloadType) {
    case ReloadType.DOUBLE:
      return LiveSliderController(
        value: $DEFAULT_DOUBLE_CONTROLLER$.value,
        onChanged: changeValue,
      );
    case ReloadType.COLOR:
      return LiveColorController(
        value: $DEFAULT_COLOR_CONTROLLER$.value,
        onChanged: changeValue,
      );
    case ReloadType.MATERIAL_COLOR:
      return LiveMaterialColorController(
        value: $DEFAULT_MATERIAL_COLOR_CONTROLLER$.value,
        onChanged: changeValue,
      );
    case ReloadType.STRING:
      return LiveStringController(
        value: $DEFAULT_STRING_CONTROLLER$.value,
        onChanged: changeValue,
      );
  }
}