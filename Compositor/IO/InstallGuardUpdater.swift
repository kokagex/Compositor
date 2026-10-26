import AppKit
import Sparkle

@MainActor final class InstallGuardUserDriver: NSObject, SPUUserDriver {
    private let driver = UpdateDriver()
    weak var updater: SPUUpdater? {
        didSet {
            driver.updater = updater
            updater?.automaticallyDownloadsUpdates = false
        }
    }

    func showUpdateFound(with appcastItem: SUAppcastItem, state: SPUUserUpdateState, reply: @escaping (SPUUserUpdateChoice) -> Void) {
        driver.showUpdateFound(with: appcastItem, state: state) { [weak self] choice in
            self?.updater?.automaticallyDownloadsUpdates = false
            let cancel: SPUUserUpdateChoice = state.stage == .installing ? .skip : .dismiss
            reply(choice == .skip ? .skip : cancel)
            guard choice == .install else { return }
            let alert = NSAlert()
            alert.messageText = String(localized: "This build doesn’t install updates")
            alert.informativeText = String(localized: "Installing Compositor \(appcastItem.displayVersionString) would replace this local build. Merge the new version into the source and build it again.")
            alert.addButton(withTitle: String(localized: "OK"))
            alert.runModal()
        }
    }

    func showReady(toInstallAndRelaunch reply: @escaping (SPUUserUpdateChoice) -> Void) {
        reply(.skip)
    }

    func show(_ request: SPUUpdatePermissionRequest, reply: @escaping (SUUpdatePermissionResponse) -> Void) {
        driver.show(request, reply: reply)
    }
    func showUserInitiatedUpdateCheck(cancellation: @escaping () -> Void) { driver.showUserInitiatedUpdateCheck(cancellation: cancellation) }
    func showUpdateReleaseNotes(with downloadData: SPUDownloadData) { driver.showUpdateReleaseNotes(with: downloadData) }
    func showUpdateReleaseNotesFailedToDownloadWithError(_ error: any Error) { driver.showUpdateReleaseNotesFailedToDownloadWithError(error) }
    func showUpdateNotFoundWithError(_ error: any Error, acknowledgement: @escaping () -> Void) {
        driver.showUpdateNotFoundWithError(error, acknowledgement: acknowledgement)
    }
    func showUpdaterError(_ error: any Error, acknowledgement: @escaping () -> Void) {
        driver.showUpdaterError(error, acknowledgement: acknowledgement)
    }
    func showDownloadInitiated(cancellation: @escaping () -> Void) { driver.showDownloadInitiated(cancellation: cancellation) }
    func showDownloadDidReceiveExpectedContentLength(_ expectedContentLength: UInt64) {
        driver.showDownloadDidReceiveExpectedContentLength(expectedContentLength)
    }
    func showDownloadDidReceiveData(ofLength length: UInt64) { driver.showDownloadDidReceiveData(ofLength: length) }
    func showDownloadDidStartExtractingUpdate() { driver.showDownloadDidStartExtractingUpdate() }
    func showExtractionReceivedProgress(_ progress: Double) { driver.showExtractionReceivedProgress(progress) }
    func showInstallingUpdate(withApplicationTerminated applicationTerminated: Bool, retryTerminatingApplication: @escaping () -> Void) {
        driver.showInstallingUpdate(withApplicationTerminated: applicationTerminated, retryTerminatingApplication: retryTerminatingApplication)
    }
    func showUpdateInstalledAndRelaunched(_ relaunched: Bool, acknowledgement: @escaping () -> Void) {
        driver.showUpdateInstalledAndRelaunched(relaunched, acknowledgement: acknowledgement)
    }
    func showUpdateInFocus() { driver.showUpdateInFocus() }
    func dismissUpdateInstallation() { driver.dismissUpdateInstallation() }
}
