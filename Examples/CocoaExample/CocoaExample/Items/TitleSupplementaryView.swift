import Cocoa

class TitleSupplementaryView: NSView, NSCollectionViewElement {
    @IBOutlet weak var label: NSTextField!
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("title-supplementary-reuse-identifier")
}
