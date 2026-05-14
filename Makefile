build:
	@brew bundle --no-upgrade
	@carthage bootstrap --cache-builds --platform macOS --use-xcframeworks
	@mkdir -p Dozer/Other/Generated
	@swiftgen
	@xcodegen 
	@xed "."

arm64:
	@Scripts/build-arm64.sh

release:
	@echo "Running Fastlane deploy"
	@bundle exec fastlane release

.PHONY: build arm64 release
