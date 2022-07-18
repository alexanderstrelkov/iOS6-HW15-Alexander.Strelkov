
import UIKit

extension String {
    var digits: String { return "0123456789" }
    var lowercase: String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase: String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters: String { return lowercase + uppercase }
    var printable: String { return digits + letters + punctuation }
    
    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
    
    static func randomPasswordGenerate() -> String {
        let passwordLength = 3
        let passwordCharacters =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let randomPassword = String((0..<passwordLength).compactMap{ _ in passwordCharacters.randomElement() })
        return randomPassword
    }
    
    static func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string
        
        if str.count <= 0 {
            str.append(BruteForceMethods.characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: BruteForceMethods.characterAt(index: (BruteForceMethods.indexOf(character: str.last ?? "a", array) + 1) % array.count, array))
            
            if BruteForceMethods.indexOf(character: str.last ?? "a", array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last ?? "a")
            }
        }
        return str
    }
}

struct BruteForceMethods {
    static func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character)) ?? 0
    }
    static func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }
}

