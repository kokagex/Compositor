import AppKit
import Sparkle

final class InstallGuardUpdater {
    private let userDriver = InstallGuardUserDriver(hostBundle: .main, delegate: nil)
    private lazy var updater = SPUUpdater(hostBundle: .main, applicationBundle: .main, userDriver: userDriver, delegate: nil)

    func startUpdater() {
        do {
            try updater.start()
            updater.automaticallyDownloadsUpdates = false
        } catch {
            NSAlert(error: error).runModal()
        }
    }

    func checkForUpdates(_ sender: Any?) {
        updater.checkForUpdates()
    }
}

final class InstallGuardUserDriver: SPUStandardUserDriver {
    override func showUpdateFound(with appcastItem: SUAppcastItem, state: SPUUserUpdateState, reply: @escaping (SPUUserUpdateChoice) -> Void) {
        super.showUpdateFound(with: appcastItem, state: state) { choice in
            guard choice == .install else { return reply(choice) }
            reply(.dismiss)
            let alert = NSAlert()
            alert.messageText = String(localized: "This build doesn’t install updates")
            alert.informativeText = String(localized: "Installing Compositor \(appcastItem.displayVersionString) would replace this local build. Merge the new version into the source and build it again.")
            alert.addButton(withTitle: String(localized: "OK"))
            alert.runModal()
        }
    }

    override func showReady(toInstallAndRelaunch reply: @escaping (SPUUserUpdateChoice) -> Void) {
        reply(.dismiss)
    }
}
