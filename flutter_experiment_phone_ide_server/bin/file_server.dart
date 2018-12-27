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
  }

  // Reads the file content
  String openFile(String relativePath) {
    String filePath = path.join(srcDir, relativePath);
    // Prevent reading outside project
    if(!path.isWithin(srcDir, filePath)) return "";
    File file = File(filePath);
    return file.readAsStringSync();
  }

  void replaceFile(String relativePath, String content) {
    String filePath = path.join(srcDir, relativePath);
    // Prevent writing outside project
    if(!path.isWithin(srcDir, filePath)) return;
    File file = File(filePath);
    file.writeAsStringSync(content, mode: FileMode.writeOnly);
  }



}