//
//  TTLabel.swift
//  Tranb
//
//  Created by Kim on 2017/6/28.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//
/**
 import UIKit
 
 class TTLabel: UILabel {
 
 /// 重写属性
 override var text: String? {
 didSet {
 //重新准备文本内容
 prepareTextSystem()
 }
 }
 
 /// 属性文本存储
 lazy var textStorage = NSTextStorage()
 
 /// 负责文本字形布局
 lazy var layoutManger = NSLayoutManager()
 
 /// 设置文本绘制的范围
 lazy var textContainer = NSTextContainer()
 
 override init(frame: CGRect) {
 super.init(frame: frame)
 prepareTextSystem()
 }
 
 required init?(coder aDecoder: NSCoder) {
 super.init(coder: aDecoder)
 prepareTextSystem()
 }
 //MARK: - 交互
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 //获取用户点击位置
 guard let location = touches.first?.location(in: self) else {
 return
 }
 //获取当前点中字符的索引
 let index = layoutManger.glyphIndex(for: location, in: textContainer)
 
 ///判断index是否是在URLRanges内，
 for range in urlRanges ?? [] {
 if NSLocationInRange(index, range) {
 //改变颜色
 textStorage.addAttributes([NSForegroundColorAttributeName : UIColor.blue], range: range)
 
 //需要重绘
 setNeedsDisplay()
 } else {
 print("没戳着")
 }
 }
 }
 
 //MARK: - 绘制
 //接管
 override func drawText(in rect: CGRect) {
 
 let range = NSRange(location: 0, length: textStorage.length)
 
 layoutManger.drawGlyphs(forGlyphRange: range, at: CGPoint())
 
 
 }
 
 override func layoutSubviews() {
 super.layoutSubviews()
 //制定文本的区域
 textContainer.size = bounds.size
 }
 }
 
 // MARK: - 正则表达式
 private extension TTLabel {
 
 var urlRanges: [NSRange]? {
 
 //1.正则表达式
 let pattern = "[a-zA-Z]*://[a-zA-Z0-9/\\.]*"
 
 guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
 
 return []
 }
 //多重匹配
 let matchs = regx.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
 
 //遍历数组生成range数组
 var ranges = [NSRange]()
 
 for m in matchs {
 ranges.append(m.rangeAt(0))
 }
 
 return ranges
 }
 
 }
 
 // MARK: - 设置TextKit的核心对象
 private extension TTLabel {
 
 /// 准备文本系统
 func prepareTextSystem() {
 isUserInteractionEnabled = true
 //1.准备文本内容
 preparTextContent()
 //2.设置对象的关系
 layoutManger.addTextContainer(textContainer)
 textStorage.addLayoutManager(layoutManger)
 
 }
 
 /// 准备文本内容 - 使用textStorage接管label的内容
 func preparTextContent() {
 
 if let attributedText = attributedText {
 textStorage.setAttributedString(attributedText)
 } else if let text = text {
 textStorage.setAttributedString(NSAttributedString(string: text))
 } else {
 textStorage.setAttributedString(NSAttributedString(string: ""))
 }
 
 
 //遍历范围数组，设置文字属性
 for range in urlRanges ?? [] {
 textStorage.addAttributes([NSForegroundColorAttributeName : UIColor.red], range: range)
 }
 }
 } */
import UIKit

@objc
public protocol TTLabelDelegate: NSObjectProtocol {
    /// 选中链接文本
    ///
    /// - parameter label: label
    /// - parameter text:  选中的文本
    @objc optional func labelDidSelectedLinkText(label: TTLabel, text: String)
}

public class TTLabel: UILabel {
    
    public var linkTextColor = UIColor.blue
    public var selectedBackgroudColor = UIColor.lightGray
    public weak var delegate: TTLabelDelegate?
    
    // MARK: - override properties
    override public var text: String? {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var attributedText: NSAttributedString? {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var font: UIFont! {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var textColor: UIColor! {
        didSet {
            updateTextStorage()
        }
    }
    
    // MARK: - upadte text storage and redraw text
    private func updateTextStorage() {
        if attributedText == nil {
            return
        }
        
        let attrStringM = addLineBreak(attributedText!)
        regexLinkRanges(attrStringM)
        addLinkAttribute(attrStringM)
        
        textStorage.setAttributedString(attrStringM)
        
        setNeedsDisplay()
    }
    
    /// add link attribute
    private func addLinkAttribute(_ attrStringM: NSMutableAttributedString) {
        if attrStringM.length == 0 {
            return
        }
        
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        
        attributes[NSFontAttributeName] = font!
        attributes[NSForegroundColorAttributeName] = textColor
        attrStringM.addAttributes(attributes, range: range)
        
        attributes[NSForegroundColorAttributeName] = linkTextColor
        
        for r in linkRanges {
            attrStringM.setAttributes(attributes, range: r)
        }
    }
    
    /// use regex check all link ranges
    private let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
    private func regexLinkRanges(_ attrString: NSAttributedString) {
        linkRanges.removeAll()
        let regexRange = NSRange(location: 0, length: attrString.string.characters.count)
        
        for pattern in patterns {
            let regex = try! NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let results = regex.matches(in: attrString.string, options: [], range: regexRange)
            
            for r in results {
                linkRanges.append(r.rangeAt(0))
            }
        }
    }
    
    /// add line break mode
    private func addLineBreak(_ attrString: NSAttributedString) -> NSMutableAttributedString {
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        
        if attrStringM.length == 0 {
            return attrStringM
        }
        
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        var paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle
        
        if paragraphStyle != nil {
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
        } else {
            // iOS 8.0 can not get the paragraphStyle directly
            paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
            attributes[NSParagraphStyleAttributeName] = paragraphStyle
            
            attrStringM.setAttributes(attributes, range: range)
        }
        
        return attrStringM
    }
    
    public override func drawText(in rect: CGRect) {
        let range = glyphsRange()
        let offset = glyphsOffset(range)
        
        layoutManager.drawBackground(forGlyphRange: range, at: offset)
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
    }
    
    private func glyphsRange() -> NSRange {
        return NSRange(location: 0, length: textStorage.length)
    }
    
    private func glyphsOffset(_ range: NSRange) -> CGPoint {
        let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        let height = (bounds.height - rect.height) * 0.5
        
        return CGPoint(x: 0, y: height)
    }
    
    // MARK: - touch events
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        selectedRange = linkRangeAtLocation(location)
        modifySelectedAttribute(true)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        if let range = linkRangeAtLocation(location) {
            if !(range.location == selectedRange?.location && range.length == selectedRange?.length) {
                modifySelectedAttribute(false)
                selectedRange = range
                modifySelectedAttribute(true)
            }
        } else {
            modifySelectedAttribute(false)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectedRange != nil {
            let text = (textStorage.string as NSString).substring(with: selectedRange!)
            delegate?.labelDidSelectedLinkText?(label: self, text: text)
            
            let when = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.modifySelectedAttribute(false)
            }
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        modifySelectedAttribute(false)
    }
    
    private func modifySelectedAttribute(_ isSet: Bool) {
        if selectedRange == nil {
            return
        }
        
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        attributes[NSForegroundColorAttributeName] = linkTextColor
        let range = selectedRange!
        
        if isSet {
            attributes[NSBackgroundColorAttributeName] = selectedBackgroudColor
        } else {
            attributes[NSBackgroundColorAttributeName] = UIColor.clear
            selectedRange = nil
        }
        
        textStorage.addAttributes(attributes, range: range)
        
        setNeedsDisplay()
    }
    
    private func linkRangeAtLocation(_ location: CGPoint) -> NSRange? {
        if textStorage.length == 0 {
            return nil
        }
        
        let offset = glyphsOffset(glyphsRange())
        let point = CGPoint(x: offset.x + location.x, y: offset.y + location.y)
        let index = layoutManager.glyphIndex(for: point, in: textContainer)
        
        for r in linkRanges {
            if index >= r.location && index <= r.location + r.length {
                return r
            }
        }
        
        return nil
    }
    
    // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareLabel()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        textContainer.size = bounds.size
    }
    
    private func prepareLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        textContainer.lineFragmentPadding = 0
        
        isUserInteractionEnabled = true
    }
    
    // MARK: lazy properties
    private lazy var linkRanges = [NSRange]()
    private var selectedRange: NSRange?
    private lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
}
