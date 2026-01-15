import Cocoa

final class DropView: NSView {
    var onOpenURL: ((URL) -> Void)?

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        // Only accept file URLs
        if sender.draggingPasteboard.canReadObject(forClasses: [NSURL.self], options: nil) {
            return .copy
        }
        return []
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pb = sender.draggingPasteboard
        guard
            let urls = pb.readObjects(forClasses: [NSURL.self], options: nil) as? [URL],
            let url = urls.first
        else { return false }

        onOpenURL?(url)
        return true
    }
}
