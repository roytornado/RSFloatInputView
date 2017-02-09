import UIKit
import RSFloatInputView

class LightViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var phoneInputView: RSFloatInputView!
  @IBOutlet weak var whatsappInputView: RSFloatInputView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    phoneInputView.textField.delegate = self
    whatsappInputView.textField.delegate = self
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

