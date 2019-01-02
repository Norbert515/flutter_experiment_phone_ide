


import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
class LiveSliderController extends StatelessWidget {
  
  const LiveSliderController({Key key, this.value, this.onChanged}) : super(key: key);
  
  final double value;
  final ValueChanged<double> onChanged;
  
  
  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      onChanged: onChanged,
      min: 1,
      max: 41,
      divisions: 40,
    );
  }
}

class LiveColorController extends StatefulWidget{

  const LiveColorController({Key key, this.value, this.onChanged}) : super(key: key);

  final Color value;
  final ValueChanged<Color> onChanged;

  @override
  LiveColorControllerState createState() {
    return new LiveColorControllerState();
  }
}

class LiveColorControllerState extends State<LiveColorController> {

  @override
  void initState() {
    super.initState();
    openColorPicker();
  }


  void openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: widget.value,
              onColorChanged: widget.onChanged,
              enableLabel: true,
              pickerAreaHeightPercent: 0.8,
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
      child: Text("Reopen"),
    );
  }

}