import 'dart:io';
import 'package:path/path.dart' as path;

import 'models.dart';


class FileServer {

  FileServer(this.srcDir);

  // Directory containing all the files
  final String srcDir;



  // Returns all files for this project
  List<IDEEntity> getAllFiles({String dir}) {
    List<FileSystemEntity> entries = Directory(dir?? srcDir).listSync();

    List<IDEEntity> result = [];

    for(FileSystemEntity entry in entries) {
      FileStat stat = entry.statSync();
      if(stat.type == FileSystemEntityType.directory) {
        result.add(IDEEntity(name: path.basename(entry.path), files: getAllFiles(dir: entry.path), isFile: false));
      } else {
        result.add(IDEEntity(name: path.basename(entry.path), files: [], isFile: true));
      }
    }
    return result;
   // List<String> paths = entries.map((it) => path.relative(it.path, from: srcDir)).toList();
   // return paths;
  }

  // Reads the file content
  void openFile() {

  }

  void replaceFile(String filePath, String content) {

  }



}