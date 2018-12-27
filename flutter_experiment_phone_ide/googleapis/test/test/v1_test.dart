library googleapis.test.v1.test;

import "dart:core" as core;
import "dart:async" as async;
import "dart:convert" as convert;

import 'package:http/http.dart' as http;
import 'package:test/test.dart' as unittest;

import 'package:googleapis/test/v1.dart' as api;

class HttpServerMock extends http.BaseClient {
  core.Function _callback;
  core.bool _expectJson;

  void register(core.Function callback, core.bool expectJson) {
    _callback = callback;
    _expectJson = expectJson;
  }

  async.Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (_expectJson) {
      return request
          .finalize()
          .transform(convert.utf8.decoder)
          .join('')
          .then((core.String jsonString) {
        if (jsonString.isEmpty) {
          return _callback(request, null);
        } else {
          return _callback(request, convert.json.decode(jsonString));
        }
      });
    } else {
      var stream = request.finalize();
      if (stream == null) {
        return _callback(request, []);
      } else {
        return stream.toBytes().then((data) {
          return _callback(request, data);
        });
      }
    }
  }
}

http.StreamedResponse stringResponse(core.int status,
    core.Map<core.String, core.String> headers, core.String body) {
  var stream = new async.Stream.fromIterable([convert.utf8.encode(body)]);
  return new http.StreamedResponse(stream, status, headers: headers);
}

buildUnnamed0() {
  var o = new core.List<api.IDEEntity>();
  o.add(buildIDEEntity());
  o.add(buildIDEEntity());
  return o;
}

checkUnnamed0(core.List<api.IDEEntity> o) {
  unittest.expect(o, unittest.hasLength(2));
  checkIDEEntity(o[0]);
  checkIDEEntity(o[1]);
}

core.int buildCounterIDEEntity = 0;
buildIDEEntity() {
  var o = new api.IDEEntity();
  buildCounterIDEEntity++;
  if (buildCounterIDEEntity < 3) {
    o.files = buildUnnamed0();
    o.isFile = true;
    o.name = "foo";
  }
  buildCounterIDEEntity--;
  return o;
}

checkIDEEntity(api.IDEEntity o) {
  buildCounterIDEEntity++;
  if (buildCounterIDEEntity < 3) {
    checkUnnamed0(o.files);
    unittest.expect(o.isFile, unittest.isTrue);
    unittest.expect(o.name, unittest.equals('foo'));
  }
  buildCounterIDEEntity--;
}

buildListOfIDEEntity() {
  var o = new api.ListOfIDEEntity();
  o.add(buildIDEEntity());
  o.add(buildIDEEntity());
  return o;
}

checkListOfIDEEntity(api.ListOfIDEEntity o) {
  unittest.expect(o, unittest.hasLength(2));
  checkIDEEntity(o[0]);
  checkIDEEntity(o[1]);
}

core.int buildCounterStringMessage = 0;
buildStringMessage() {
  var o = new api.StringMessage();
  buildCounterStringMessage++;
  if (buildCounterStringMessage < 3) {
    o.value = "foo";
  }
  buildCounterStringMessage--;
  return o;
}

checkStringMessage(api.StringMessage o) {
  buildCounterStringMessage++;
  if (buildCounterStringMessage < 3) {
    unittest.expect(o.value, unittest.equals('foo'));
  }
  buildCounterStringMessage--;
}

core.int buildCounterWriteFileRequest = 0;
buildWriteFileRequest() {
  var o = new api.WriteFileRequest();
  buildCounterWriteFileRequest++;
  if (buildCounterWriteFileRequest < 3) {
    o.newContent = "foo";
    o.path = "foo";
  }
  buildCounterWriteFileRequest--;
  return o;
}

checkWriteFileRequest(api.WriteFileRequest o) {
  buildCounterWriteFileRequest++;
  if (buildCounterWriteFileRequest < 3) {
    unittest.expect(o.newContent, unittest.equals('foo'));
    unittest.expect(o.path, unittest.equals('foo'));
  }
  buildCounterWriteFileRequest--;
}

main() {
  unittest.group("obj-schema-IDEEntity", () {
    unittest.test("to-json--from-json", () {
      var o = buildIDEEntity();
      var od = new api.IDEEntity.fromJson(o.toJson());
      checkIDEEntity(od);
    });
  });

  unittest.group("obj-schema-ListOfIDEEntity", () {
    unittest.test("to-json--from-json", () {
      var o = buildListOfIDEEntity();
      var od = new api.ListOfIDEEntity.fromJson(o.toJson());
      checkListOfIDEEntity(od);
    });
  });

  unittest.group("obj-schema-StringMessage", () {
    unittest.test("to-json--from-json", () {
      var o = buildStringMessage();
      var od = new api.StringMessage.fromJson(o.toJson());
      checkStringMessage(od);
    });
  });

  unittest.group("obj-schema-WriteFileRequest", () {
    unittest.test("to-json--from-json", () {
      var o = buildWriteFileRequest();
      var od = new api.WriteFileRequest.fromJson(o.toJson());
      checkWriteFileRequest(od);
    });
  });

  unittest.group("resource-TestApi", () {
    unittest.test("method--coldStart", () {
      var mock = new HttpServerMock();
      api.TestApi res = new api.TestApi(mock);
      mock.register(unittest.expectAsync2((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(
            path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 8),
            unittest.equals("test/v1/"));
        pathOffset += 8;
        unittest.expect(path.substring(pathOffset, pathOffset + 9),
            unittest.equals("coldStart"));
        pathOffset += 9;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = <core.String, core.List<core.String>>{};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }

        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]),
                core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }

        var h = {
          "content-type": "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.coldStart().then(unittest.expectAsync1((_) {}));
    });

    unittest.test("method--getResource", () {
      var mock = new HttpServerMock();
      api.TestApi res = new api.TestApi(mock);
      mock.register(unittest.expectAsync2((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(
            path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 8),
            unittest.equals("test/v1/"));
        pathOffset += 8;
        unittest.expect(path.substring(pathOffset, pathOffset + 9),
            unittest.equals("listFiles"));
        pathOffset += 9;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = <core.String, core.List<core.String>>{};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }

        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]),
                core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }

        var h = {
          "content-type": "application/json; charset=utf-8",
        };
        var resp = convert.json.encode(buildListOfIDEEntity());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getResource().then(unittest.expectAsync1(((response) {
        checkListOfIDEEntity(response);
      })));
    });

    unittest.test("method--hotReload", () {
      var mock = new HttpServerMock();
      api.TestApi res = new api.TestApi(mock);
      mock.register(unittest.expectAsync2((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(
            path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 8),
            unittest.equals("test/v1/"));
        pathOffset += 8;
        unittest.expect(path.substring(pathOffset, pathOffset + 9),
            unittest.equals("hotReload"));
        pathOffset += 9;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = <core.String, core.List<core.String>>{};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }

        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]),
                core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }

        var h = {
          "content-type": "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.hotReload().then(unittest.expectAsync1((_) {}));
    });

    unittest.test("method--hotRestart", () {
      var mock = new HttpServerMock();
      api.TestApi res = new api.TestApi(mock);
      mock.register(unittest.expectAsync2((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(
            path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 8),
            unittest.equals("test/v1/"));
        pathOffset += 8;
        unittest.expect(path.substring(pathOffset, pathOffset + 10),
            unittest.equals("hotRestart"));
        pathOffset += 10;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = <core.String, core.List<core.String>>{};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }

        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]),
                core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }

        var h = {
          "content-type": "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.hotRestart().then(unittest.expectAsync1((_) {}));
    });

    unittest.test("method--updateResource", () {
      var mock = new HttpServerMock();
      api.TestApi res = new api.TestApi(mock);
      var arg_path = "foo";
      mock.register(unittest.expectAsync2((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(
            path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 8),
            unittest.equals("test/v1/"));
        pathOffset += 8;
        unittest.expect(path.substring(pathOffset, pathOffset + 8),
            unittest.equals("readFile"));
        pathOffset += 8;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = <core.String, core.List<core.String>>{};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }

        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]),
                core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }
        unittest.expect(queryMap["path"].first, unittest.equals(arg_path));

        var h = {
          "content-type": "application/json; charset=utf-8",
        };
        var resp = convert.json.encode(buildStringMessage());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res
          .updateResource(path: arg_path)
          .then(unittest.expectAsync1(((response) {
        checkStringMessage(response);
      })));
    });

    unittest.test("method--writeFile", () {
      var mock = new HttpServerMock();
      api.TestApi res = new api.TestApi(mock);
      var arg_request = buildWriteFileRequest();
      mock.register(unittest.expectAsync2((http.BaseRequest req, json) {
        var obj = new api.WriteFileRequest.fromJson(json);
        checkWriteFileRequest(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(
            path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 8),
            unittest.equals("test/v1/"));
        pathOffset += 8;
        unittest.expect(path.substring(pathOffset, pathOffset + 9),
            unittest.equals("writeFile"));
        pathOffset += 9;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = <core.String, core.List<core.String>>{};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }

        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]),
                core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }

        var h = {
          "content-type": "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.writeFile(arg_request).then(unittest.expectAsync1((_) {}));
    });
  });
}
