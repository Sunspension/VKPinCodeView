Pod::Spec.new do |spec|

  spec.name         = "VKPinCodeView"
  spec.version      = "0.4.2"
  spec.summary      = "VKPinCodeView is a library written in Swift that provides the easy peasy way to enter code from SMS."

  spec.description  = <<-DESC
  VKPinCodeView is great when you need just in seconds make your custom entry PIN view. It is simple and elegant UI component written in Swift, and works like a charm. You can easily customise appearance and get auto fill iOS 12 feature right from the box.
                   DESC

  spec.homepage     = "https://github.com/Sunspension/VKPinCodeView"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license = "MIT"
  spec.author = { "Vladimir Kokhanevich" => "vladimir.kokhanevich@gmail.com" }

  spec.platform = :ios, "9.0"

  spec.source = { :git => "https://github.com/Sunspension/VKPinCodeView.git", :tag => spec.version }

  spec.source_files = "Source", "Sources/*.swift"
  spec.swift_version = "5.0"

end
