
import '../../lib/webframe.dart';
import '../../lib/db.dart';


class JsonService {

  list(RoundTrip r) {
    r.respond(body: 'bababa');
  }

  setup(Webframe app) {
    app.route('banana', path: '/banana', view: list);
  }

}


setup(Webframe app) {
  app..redirectRoute('index', '/', '/index.html')
     ..route('humans', path: '/humans.txt', view: humans)
     ..setup(new JsonService().setup)
     ..setup(new DbExtension().setup)
     ..staticRoute('__static__', '/', 'example/web');
}

humans(RoundTrip r) => r.respond(body: 'Take me to your leader.');

main() {
  startWebframe(setup);
}
