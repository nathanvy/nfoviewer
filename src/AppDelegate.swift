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

    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        wc?.open(url: URL(fileURLWithPath: filename))
        return true
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        if let first = filenames.first {
            wc?.open(url: URL(fileURLWithPath: first))
        }
        sender.reply(toOpenOrPrint: .success)
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

        // Edit menu
        let editItem = NSMenuItem()
        main.addItem(editItem)
        
        let editMenu = NSMenu(title: "Edit")
        editItem.submenu = editMenu
        
        editMenu.addItem(withTitle: "Copy",
                         action: #selector(NSText.copy(_:)),
                         keyEquivalent: "c")
        
        editMenu.addItem(withTitle: "Select All",
                         action: #selector(NSText.selectAll(_:)),
                         keyEquivalent: "a")

        
        return main
    }
}
