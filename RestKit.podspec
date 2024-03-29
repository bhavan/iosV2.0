Pod::Spec.new do |s|
  s.name         =  'RestKit'
  s.version      =  '0.10.3'
  s.summary      =  'RestKit is a framework for consuming and modeling RESTful web resources on iOS and OS X.'
  s.homepage     =  'http://www.restkit.org'
  s.author       =  { 'Blake Watters' => 'blakewatters@gmail.com' }
  s.source       =  { :git => 'https://github.com/RestKit/RestKit.git', :tag => 'v0.10.3' }
  s.license      =  'Apache License, Version 2.0'

  s.source_files =  'Code/RestKit.h'
  
  # Platform setup
  s.requires_arc = false
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  
  ### Preferred dependencies

  s.preferred_dependency = 'JSON'

  s.subspec 'JSON' do |js|
    js.dependency 'RestKit/Network'
    js.dependency 'RestKit/ObjectMapping/JSON'
    js.dependency 'RestKit/ObjectMapping/CoreData'
    js.dependency 'RestKit/ObjectMapping'
    js.dependency 'RestKit/UI'
  end

  s.subspec 'XML' do |xs|
    xs.dependency 'RestKit/Network'
    xs.dependency 'RestKit/ObjectMapping/XML'
    xs.dependency 'RestKit/ObjectMapping/CoreData'
    xs.dependency 'RestKit/UI'
  end

  ### Subspecs

  s.subspec 'Network' do |ns|
    ns.source_files   = 'Code/Network', 'Code/Support'
    ns.ios.frameworks = 'Foundation', 'CFNetwork', 'Security', 'MobileCoreServices', 'SystemConfiguration'
    ns.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration'
    ns.dependency       'LibComponentLogging-NSLog', '>= 1.0.4'
    ns.dependency       'cocoa-oauth'
    ns.dependency       'FileMD5Hash', '1.0.0'
    ns.dependency       'SOCKit'     
  end
  
  s.subspec 'UI' do |ui|
    ui.source_files   = 'Code/UI'
    ui.ios.frameworks = 'QuartzCore'
  end

  s.subspec 'ObjectMapping' do |os|
    os.dependency     'ISO8601DateFormatter', '>= 0.6'
    os.dependency     'RestKit/Network'

	os.subspec 'Core' do |cor|
	  cor.source_files = 'Code/ObjectMapping/'
	end

    os.subspec 'JSON' do |jos|
      jos.source_files = 'Code/Support/Parsers/JSON/RKJSONParserJSONKit.{h,m}'
      jos.dependency     'RestKit/ObjectMapping/Core'
    end

    os.subspec 'XML' do |xos|
      xos.source_files = 'Code/Support/Parsers/XML/RKXMLParserXMLReader.{h,m}'
      xos.libraries    = 'xml2'
      xos.dependency     'XMLReader'
      xos.dependency     'RestKit/ObjectMapping/Core'      
    end

    os.subspec 'CoreData' do |cdos|
      cdos.source_files = 'Code/CoreData'
      cdos.frameworks   = 'CoreData'
      cdos.dependency     'RestKit/ObjectMapping/Core'      
    end
  end
  
  s.subspec 'Testing' do |ts|
    ts.source_files   = 'Code/Testing'
  end
end
