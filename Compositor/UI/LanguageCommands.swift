import AppKit
import Observation
import SwiftUI

enum AppLanguage: String, CaseIterable {
    case standard = "en"
    case japanese = "ja"

    static func resolved(from preferences: [String]) -> AppLanguage {
        let match = Bundle.preferredLocalizations(from: allCases.map(\.rawValue), forPreferences: preferences).first
        return AppLanguage(rawValue: match ?? "") ?? .standard
    }
}

@MainActor @Observable
final class LanguageSettings {
    static let shared = LanguageSettings()
    private(set) var language: AppLanguage
    @ObservationIgnored private let running: AppLanguage
    private init() {
        let current = AppLanguage.resolved(from: UserDefaults.standard.stringArray(forKey: "AppleLanguages") ?? [])
        language = current
        running = current
    }

    func choose(_ choice: AppLanguage) {
        guard choice != language else { return }
        language = choice
        UserDefaults.standard.set([choice.rawValue], forKey: "AppleLanguages")
        guard choice != running else { return }
        Task {
            let alert = NSAlert()
            alert.messageText = String(localized: "The new language takes effect the next time you open Compositor.")
            alert.addButton(withTitle: String(localized: "OK"))
            alert.runModal()
        }
    }
}

struct LanguageCommands: Commands {
    var body: some Commands {
        CommandGroup(after: .help) {
            Divider()
            Picker("Language", selection: Binding(get: { LanguageSettings.shared.language },
                                                  set: { LanguageSettings.shared.choose($0) })) {
                Text("Default (English)").tag(AppLanguage.standard)
                Text(verbatim: "日本語").tag(AppLanguage.japanese)
            }
        }
    }
}
