
/**
 * The Webframe web application framework.
 */
library webframe;

import 'dart:io';
import 'dart:json';
import 'config.dart';
import 'roundtrip.dart';
import 'views.dart';
import 'app.dart';


// Public API is exported.
export 'src/app.dart'       show Dwf, DwfSetup;
export 'src/roundtrip.dart' show RoundTrip;


/**
 * Starts the Dwf server with the given setup script.
 */
startDwf(dynamic setup(Dwf app)) {
  var dwf = new Dwf();
  dwf.setup(setup);
  dwf.start();
}

// fin.