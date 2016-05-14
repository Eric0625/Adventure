//
//  DynamicTextStorage.swift
//  Adventure
//
//  Created by 苑青 on 16/5/13.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

class DynamicTextStorage: NSTextStorage {
    let backingStore = NSMutableAttributedString()
    
    override var string: String {
        return backingStore.string
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return backingStore.attributesAtIndex(location, effectiveRange: range)
    }

    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        print("replaceCharactersInRange:\(range) withString:\(str)")
        
        beginEditing()
        backingStore.replaceCharactersInRange(range, withString:str)
        edited([.EditedCharacters,.EditedAttributes], range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        print("setAttributes:\(attrs) range:\(range)")
        
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.EditedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
//    func applyStylesToRange(searchRange: NSRange) {
//        // 1. create some fonts
//        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
//        let boldFontDescriptor = fontDescriptor.fontDescriptorWithSymbolicTraits(.TraitBold)
//        let boldFont = UIFont(descriptor: boldFontDescriptor, size: 0)
//        let normalFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//        
//        // 2. match items surrounded by asterisks
//        let regexStr = "(\\*\\w+(\\s\\w+)*\\*)"
//        do{
//            let regex = try NSRegularExpression(pattern: regexStr, options: .CaseInsensitive)
//            let boldAttributes = [NSFontAttributeName : boldFont]
//            let normalAttributes = [NSFontAttributeName : normalFont]
//            
//            // 3. iterate over each match, making the text bold
//            regex.enumerateMatchesInString(backingStore.string, options: .ReportProgress, range: searchRange) {
//                match, flags, stop in
//                guard let matchSure = match else { return }
//                let matchRange = matchSure.rangeAtIndex(1)
//                self.addAttributes(boldAttributes, range: matchRange)
//                
//                // 4. reset the style to the original
//                let maxRange = matchRange.location + matchRange.length
//                if maxRange + 1 < self.length {
//                    self.addAttributes(normalAttributes, range: NSMakeRange(maxRange, 1))
//                }
//            }
//        } catch {
//            fatalError()
//        }
//    }
//    
//    func performReplacementsForRange(changedRange: NSRange) {
//        var extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(changedRange.location, 0)))
//        extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(NSMaxRange(changedRange), 0)))
//        applyStylesToRange(extendedRange)
//    }
//    
//    override func processEditing() {
//        performReplacementsForRange(self.editedRange)
//        super.processEditing()
//    }
    
    
}
