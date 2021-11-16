import 'package:logger/logger.dart' as lg;

final _logger = lg.Logger(
  printer:lg.PrettyPrinter(
    methodCount: 2, // number of method calls to be displayed
    errorMethodCount: 8, // number of method calls if stacktrace is provided
    lineLength: 120, // width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: false ,
    
    
  ) 
);

class Logger {
  static void success(String message) {
    _logger.i(message);
  }

  static void error(String message) {
    _logger.e(message,);
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
