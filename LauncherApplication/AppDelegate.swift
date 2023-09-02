import Cocoa

extension Notification.Name {
    static let killLauncher = Notification.Name(AppConfig.Constants.laucherNotificationName)
}

class AppDelegate: NSObject {
    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

extension AppDelegate: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let mainAppIdentifier = AppConfig.Constants.mainAppId
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter {
            $0.bundleIdentifier == mainAppIdentifier
        }.isEmpty

        if !isRunning {
            DistributedNotificationCenter.default().addObserver(
                self,
                selector: #selector(self.terminate),
                name: .killLauncher,
                object: mainAppIdentifier
            )

            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append(AppConfig.Constants.osName)
            components.append(AppConfig.Constants.mainAppName) //main app name

            let newPath = NSString.path(withComponents: components)

            NSWorkspace.shared.launchApplication(newPath)
        }
        else {
            self.terminate()
        }
    }
}
