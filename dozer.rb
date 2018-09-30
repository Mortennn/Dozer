cask 'dozer' do
  version '1'
  sha256 'd66d760842086b07fc81b950945af6e45f42e92d830470d22ec4e359413adefb'

  url 'https://github.com/Mortennn/Dozer/releases/download/v1/Dozer.dmg'
  name 'Dozer'
  homepage 'https://github.com/Mortennn/Dozer'

  depends_on macos: '>= :sierra'

  app 'Dozer.app'
  
end
