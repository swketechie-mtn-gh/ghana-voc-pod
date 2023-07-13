Pod::Spec.new do |spec|
  spec.name         = "DigiModule"
  spec.version      = "1.0.0"
  spec.summary      = "DigiModule SDK makes it easy to integrate Alliera functionality into your apps."

  spec.description  = <<-DESC
      DigiModule SDK makes it easy to integrate Alliera functionality into your apps.
  DESC

  spec.homepage     = "https://github.com/Alliera/digi-ios"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = "Alliera"

  spec.platform     = :ios, "12.0"

  spec.source       = { :git => "https://github.com/Alliera/digi-ios.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/DigiModule/**/*"
  spec.resource_bundles = {
    'DigiModule' => ['Sources/DigiModule/**/*.{html}']
  }

  spec.ios.frameworks = "UIKit", "WebKit"
  spec.swift_version = '5.0'

  spec.requires_arc = true
end
