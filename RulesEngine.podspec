Pod::Spec.new do |s|
  s.name             = "RulesEngine"
  s.version          = "0.0.1"
  s.summary          = "RulesEngine"
  s.description      = <<-DESC
                      A simple, generic, extensible Rules Engine in Swift
                        DESC
  s.homepage         = "https://github.com/adobe/aepsdk-rulesengine-ios"
  s.license          = 'Apache V2'
  s.author       = "Adobe Experience Platform SDK Team"
  s.source           = { :git => "https://github.com/adobe/aepsdk-rulesengine-ios.git", :tag => s.version.to_s }

  s.requires_arc          = true

  s.ios.deployment_target = '10.0'

  s.swift_version = '5.0'
  s.source_files          = 'Sources/RulesEngine/**/*.swift'


end
