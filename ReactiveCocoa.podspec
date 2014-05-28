Pod::Spec.new do |s|
  s.name         = "ReactiveCocoa"
  s.version      = "3.0-dev"
  s.summary      = "A framework for composing and transforming streams of values."
  s.homepage     = "https://github.com/blog/1107-reactivecocoa-is-now-open-source"
  s.author       = { "Josh Abernathy" => "josh@github.com" }
  s.source       = { :git => "https://github.com/ReactiveCocoa/ReactiveCocoa.git", :commit => "ba287b0e7da712c3efb338030e6da985e932d8d5" }
  s.license      = 'MIT'
  s.description  = "ReactiveCocoa (RAC) is an Objective-C framework inspired by Functional Reactive Programming. It provides APIs for composing and transforming streams of values."

  s.requires_arc = true
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.prepare_command = <<-'END'
    find . \( -regex '.*EXT.*\.[mh]$' -o -regex '.*metamacros\.[mh]$' \) -execdir mv {} RAC{} \;
    find . -regex '.*\.[hm]' -exec sed -i '' -E 's@"(EXT.*|metamacros)\.h"@"RAC\1.h"@' {} \;
    find . -regex '.*\.[hm]' -exec sed -i '' -E 's@<ReactiveCocoa/(EXT.*)\.h>@<ReactiveCocoa/RAC\1.h>@' {} \;
  END

  s.subspec 'no-arc' do |sp|
    sp.source_files = 'ReactiveCocoaFramework/ReactiveCocoa/RACObjCRuntime.{h,m}'
    sp.requires_arc = false
  end

  s.subspec 'Core' do |sp|
    sp.dependency 'ReactiveCocoa/no-arc'
    sp.source_files = 'ReactiveCocoaFramework/ReactiveCocoa/**/*.{d,h,m}'
    sp.private_header_files = '**/*Private.h', '**/*EXTRuntimeExtensions.h'
    sp.exclude_files = 'ReactiveCocoaFramework/ReactiveCocoa/RACObjCRuntime.{h,m}'
    sp.ios.exclude_files = '**/*{AppKit,NSControl,NSText,NSTableView}*'
    sp.osx.exclude_files = '**/*{UIActionSheet,UIAlertView,UIBarButtonItem,UIButton,UICollectionReusableView,UICollectionView,UIControl,UIDatePicker,UIGestureRecognizer,UIRefreshControl,UISegmentedControl,UISlider,UIStepper,UISwitch,UITableView,UITableViewHeaderFooterView,UIText}*'
    sp.header_dir = 'ReactiveCocoa'
  end
end
