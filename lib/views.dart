


part of webframe;

typedef void WebframeView(RoundTrip);

errorView(RoundTrip r) {
  r.respondError(r.matchArgs['error']);
}

staticView(RoundTrip r) {
  var f  = new File.fromPath(r.matchArgs['filepath']);
  var s = f.openInputStream();
  s.onData = () {
    s.pipe(r.response.outputStream, close: false);
  };
  s.onClosed = () {
    LOG.fine('Finished reading ${f.fullPathSync()}.');
    r.finish();
  };
  s.onError = (Exception e) {
    r.matchArgs['error'] = 404;
    LOG.fine(e.toString());
    errorView(r);
  };
}


class RedirectView {

  final String location;

  RedirectView(this.location);

  call(RoundTrip r) {
    LOG.fine('Redirecting to $location.');
    r.statusCode = 302;
    r.response.headers.add(HttpHeaders.LOCATION, location);
    r.finish();
  }

}
