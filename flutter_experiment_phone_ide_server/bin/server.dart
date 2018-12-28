import 'dart:io';

import 'package:args/args.dart';
import 'package:rpc/rpc.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:path/path.dart' as path;
import 'api.dart';
import 'file_server.dart';

ApiServer _apiServer = ApiServer(prettyPrint: true);

main(List<String> args) async {
  var parser = ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080')
    ..addOption('projectPath', abbr: 'r')
    ..addOption('deviceId', abbr: 'i');

  var result = parser.parse(args);

  var port = int.tryParse(result['port']);

  if (port == null) {
    stdout.writeln(
        'Could not parse port value "${result['port']}" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  String projectPath = result['projectPath'];

  if(projectPath == null || projectPath.isEmpty) {
    stdout.writeln('The project path can not but null or empty');
    exitCode = 64;
    return;
  }

  File pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
  if(!pubspecFile.existsSync()) {
    stdout.writeln("Could not find ${pubspecFile.path}");
    exitCode = 64;
    return;
  }

  String deviceId = result['deviceId'];
  if(deviceId == null || deviceId.isEmpty) {
    stdout.writeln('You need to provide an adb device id to run on');
    exitCode = 64;
    return;
  }

  _apiServer.addApi(API(projectPath, deviceId));
  _apiServer.enableDiscoveryApi();


  HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, 8080,);
 // print('Serving at http://${server.address.host}:${server.port}');


  // Get the ip to run on
  ProcessResult processResult = await Process.run('ipconfig', []);
  final String ipconfigResult = processResult.stdout;
  final String ip = ipconfigResult.split("\n")
      .map((it) => it.replaceAll(" ", ""))
      .where((it) => it.startsWith("IPv4"))
      .where((it) => !it.contains("192.168.")).first;
  String actualIp = ip.split("....:")[1];
  // Last character is something werid
  actualIp = actualIp.substring(0, actualIp.length - 1);

  print('Open "http://${actualIp}:${server.port}/test/v1/coldStart" on your device to open the app');
  server.listen((it) {
    print("Got request ${it.uri}");
    _apiServer.httpRequestHandler(it);
  });

 /* var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler((shelf.Request request) {
  });
*/
//  var server = await io.serve(handler, 'localhost', port);

  //print('Serving at http://${server.address.host}:${server.port}');
}

//shelf.Response _echoRequest(shelf.Request request) =>
  //  shelf.Response.ok('Request for "${request.url}"');
