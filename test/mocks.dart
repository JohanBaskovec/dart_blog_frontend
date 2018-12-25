import 'dart:convert';

import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/home/home_page.dart';
import 'package:blog_frontend/src/home/home_page_factory.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/http/http_requester.dart';
import 'package:blog_frontend/src/routing/route.dart';
import 'package:blog_frontend/src/routing/route_holder.dart';
import 'package:mockito/mockito.dart';

class MockController extends Mock implements Controller {}

class MockRoute extends Mock implements Route {}

class MockRouteHolder extends Mock implements RouteHolder {}

class HttpRequesterMock extends Mock implements HttpRequester {}

class JsonDecoderMock extends Mock implements JsonDecoder {}

class HomePageFactoryMock extends Mock implements HomePageFactory {}

class HttpClientMock extends Mock implements HttpClient {}

class HomePageMock extends Mock implements HomePage {}


