package crypto;

enum abstract WorkerMessage(String) {
    var GenerateSaltAndKey = "SALT_AND_KEY";
    var GenerateKey = "KEY";
}