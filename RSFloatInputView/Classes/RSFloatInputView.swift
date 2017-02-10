import UIKit
import CoreText

open class RSFloatInputView: UIView {
  open static var stringTransformer: ((String) -> String?)! = {
    orginal in
    return orginal
  }
  open static var instanceTransformer: ((RSFloatInputView) -> Void)! = {
    orginal in
  }
  
  fileprivate enum State {
    case idle, float
  }
  
  @IBInspectable open var applyTransform: Bool = true
  @IBInspectable open var leftInset: CGFloat = 16
  @IBInspectable open var rightInset: CGFloat = 16
  @IBInspectable open var textInnerPadding: CGFloat = 2
  @IBInspectable open var imageInnerPadding: CGFloat = 8
  
  @IBInspectable open var iconImage: UIImage? = nil
  @IBInspectable open var iconSize: CGFloat = 30
  
  @IBInspectable open var idlePlaceHolderColor: UIColor = UIColor.lightGray
  @IBInspectable open var floatPlaceHolderColor: UIColor = UIColor.blue
  @IBInspectable open var textColor: UIColor = UIColor.darkGray
  @IBInspectable open var placeHolderStringKey: String = "" {
    didSet {
      placeHolderLabel.string = RSFloatInputView.stringTransformer(placeHolderStringKey)
    }
  }
  @IBInspectable open var placeHolderFontKey: String = "HelveticaNeue" {
    didSet {
      configFontsAndColors()
    }
  }
  @IBInspectable open var idlePlaceHolderFontSize: CGFloat = 16
  @IBInspectable open var floatPlaceHolderFontSize: CGFloat = 14
  @IBInspectable open var inputFontName: String = "HelveticaNeue" {
    didSet {
      configFontsAndColors()
    }
  }
  @IBInspectable open var inputFontSize: CGFloat = 16{
    didSet {
      configFontsAndColors()
    }
  }
  
  @IBInspectable open var separatorEnabled: Bool = true
  @IBInspectable open var separatorColor: UIColor = UIColor.lightGray
  @IBInspectable open var separatorLeftInset: CGFloat = 0
  @IBInspectable open var separatorRightInset: CGFloat = 0
  
  @IBInspectable open var animationDuration: Double = 0.45
  
  open var iconImageView = UIImageView()
  open var placeHolderLabel = CATextLayer()
  open var textField = UITextField()
  open var separatorView = UIView()
  fileprivate var state: State = State.idle
  fileprivate var placeHolderCGFont: CGFont!
  fileprivate var placeHolderUIFont: UIFont!
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    build()
  }
  
  fileprivate func build() {
    placeHolderLabel.contentsScale = UIScreen.main.scale
    addSubview(textField)
    addSubview(iconImageView)
    addSubview(separatorView)
    layer.addSublayer(placeHolderLabel)
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focus)))
    textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    if applyTransform { RSFloatInputView.instanceTransformer(self) }
    configFontsAndColors()
    changeToIdle(animated: false)
  }
  
  func configFontsAndColors() {
    placeHolderCGFont = CGFont(placeHolderFontKey as CFString)
    placeHolderUIFont = UIFont(name: placeHolderFontKey, size: idlePlaceHolderFontSize)
    placeHolderLabel.font = placeHolderCGFont
    textField.textColor = textColor
    textField.font = UIFont(name: inputFontName, size: inputFontSize)
    textField.tintColor = tintColor
    separatorView.backgroundColor = separatorColor
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    layout()
  }
  
  func layout() {
    var currentX: CGFloat = leftInset
    if let iconImage = iconImage {
      iconImageView.isHidden = false
      iconImageView.image = iconImage
      iconImageView.frame = CGRect(x: currentX, y: viewHeight.half - iconSize.half, width: iconSize, height: iconSize)
      currentX += iconSize + imageInnerPadding
    } else {
      iconImageView.isHidden = true
    }
    let placeHolderHeight: CGFloat = placeHolderUIFont.lineHeight + 2
    let textFieldHeight = textField.font!.lineHeight + 2
    let inputHeight = placeHolderHeight + textInnerPadding + textFieldHeight
    let widthForInput = viewWidth - currentX - rightInset
    if state == .idle {
      placeHolderLabel.frame = CGRect(x: currentX, y: viewHeight.half - placeHolderHeight.half, width: widthForInput, height: idlePlaceHolderFontSize + 8)
    } else {
      placeHolderLabel.frame = CGRect(x: currentX, y: viewHeight.half - inputHeight.half, width: widthForInput, height: idlePlaceHolderFontSize + 8)
    }
    textField.frame = CGRect(x: currentX, y: viewHeight.half + inputHeight.half - textFieldHeight, width: widthForInput, height: textFieldHeight)
    
    separatorView.isHidden = !separatorEnabled
    separatorView.frame = CGRect(x: separatorLeftInset, y: viewHeight - 1, width: viewWidth - separatorLeftInset - separatorRightInset, height: 1)
  }
  
  func changeToFloat(animated: Bool) {
    let animationDuration = animated ? self.animationDuration : 0.0
    state = .float
    textField.isHidden = false
    CATransaction.begin()
    CATransaction.setAnimationDuration(animationDuration)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
    placeHolderLabel.foregroundColor = floatPlaceHolderColor.cgColor
    placeHolderLabel.fontSize = floatPlaceHolderFontSize
    layout()
    CATransaction.commit()
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseOut
      , animations: {
        self.textField.alpha = 1.0
    }
      , completion: {
        _ in
        
    })
  }
  
  func changeToIdle(animated: Bool) {
    let animationDuration = animated ? self.animationDuration : 0.0
    state = .idle
    CATransaction.begin()
    CATransaction.setAnimationDuration(animationDuration)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
    placeHolderLabel.foregroundColor = idlePlaceHolderColor.cgColor
    placeHolderLabel.fontSize = idlePlaceHolderFontSize
    layout()
    CATransaction.commit()
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseOut
      , animations: {
        self.textField.alpha = 0.0
    }
      , completion: {
        _ in
        
    })
  }
  
  func focus() {
    textField.becomeFirstResponder()
    changeToFloat(animated: true)
  }
  
  func editingDidEnd() {
    if let text = textField.text, text.characters.count > 0 {
      changeToFloat(animated: true)
    } else {
      changeToIdle(animated: true)
    }
  }
  
}
