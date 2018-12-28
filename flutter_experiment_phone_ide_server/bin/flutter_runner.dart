import 'dart:io';
import 'package:path/path.dart' as path;
class FlutterRunner {

  FlutterRunner(this.projectPath, this.deviceId);

  final String projectPath;

  final String deviceId;

  Process _activeProcess;

  void coldStart() async {
    ProcessResult results = await Process.run('where flutter', []);

    String res = results.stdout;
    if(res == null ||res.isEmpty) {
      throw Exception("Flutter could not be found in path\n"
          "Check to see if 'where flutter' returns a vailid result. \n"
          "If you are on windows, simply add Flutter to your path");
    }
    String firstLine = res.split("\n")[0];
    List<String> it = path.context.split(firstLine);
    String directory = it.getRange(0, it.length - 1).join("${Platform.pathSeparator}");


    Process.start(path.join(directory, "flutter.bat"), ["run", "-d$deviceId"], workingDirectory: projectPath).then((process) {
      _activeProcess = process;
       stdout.addStream(process.stdout);
       stderr.addStream(process.stderr);
    });
  }

  void hotRestart() {
    if(_activeProcess != null) {
      _activeProcess.stdin.write("R");
    }
  }

  void hotReload() {
    if(_activeProcess != null) {
      _activeProcess.stdin.write("r");
    }
  }
}