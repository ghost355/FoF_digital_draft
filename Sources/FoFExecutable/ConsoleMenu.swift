import FoFLib
import Foundation

let engine = TestActionDeckEngine()

enum Color {
    static let reset = "\u{001B}[0m"
    static let red = "\u{001B}[31m"
    static let green = "\u{001B}[32m"
    static let yellow = "\u{001B}[33m"
    static let blue = "\u{001B}[34m"
    static let magenta = "\u{001B}[35m"
    static let cyan = "\u{001B}[36m"
}

func clearScreen() {
    print("\u{001B}[2J\u{001B}[H")
}

func showMainMenu() {
    clearScreen()
    print("\(Color.cyan)")
    print("╔═══════════════════════════════════════════════════╗")
    print("║     Action Deck Tester - Console Edition         ║")
    print("╚═══════════════════════════════════════════════════╝")
    print("\(Color.reset)")
    print(engine.deckStatus())
    print("")
    print("[\(Color.green)1\(Color.reset)] Combat Result (NCM)")
    print("[\(Color.green)2\(Color.reset)] Hit Effect")
    print("[\(Color.green)3\(Color.reset)] Grenade Attack")
    print("[\(Color.green)4\(Color.reset)] Call for Fire")
    print("[\(Color.green)5\(Color.reset)] Mines")
    print("")
    print("[\(Color.yellow)6\(Color.reset)] HQ Event")
    print("[\(Color.yellow)7\(Color.reset)] Infiltration")
    print("[\(Color.yellow)8\(Color.reset)] Cover")
    print("[\(Color.yellow)9\(Color.reset)] Rally")
    print("")
    print("[\(Color.magenta)A\(Color.reset)] Spotting")
    print("[\(Color.magenta)B\(Color.reset)] Contact")
    print("[\(Color.magenta)C\(Color.reset)] Concentrate Fire")
    print("")
    print("[\(Color.cyan)H\(Color.reset)] Show Hand")
    print("[\(Color.cyan)D\(Color.reset)] Deck Status")
    print("")
    print("[\(Color.red)0\(Color.reset)] Exit")
    print("")
    print("Choice: ", terminator: "")
}

func formatResult(_ result: String, isSuccess: Bool? = nil) {
    if let success = isSuccess {
        if success {
            print("\(Color.green)Result: \(result)\(Color.reset)")
        } else {
            print("\(Color.red)Result: \(result)\(Color.reset)")
        }
    } else {
        print("Result: \(result)")
    }
    print("")
    print("Press Enter to continue...", terminator: "")
    _ = readLine()
}

func getIntInput(prompt: String, min: Int, max: Int, zeroValid: Bool = false) -> Int? {
    print(prompt)
    print("(Enter - back) > ", terminator: "")
    guard let input = readLine() else { return nil }
    if input.isEmpty { return nil }
    guard let value = Int(input), value >= min, value <= max else { return nil }
    if value == 0 && !zeroValid { return nil }
    return value
}

func getBoolInput(prompt: String) -> Bool? {
    print(prompt)
    print("(1 - Yes, 2 - No, 0 - back) > ", terminator: "")
    guard let input = readLine(), let value = Int(input), value >= 0, value <= 2 else {
        return nil
    }
    if value == 0 { return nil }
    return value == 1
}

mainLoop: while true {
    showMainMenu()

    guard let choice = readLine()?.lowercased() else { continue }

    switch choice {
    case "0", "q", "quit", "exit":
        print("\(Color.red)Goodbye!\(Color.reset)")
        break mainLoop

    case "1":
        guard let ncm = getIntInput(prompt: "NCM (-4 to +6):", min: -4, max: 6, zeroValid: true)
        else { continue }
        let result = engine.combatResult(ncm: ncm)
        let isSuccess = result == "hit" || result == "pin"
        formatResult(result, isSuccess: isSuccess)

    case "2":
        print("Experience Level:")
        print("(1 - Veteran, 2 - Line, 3 - Green, 0 - back)")
        guard let expChoice = readLine(), let choice = Int(expChoice), choice >= 1, choice <= 3
        else { continue }
        if choice == 0 { continue }
        let levels = ["veteran", "line", "green"]
        let result = engine.hitEffect(experience: levels[choice - 1])
        print("\(Color.cyan)Effects: \(result)\(Color.reset)")
        print("Press Enter to continue...", terminator: "")
        _ = readLine()

    case "3":
        guard let count = getIntInput(prompt: "Card count:", min: 1, max: 51, zeroValid: true)
        else { continue }
        guard let canJam = getBoolInput(prompt: "Can Jam?") else { continue }
        let result = engine.grenadeAttack(count: count, canJam: canJam)
        let isSuccess = result != "jam" && result != "failure"
        formatResult(result, isSuccess: isSuccess)

    case "4":
        guard let count = getIntInput(prompt: "Card count:", min: 1, max: 51, zeroValid: true)
        else { continue }
        guard let bnFire = getBoolInput(prompt: "Has BN Fire Mission?") else { continue }
        let result = engine.callForFire(count: count, hasBnFireMission: bnFire)
        let isSuccess = result != "short" && result != "failure"
        formatResult(result, isSuccess: isSuccess)

    case "5":
        let result = engine.mines()
        formatResult(result, isSuccess: result == "success")

    case "6":
        let result = engine.hqEvent()
        formatResult(result, isSuccess: result == "success")

    case "7":
        guard let count = getIntInput(prompt: "Card count:", min: 1, max: 51, zeroValid: true)
        else { continue }
        let result = engine.infiltration(count: count)
        formatResult(result, isSuccess: result == "success")

    case "8":
        guard let count = getIntInput(prompt: "Card count:", min: 1, max: 51, zeroValid: true)
        else { continue }
        let result = engine.cover(count: count)
        formatResult(result, isSuccess: result == "success")

    case "9":
        guard let count = getIntInput(prompt: "Card count:", min: 1, max: 51, zeroValid: true)
        else { continue }
        let result = engine.rally(count: count)
        formatResult(result, isSuccess: result == "success")

    case "a":
        guard let count = getIntInput(prompt: "Card count:", min: 1, max: 51, zeroValid: true)
        else { continue }
        let result = engine.spotting(count: count)
        formatResult(result, isSuccess: result == "success")

    case "b":
        guard let count = getIntInput(prompt: "Card count:", min: 1, max: 51, zeroValid: true)
        else { continue }
        let result = engine.contact(count: count)
        formatResult(result, isSuccess: result == "success")

    case "c":
        guard let count = getIntInput(prompt: "Card count:", min: 1, max: 51, zeroValid: true)
        else { continue }
        guard let canJam = getBoolInput(prompt: "Can Jam?") else { continue }
        let result = engine.concentrateFire(count: count, canJam: canJam)
        let isSuccess = result != "jam" && result != "failure"
        formatResult(result, isSuccess: isSuccess)

    case "h":
        clearScreen()
        print(engine.getHand())
        print("")
        print("Press Enter to continue...", terminator: "")
        _ = readLine()

    case "d":
        clearScreen()
        print(engine.deckStatus())
        print("")
        print("Press Enter to continue...", terminator: "")
        _ = readLine()

    default:
        continue
    }
}
