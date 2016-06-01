Pod::Spec.new do |s|
  s.name         = "Curly"
  s.version      = "1.1.0"
  s.summary      = "iOS library adding closure (block or callback) functionality to several native classes (alert views, buttons, etc)"
  s.description  = <<-DESC
                    iOS library adding closure (block or callback) functionality to several native classes (alert views, buttons, sliders, storyboard segues, gesture recognizers, etc).

                    This library is written in Swift but it also works in Objective-C. Make sure to read the installation notes below.
                    DESC
  s.homepage     = "https://github.com/wircho/Curly"
  s.license      = { :type => "MIT" }
  s.author       = { "wircho" => "correo.de.adolfo@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/wircho/Curly.git", :tag => s.version }
  s.source_files  = "Curly.swift"
  s.requires_arc  = true
  s.compiler_flags = '-DSWIFT_OPTIMIZATION_LEVEL=-Onone'
end
