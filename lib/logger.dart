import 'package:logger/logger.dart' as lg;

final _logger = lg.Logger();

class Logger {
  static void success(String message) {
    _logger.i(message);
  }

  static void error(String message) {
    _logger.e(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void bigError(String message) {
    _logger.wtf(message);
  }

  static void log(String message) {
    _logger.v(message);
  }

  static void debug(String message) {
    _logger.d(message);
  }
}
