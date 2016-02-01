
Pod::Spec.new do |s|
  s.name                  = "LZCollectionView"
  s.version               = "0.2"
  s.summary               = "A custom CollectionView like UICollectionView in iOS."
  s.homepage              = "https://github.com/darling0825/LZCollectionView"
  s.license               = 'MIT'
  s.author                = { "darling0825" => "darling0825@163.com" }
  s.platform              = :osx, "10.7"
  s.osx.deployment_target = "10.7"
  s.source                = { :git => "https://github.com/darling0825/LZCollectionView.git", :tag => "0.2" }
  s.source_files          = "LZCollectionView/*.{h,m}"
  s.requires_arc          = true
end
