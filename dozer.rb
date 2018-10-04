cask 'dozer' do
  version '1.1.0'
  sha256 'ac29079a49e3d2705e41eb3a62fb5100b25588a7d137d317e3b5951a5a5a204b'
  
  url 'https://github.com/Mortennn/Dozer/releases/tag/1.1.0/Dozer.1.1.0.dmg'
  appcast "https://raw.githubusercontent.com/Mortennn/Dozer/master/appcast.xml"
  name 'Dozer'
  homepage 'https://github.com/Mortennn/Dozer'

  depends_on macos: '>= :sierra'

  app 'Dozer.app'
  
end
