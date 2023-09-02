import Cocoa
import SwiftUI
import ServiceManagement

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}
var globalAppDelegate: AppDelegate!

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var statusBarItem: NSStatusItem?
    var popover: NSPopover?
    var eventMonitor: Any?
    var isAppVisible = false
    @AppStorage("settingsViewUp") var settingsViewUp: Bool = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("applicationDidFinishLaunching")
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let image = NSImage(named: AppConfig.Constants.chatgpt_menu_icon) {
            image.size = CGSize(width: 20, height: 20)
            image.isTemplate = true
            statusBarItem?.button?.image = image
            statusBarItem?.button?.target = self
            statusBarItem?.button?.action = #selector(openClosePopOver)
            popover = NSPopover()
            popover?.contentViewController = NSHostingController(rootView: ChatGPT_MenuView())

        }
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { [weak self] _ in
            if self?.settingsViewUp == false {
                self?.closePopover()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.openClosePopOver()
        }
        globalAppDelegate = self
        HotkeySolution.register(delegate: self)
        registerAsLoginItem()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
//        print("App became active (menu icon appeared)")
//        openClosePopOver()
    }
}
extension AppDelegate {
    @objc func openClosePopOver() {
        if isAppVisible {
            closePopover()
        } else {
            showApp()
        }
        isAppVisible.toggle()
    }

    private func showApp() {
        if let button = statusBarItem?.button {
            popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    private func closePopover() {
        popover?.performClose(nil)
    }
}

extension AppDelegate {
    func registerAsLoginItem() {
        let launcherAppId = AppConfig.Constants.launcherAppId
            let runningApps = NSWorkspace.shared.runningApplications
            let isRunning = !runningApps.filter {
                $0.bundleIdentifier == launcherAppId
            }.isEmpty

            SMLoginItemSetEnabled(launcherAppId as CFString, true)

            if isRunning {
                DistributedNotificationCenter.default().post(
                    name: .killLauncher,
                    object: Bundle.main.bundleIdentifier!
                )
            }
    }

    func toggleLoginItem() {
        if SMLoginItemSetEnabled(AppConfig.Constants.mainAppId as CFString, true) {
            print("Login item state changed successfully")
        } else {
            print("Failed to change login item state")
        }
    }
}
