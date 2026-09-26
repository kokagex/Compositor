import Testing
@testable import Compositor

@MainActor struct LanguageTests {
    @Test func japaneseWhereverItIsPreferred() {
        #expect(AppLanguage.resolved(from: ["ja"]) == .japanese)
        #expect(AppLanguage.resolved(from: ["ja-JP", "en"]) == .japanese)
        #expect(AppLanguage.resolved(from: ["de", "ja"]) == .japanese)
    }
    @Test func everythingElseIsTheDefault() {
        #expect(AppLanguage.resolved(from: ["en"]) == .standard)
        #expect(AppLanguage.resolved(from: ["en-GB", "ja"]) == .standard)
        #expect(AppLanguage.resolved(from: ["fr"]) == .standard)
        #expect(AppLanguage.resolved(from: []) == .standard)
    }
}
