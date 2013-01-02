
library views;

import 'dart:io';
import 'roundtrip.dart';

errorView(RoundTrip r) {
  r.respondError(r.matched.error);
}

staticView(RoundTrip r) {
  var f  = new File.fromPath(r.matched.filepath);
  var s = f.openInputStream();
  s.onData = () {
    var bytes = s.read();
    r.response.outputStream.write(bytes);
  };
  s.onClosed = () {
    r.finish();
  };
  s.onError = (var e) {
    r.matched.args['__error__'] = 404;
    print(new Directory.current().path);
    print(e);
    errorView(r);
  };
}
