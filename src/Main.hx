import Crypto.CryptoResult;
import js.html.Uint8Array;
import Crypto.CipherResult;
import Crypto.DecipherResult;
import js.Browser;

class Main {
    public static function main() {
        Crypto.init()
        .then(function(_):Void {
            Browser.console.log("Initialized crypto!");

            Browser.console.log("Downloading salt...");
            Crypto._generate_salt();
            Browser.console.log("Calculating key...");
            switch(Crypto.calculate_key("my very good password")) {
                case CryptoResult.Ok:{}
                default: Browser.console.log("Failed to calculate key!");
            }

            Browser.console.log("Encrypting...");
            var crypt_result:CipherResult = Crypto.encrypt("The quick brown fox jumped over the lazy dog!");

            switch(crypt_result) {
                case CipherResult.Ok(cipher_text, nonce): {
                    var b64cipher_text:Base64String = cipher_text;
                    var b64nonce:Base64String = nonce;
                    Browser.console.log('Result', {
                        cipher_text: b64cipher_text,
                        nonce: b64nonce
                    });

                    Browser.console.log("Decrypting...");
                    var decrypt_result:DecipherResult = Crypto.decrypt(b64cipher_text, b64nonce);
                    switch(decrypt_result) {
                        case DecipherResult.Ok(message): {
                            Browser.console.log("Result", {
                                message: message
                            });
                        }

                        case DecipherResult.Error(err): {
                            Browser.console.warn("Failed to decrypt", err);
                        }
                    }
                }

                case CipherResult.Error(err): {
                    Browser.console.warn("Failed to encrypt", err);
                }
            }
        });
    }
}