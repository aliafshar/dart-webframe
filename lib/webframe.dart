
/**
 * The Webframe web application framework.
 */
library webframe;

import 'dart:io';
import 'dart:json';
import 'package:logging/logging.dart';
import 'package:routing/routing.dart';
import 'package:roundtrip/roundtrip.dart';
import 'package:signals/signals.dart';
import 'package:extensions/extensions.dart';
export 'package:roundtrip/roundtrip.dart' show RoundTrip;

part 'views.dart';
part 'config.dart';
part 'app.dart';
part 'logs.dart';





/**
 * Starts the Dwf server with the given setup script.
 */
startWebframe(dynamic setup(Webframe app)) {
  var wf = new Webframe();
  setup(wf);
  wf.start();
}

// fin.