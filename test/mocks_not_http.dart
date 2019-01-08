import 'package:blog_frontend/src/time_service.dart';
import 'package:mockito/mockito.dart';

/// Mocks that don't have a dependency on dart:http.
///
/// This is split from mocks.dart to allow running
/// tests outside of browser, which are a lot faster,
/// can be debugged inside of IntelliJ, and have better
/// error reporting.


class TimeServiceMock extends Mock implements TimeService {}

