# RSFloatInputView

[![Version](https://img.shields.io/cocoapods/v/RSFloatInputView.svg?style=flat)](http://cocoapods.org/pods/RSFloatInputView)
[![License](https://img.shields.io/cocoapods/l/RSFloatInputView.svg?style=flat)](http://cocoapods.org/pods/RSFloatInputView)
[![Platform](https://img.shields.io/cocoapods/p/RSFloatInputView.svg?style=flat)](http://cocoapods.org/pods/RSFloatInputView)

## Features
* Smooth animation using CoreText
* Support optional left icon
* Support optional seperator
* Configurable padding, size, fonts and colors
* Ready for multi styles
* Ready for string localization
* Configurable in interface builder

## Demo

[Yotube Video Demo](https://youtu.be/_08pUzXVp5s "Youtube")

![Gif](./ss_gif.gif?raw=true)
![In light theme](./ss_light.png?raw=true "In light theme")
![In dark theme](./ss_dark.png?raw=true "In dark theme")

## Customization

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    RSFloatInputView.stringTransformer = {
      orginal in
      // Transform the place holder string configured in XIB with your own way.
      // e.g return NSLocalizedString(orginal, comment: orginal)
      return orginal.replacingOccurrences(of: "TXT_", with: "")
    }
    RSFloatInputView.instanceTransformer = {
      instance in
      // Support multi-styles in one place using the tag
      if instance.tag == 0 {
        instance.floatPlaceHolderColor = UIColor.brown
        instance.textColor = UIColor.darkText
        instance.tintColor = UIColor.brown
      }
      if instance.tag == 1 {
        instance.floatPlaceHolderColor = UIColor.blue
        instance.textColor = UIColor.darkText
        instance.tintColor = UIColor.blue
      }
    }
    return true
  }
```

## Requirements
* iOS 8.0
* Swift 3.0

## Installation

RSFloatInputView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "RSFloatInputView"
```

## Author

roytornado, roytornado@gmail.com

## License

RSFloatInputView is available under the MIT license. See the LICENSE file for more info.
