# Uncomment the next line to define a global platform for your project
platform :ios, '15.5'

def ui_pods
  pod 'SnapKit', '~> 5.6.0'
  pod 'RiveRuntime'
end

def rx_pods
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
end

def utility_pods
  pod 'Resolver'
end

target 'NFT' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  ui_pods
  rx_pods
  utility_pods

end
