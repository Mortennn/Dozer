cask 'dozer' do
<<<<<<< HEAD
  version '1.1.3'
  sha256 '214c7feb7acfcc554c1a24cad11ff33fcfe1e402406209b969dc087527f45f1a'
=======
  version '2.0.0'
  sha256 '2aa0cd777cb37e7aaddd35d2e613b7bcfdfb1317fa13089de0914029d2750b85'
>>>>>>> v2

  url "https://github.com/Mortennn/Dozer/releases/download/#{version}/Dozer.#{version}.dmg"
  appcast 'https://raw.githubusercontent.com/Mortennn/Dozer/master/appcast.xml'
  name 'Dozer'
  homepage 'https://github.com/Mortennn/Dozer'

  auto_updates :yes
  depends_on macos: '>= :sierra'

  app 'Dozer.app'
end
