import 'package:rpc/rpc.dart';

import 'file_server.dart';
import 'models.dart';
import 'package:path/path.dart' as path;

@ApiClass(version: 'v1', name: "test")
class API {

  API(this.projectDir):
    fileServer = FileServer(path.join(projectDir, "lib"));

  final FileServer fileServer;

  final String projectDir;

  @ApiMethod(method: 'GET', path: 'listFiles')
  List<IDEEntity> getResource({String name}) {
    return fileServer.getAllFiles();
  }

  @ApiMethod(method: 'GET', path: 'test')
  Stuff updateResource({String name}) {
    return Stuff()..hi = "YOOOOO";
  }
}

class Stuff {
  String hi;
}