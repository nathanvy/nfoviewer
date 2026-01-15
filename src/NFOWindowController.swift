import Cocoa
final class NFOWindowController: NSWindowController, NSWindowDelegate {
    private let scrollView = NSScrollView()
    private let textView = NSTextView()

    convenience init() {
        let window = NSWindow(
          contentRect: NSRect(x: 0, y: 0, width: 900, height: 700),
          styleMask: [.titled, .closable, .miniaturizable, .resizable],
          backing: .buffered,
          defer: false
        )
        self.init(window: window)
        window.center()
        window.title = "NFO Viewer"
        window.delegate = self
        setupUI()
        textView.string = "File -> Open or drop a .nfo file"
        applyViewerStyling()
    }

    func open(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            textView.string = CP437.decode(data)
            window?.title = url.lastPathComponent
        } catch {
            NSSound.beep()
            print("Failed to open \(url): \(error)")
        }
    }


    func setDocument(_ doc: NFODocument) {
        // Render document contents
        let s = doc.decodedText()
        textView.string = s.isEmpty ? "File -> Open or drop a .nfo file" : s
        applyViewerStyling()
    }

    private func setupUI() {
        guard let window else { return }

        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder

        textView.isEditable = false
        textView.isSelectable = true
        textView.isRichText = false
        textView.importsGraphics = false
        textView.usesFindBar = true
        textView.usesRuler = false
        textView.isHorizontallyResizable = true
        textView.isVerticallyResizable = true
        textView.textContainerInset = NSSize(width: 12, height: 12)

        // Ensure horizontal scrolling works (don’t wrap lines)
        textView.textContainer?.widthTracksTextView = false
        textView.textContainer?.containerSize = NSSize(width: CGFloat.greatestFiniteMagnitude,
                                                     height: CGFloat.greatestFiniteMagnitude)

        scrollView.documentView = textView

        scrollView.documentView = textView

        let drop = DropView(frame: .zero)
        drop.onOpenURL = { [weak self] url in self?.open(url: url) }
        drop.registerForDraggedTypes([.fileURL])
        
        drop.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                      scrollView.leadingAnchor.constraint(equalTo: drop.leadingAnchor),
                                      scrollView.trailingAnchor.constraint(equalTo: drop.trailingAnchor),
                                      scrollView.topAnchor.constraint(equalTo: drop.topAnchor),
                                      scrollView.bottomAnchor.constraint(equalTo: drop.bottomAnchor),
                                    ])
        
        window.contentView = drop
    }

    private func applyViewerStyling() {
        // Replace with the *PostScript name* printed by dumpFontNames(...)
        if let f = NSFont(name: "YourFontPostScriptNameHere", size: 13) {
            textView.font = f
        } else {
            textView.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        }
        
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.textColor = NSColor.textColor
    }

}
