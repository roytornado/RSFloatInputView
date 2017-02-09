import UIKit
import CoreText

open class RSFloatInputView: UIView {
  fileprivate enum State {
    case idle, float
  }
  
  @IBInspectable var iconImage: UIImage? = nil
  @IBInspectable var iconSize: CGFloat = 30
  
  @IBInspectable var idlePlaceHolderColor = UIColor.lightGray
  @IBInspectable var floatPlaceHolderColor = UIColor.brown
  @IBInspectable var textColor: UIColor = UIColor.darkGray
  
  @IBInspectable var placeHolderStringKey: String = "" {
    didSet {
      //placeHolderLabel.text = ResString(placeHolderStringKey)
    }
  }
  @IBInspectable var placeHolderFontKey: String = "AmericanTypewriter"
  @IBInspectable var idlePlaceHolderFontSize: CGFloat = 16
  @IBInspectable var floatPlaceHolderFontSize: CGFloat = 14
  @IBInspectable var inputFontName: String = "AmericanTypewriter"
  @IBInspectable var inputFontSize: CGFloat = 16
  @IBInspectable var inputPadding: CGFloat = 4
  var animationDuration: Double = 0.45
  
  open var iconImageView = UIImageView()
  open var placeHolderLabel = CATextLayer()
  open var textField = UITextField()
  fileprivate var state: State = State.idle
  private var placeHolderCGFont: CGFont!
  private var placeHolderUIFont: UIFont!
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    build()
  }
  
  fileprivate func build() {
    placeHolderLabel.contentsScale = UIScreen.main.scale
    placeHolderCGFont = CGFont(placeHolderFontKey as CFString)
    placeHolderUIFont = UIFont(name: placeHolderFontKey, size: idlePlaceHolderFontSize)
    placeHolderLabel.font = placeHolderCGFont
    
    addSubview(textField)
    addSubview(iconImageView)
    layer.addSublayer(placeHolderLabel)
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focus)))
    textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    placeHolderLabel.foregroundColor = idlePlaceHolderColor.cgColor
    placeHolderLabel.string = "PlaceHolder"
    
    changeToIdle(animated: false)
    
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    layout()
  }
  
  func layout() {
    var currentX: CGFloat = 16
    if let iconImage = iconImage {
      iconImageView.isHidden = false
      iconImageView.image = iconImage
      iconImageView.frame = CGRect(x: currentX, y: viewHeight.half - iconSize.half, width: iconSize, height: iconSize)
      currentX += iconSize + 8
    } else {
      iconImageView.isHidden = true
    }
    //textField.font = UIFont.fontWithKey(inputFontKey, size: inputFontSize)
    if state == .idle {
      //placeHolderLabel.fontSize = idlePlaceHolderFontSize
      //placeHolderLabel.font = UIFont.fontWithKey(idelPlaceHolderFontKey, size: idelPlaceHolderFontSize)
      //placeHolderLabel.textColor = idelPlaceHolderColor
      //let placeHolderHeight = placeHolderLabel.font.lineHeight
      let placeHolderHeight: CGFloat = 16
      let textFieldHeight = textField.font!.lineHeight
      let inputHeight = placeHolderHeight + inputPadding + textFieldHeight
      let widthForInput = viewWidth - currentX
      //placeHolderLabel.frame = CGRect(x: currentX, y: 0, width: widthForInput, height: viewHeight)
      //textField.isHidden = true
      textField.frame = CGRect(x: currentX, y: viewHeight.half + inputHeight.half - textFieldHeight, width: widthForInput, height: textFieldHeight)
    } else {
      //placeHolderLabel.fontSize = idlePlaceHolderFontSize
      //placeHolderLabel.font = UIFont.fontWithKey(floatPlaceHolderFontKey, size: floatPlaceHolderFontSize)
      //placeHolderLabel.textColor = floatPlaceHolderColor
      //let placeHolderHeight = placeHolderLabel.font.lineHeight
      let placeHolderHeight: CGFloat = 16
      let textFieldHeight = textField.font!.lineHeight
      let inputHeight = placeHolderHeight + inputPadding + textFieldHeight
      let widthForInput = viewWidth - currentX
      //placeHolderLabel.frame = CGRect(x: currentX, y: viewHeight.half - inputHeight.half, width: widthForInput, height: placeHolderHeight)
      //textField.isHidden = false
      //textField.frame = CGRect(x: currentX, y: placeHolderLabel.ending.y + inputPadding , width: widthForInput, height: textFieldHeight)
    }
    //placeHolderLabel.frame = frameForPlaceHolder()
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
    placeHolderLabel.frame = frameForPlaceHolder()
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
    placeHolderLabel.frame = frameForPlaceHolder()
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
  
  func frameForPlaceHolder() -> CGRect {
    var currentX: CGFloat = 16
    if let _ = iconImage {
      currentX += iconSize + 8
    }
    let placeHolderHeight: CGFloat = placeHolderUIFont.lineHeight
    let textFieldHeight = textField.font!.lineHeight
    let inputHeight = placeHolderHeight + inputPadding + textFieldHeight
    let widthForInput = viewWidth - currentX
    if state == .idle {
      return CGRect(x: currentX, y: viewHeight.half - placeHolderHeight.half, width: widthForInput, height: idlePlaceHolderFontSize + 8)
    } else {
      return CGRect(x: currentX, y: viewHeight.half - inputHeight.half, width: widthForInput, height: idlePlaceHolderFontSize + 8)
    }
  }
}
