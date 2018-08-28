import js.html.ArrayBuffer;

enum abstract AppMessage(String) {
    var Info = "INFO";
    var Error = "ERROR";
    var GeneratedSaltAndKey = "SALT_AND_KEY";
    var GeneratedKey = "KEY";
}