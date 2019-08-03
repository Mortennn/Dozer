build:
	@brew bundle
	@carthage bootstrap --cache-builds --platform osx
	@mkdir Dozer/Other/Generated
	@swiftgen
	@xcodegen 
	@xed "."

release:
	@echo "Running Fastlane deploy"
	@bundle exec fastlane deploy submit:true

.PHONY: build release 
