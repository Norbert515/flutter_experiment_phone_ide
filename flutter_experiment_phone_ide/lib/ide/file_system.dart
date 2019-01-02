import 'package:flutter/material.dart';
import 'package:flutter_experiment_phone_ide/ide/v1.dart';
import 'package:path/path.dart' as path;

typedef OnFileSelected = Function(String name);

class FileEntryWidget extends StatelessWidget {
  const FileEntryWidget({Key key, this.ideEntity, this.onFileSelected, this.selectedFile, this.textColor}) : super(key: key);

  final IDEEntity ideEntity;

  final OnFileSelected onFileSelected;

  final String selectedFile;

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    if (ideEntity.isFile) {
      return InkWell(
        onTap: () {
          onFileSelected(ideEntity.name);
        },
        child: Container(
          color: selectedFile == ideEntity.name ? Color(0xff2b62cd) : Colors.transparent,
          padding: EdgeInsets.all(8),
          height: 30,
          child: SizedBox.expand(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    path.basename(ideEntity.name),
                    style: TextStyle(color: textColor),
                  ))),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            height: 50.0,
            child:
            SizedBox.expand(child: Align(alignment: Alignment.centerLeft, child: Text(path.basename(ideEntity.name), style: TextStyle(color: textColor)))),
          ),
        ]..addAll(ideEntity.files
            .map((it) => Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: FileEntryWidget(
            textColor: textColor,
            ideEntity: it,
            onFileSelected: onFileSelected,
            selectedFile: selectedFile,
          ),
        ))
            .toList()),
      );
    }
  }
}