// http://codegists.com/snippet/swift/nsimagetintcolorswift_usagimaru_swift

import Cocoa

/*
 let tintColor = NSColor(red: 1.0, green: 0.08, blue: 0.50, alpha: 1.0)
 let image = NSImage(named: "NAME").imageWithTintColor(tintColor)
 imageView.image = image
 */

extension NSImage {

    func tinted(color: NSColor) -> NSImage
    {
        if self.isTemplate == false {
            return self
        }

        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()
        let rect = NSMakeRect(0, 0, image.size.width, image.size.height)
        NSRectFillUsingOperation(rect, .sourceAtop)

        image.unlockFocus()
        image.isTemplate = false

        return image
    }
}

