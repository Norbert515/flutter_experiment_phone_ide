import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_colorpicker/material_picker.dart';


abstract class ControllableValue<T> {
  ControllableValue(this.value);

  final T value;
  String toCode();

  String toString() => toCode();
}

class ControllableDouble extends ControllableValue<double>{
  ControllableDouble(double value) : super(value);

  @override
  String toCode() {
    return value.toString();
  }

}

class ControllableColor extends ControllableValue<Color> {
  ControllableColor(Color value) : super(value);

  String toCode() {
    return value.toString();
  }
}

class ControllableMaterialColor extends ControllableValue<MaterialColor> {
  ControllableMaterialColor(Color value) : super(_colorToMaterialColor(value));

  static MaterialColor _colorToMaterialColor(Color color) {
    return MaterialColor(color.value, {
       50: color,
      100: color,
      200: color,
      300: color,
      400: color,
      500: color,
      600: color,
      700: color,
      800: color,
      900: color,
    });
  }

  Color get _onlyColor => Color(value.value);

  @override
  String toCode() {
    return 'MaterialColor(${value.value},'
        ' { '
        '50: $_onlyColor,'
        '100: $_onlyColor,'
        '200: $_onlyColor,'
        '300: $_onlyColor,'
        '400: $_onlyColor,'
        '500: $_onlyColor,'
        '600: $_onlyColor,'
        '700: $_onlyColor,'
        '800: $_onlyColor,'
        '900: $_onlyColor,'
        '})';
  }

}


abstract class StatelessLiveControllerWidget<T extends ControllableValue> extends StatelessWidget {

  const StatelessLiveControllerWidget({Key key, this.onChanged}): super(key: key);

  final ValueChanged<T> onChanged;
}

abstract class StatefulLiveControllerWidget<T extends ControllableValue> extends StatefulWidget {

  const StatefulLiveControllerWidget({Key key, this.onChanged}): super(key: key);

  final ValueChanged<T> onChanged;
}

class LiveSliderController extends StatelessLiveControllerWidget<ControllableDouble> {
  
  const LiveSliderController({Key key, this.value, ValueChanged<ControllableDouble> onChanged}) : super(key: key, onChanged: onChanged);
  
  final double value;

  
  @override
  Widget build(BuildContext context) {
    return CupertinoSlider(
      value: value,
      onChanged: (it) {
        onChanged(ControllableDouble(it));
      },
      min: 1,
      max: 100,
      divisions: 99,
    );
  }
}

class LiveColorController extends StatefulLiveControllerWidget<ControllableColor>{

  const LiveColorController({Key key, this.value, ValueChanged<ControllableColor> onChanged}) : super(key: key, onChanged: onChanged);

  final Color value;

  @override
  LiveColorControllerState createState() {
    return new LiveColorControllerState();
  }
}

class LiveColorControllerState extends State<LiveColorController> {

  // TODO hacky. The ColorPickers emits when the color is different, even in the construction frame
  // --> Ignore first value

  bool ignoredOne = false;


  void openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: widget.value,
              onColorChanged: (it) {
                if(ignoredOne) {
                  widget.onChanged(ControllableColor(it));
                }
                ignoredOne = true;
              },
              enableLabel: true,
            ),
            // Use Material color picker
            // child: MaterialPicker(
            //   pickerColor: pickerColor,
            //   onColorChanged: changeColor,
            //   enableLabel: true, // only on portrait mode
            // ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: openColorPicker,
      child: Text("Reopen", style: TextStyle(color: Colors.white),),
    );
  }

}

// TODO code duplication
class LiveMaterialColorController extends StatefulLiveControllerWidget<ControllableMaterialColor>{

  const LiveMaterialColorController({Key key, this.value, ValueChanged<ControllableMaterialColor> onChanged}) : super(key: key, onChanged: onChanged);

  final Color value;

  @override
  LiveMaterialColorControllerState createState() {
    return new LiveMaterialColorControllerState();
  }
}

class LiveMaterialColorControllerState extends State<LiveMaterialColorController> {


  // TODO hacky. The ColorPickers emits when the color is different, even in the construction frame
  // --> Ignore first value

  bool ignoredOne = false;


  void openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: widget.value,
              enableAlpha: false,
              onColorChanged: (it) {
                if(ignoredOne) {
                  widget.onChanged(ControllableMaterialColor(it));
                }
                ignoredOne = true;
              },
              enableLabel: true,
            ),
            // Use Material color picker
            // child: MaterialPicker(
            //   pickerColor: pickerColor,
            //   onColorChanged: changeColor,
            //   enableLabel: true, // only on portrait mode
            // ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: openColorPicker,
      child: Text("Reopen", style: TextStyle(color: Colors.white),),
    );
  }

}