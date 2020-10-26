Pod::Spec.new do |s|
  s.name             = "AEPRulesEngine"
  s.version          = "1.0.0-beta.1"
  s.summary          = "AEPRulesEngine"
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
  s.source_files          = 'Sources/AEPRulesEngine/**/*.swift'


end
