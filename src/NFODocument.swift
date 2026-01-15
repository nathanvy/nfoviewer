import Cocoa

final class NFODocument:  NSDocument {
    private var rawData: Data = Data()

    override class var autosavesInPlace: Bool { false }

    override func makeWindowControllers() {
        let wc = NFOWindowController()
        wc.setDocument(self)
        addWindowController(wc)
        wc.showWindow(self)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        self.rawData = data
    }

    override func data(ofType typeName: String) throws -> Data {
        // Viewer-only app; keep what we loaded.
        return rawData
    }

    func decodedText() -> String {
        // Many .nfo files are CP437; if it's actually UTF-8, CP437 will still
        // display readable ASCII and the extended bytes become box-drawing, etc.
        CP437.decode(rawData)
    }
}
