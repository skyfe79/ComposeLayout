//
//  ListItem.swift
//  CocoaExample
//
//  Created by Sungcheol Kim on 2024/02/01.
//

import Cocoa

class ListItem: NSCollectionViewItem {
    
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("list-item-reuse-identifier")
    
    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            updateSelectionHighlighting()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionHighlighting()
        }
    }
    
    private func updateSelectionHighlighting() {
        if !isViewLoaded {
            return
        }
        
        let showAsHighlighted = (highlightState == .forSelection) ||
            (isSelected && highlightState != .forDeselection) ||
            (highlightState == .asDropTarget)
            
        textField?.textColor = showAsHighlighted ? .selectedTextColor : .labelColor
        view.layer?.backgroundColor = showAsHighlighted ? NSColor.selectedControlColor.cgColor : nil
    }
}
