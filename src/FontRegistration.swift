import Cocoa
import CoreText

enum FontRegistration {
    static func registerFont(named filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            NSLog("Font not found in bundle: \(filename)")
            return
        }

        var error: Unmanaged<CFError>?
        let ok = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
        if !ok {
            let err = (error?.takeRetainedValue())
            NSLog("Failed to register font \(filename): \(String(describing: err))")
        }
    }

    /// Helpful for figuring out the exact PostScript/font names inside the TTF.
    static func dumpFontNames(named filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil),
              let descs = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as? [CTFontDescriptor]
        else { return }

        for d in descs {
            let ps = CTFontDescriptorCopyAttribute(d, kCTFontNameAttribute) as? String ?? "(unknown)"
            let fam = CTFontDescriptorCopyAttribute(d, kCTFontFamilyNameAttribute) as? String ?? "(unknown)"
            NSLog("Bundled font: family=\(fam) postscript=\(ps)")
        }
    }
}
