cask 'dozer' do
  version '1.1.1'
  sha256 '41909d68be68df4027bb64fa998427dd8cf5879cf8a97333d7a8b97c05dc6415'
  
  url 'https://github.com/Mortennn/Dozer/releases/download/1.1.1/Dozer.1.1.1.dmg'
  appcast "https://raw.githubusercontent.com/Mortennn/Dozer/master/appcast.xml"
  name 'Dozer'
  homepage 'https://github.com/Mortennn/Dozer'

  depends_on macos: '>= :sierra'

  app 'Dozer.app'
  
end
