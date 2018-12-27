import 'dart:io';

class FlutterRunner {

  FlutterRunner(this.projectPath);

  final String projectPath;

  Process _activeProcess;

  void coldStart() {
    Process.start("F:\\flutter_test\\flutter\\bin\\flutter.bat", ["run", "-d192.168.0.101:5555"], workingDirectory: projectPath).then((process) {
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