library app;

import 'dart:io';
import 'package:routing/routing.dart';
import 'config.dart';
import 'views.dart';
import 'roundtrip.dart';
import 'logging.dart';

typedef Future DwfSetup(Dwf);

class Dwf {

  RouteMap routes;
  Config config;
  HttpServer server;
  List<Future> setups = [];

  Dwf([config]) {
    initLogging();
    LOG.fine('Log started.');
    routes = new RouteMap();
    this.config = ?config ? config : new Config();
    routes.views['__static__'] = staticView;
    server = createServer();
  }

  /**
   * Add an extension to Dwf.
   */
  setup(DwfSetup setup) {
    var v = setup(this);
    if (v is Future) {
      setups.add(v);
    }
  }

  /**
   * Add a named route to the application.
   */
  route(name, {String path, dynamic method, Function view}) {
    var routePath = ?path ? new RoutePath.fromPath(path) : null;
    var routeMethod = ?method ? new RouteMethod.fromAnything(method) : null;
    routes.add(new Route(name, path: routePath, method: routeMethod));
    if (view != null) {
      routes.views[name] = view;
    }
  }

  /**
   * Add a static route to the application.
   */
  staticRoute(String name, String prefix, String path) {
    var routeStatic = new RouteStatic(prefix, new Path(path));
    routes.add(new Route(name, static: routeStatic));
  }

  _getViewName(Function view) {
    // var mirror = reflect(view);
    // mirror.function.simpleName;
    // Bad hack until the above code works.
    return view.toString().split("'")[1];
  }

  /**
   * Dispatch a single request to the first matched route, or respond with 404.
   */
  dispatch(HttpRequest request, HttpResponse response) {
    var matched = routes.match(request);
    var ctx = new RoundTrip(request, response, matched);
    var view = routes.findView(matched);
    if (view != null) {
      view(ctx);
    }
    else {
      ctx.respondError(matched.isError ? matched.error : HttpStatus.NOT_FOUND);
    }
  }

  /**
   * Creates an HTTP server with the appropriate configuration.
   */
  HttpServer createServer() {
    var server = new HttpServer();
    server.defaultRequestHandler = dispatch;
    return server;
  }

  addExtension(void ext(Dwf app)) {
    ext(this);
  }

  /**
   * Starts the HTTP server.
   */
  start() {
    print(setups.length);
    Futures.wait(setups).then((_) => _start());
  }

  _start() {
    server.listen(config.SERVER_ADDRESS, config.SERVER_PORT);
    LOG.info('Started Dwf.');
  }

}