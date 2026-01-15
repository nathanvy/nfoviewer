import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var wc: NFOWindowController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)

        NSApp.mainMenu = buildMainMenu()

        FontRegistration.registerFont(named: "dos437.ttf")
        // FontRegistration.dumpFontNames(named: "dos437.ttf") // enable once if needed
        
        wc = NFOWindowController()
        wc?.showWindow(self)        
    }

    @objc private func openNFO(_ sender: Any?) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK, let url = panel.url {
            wc?.open(url: url)
        }
    }
        
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    private func buildMainMenu() -> NSMenu {
        let main = NSMenu()

        // App menu
        let appMenuItem = NSMenuItem()
        main.addItem(appMenuItem)

        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu

        appMenu.addItem(withTitle: "Quit NFO Viewer",
                        action: #selector(NSApplication.terminate(_:)),
                        keyEquivalent: "q")

        // File menu
        let fileMenuItem = NSMenuItem()
        main.addItem(fileMenuItem)

        let fileMenu = NSMenu(title: "File")
        fileMenuItem.submenu = fileMenu

        let openItem = NSMenuItem(title: "Open…",
                                  action: #selector(openNFO(_:)),
                                  keyEquivalent: "o")
        openItem.target = self
        fileMenu.addItem(openItem)

        fileMenu.addItem(.separator())

        fileMenu.addItem(withTitle: "Close",
                         action: #selector(NSWindow.performClose(_:)),
                         keyEquivalent: "w")

        return main
    }
}
