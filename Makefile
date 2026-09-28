build:
	@brew bundle --no-upgrade
	@$(MAKE) prepare
	@xed "."

prepare:
	@sh Scripts/Bootstrap.sh
	@mkdir -p Dozer/Other/Generated
	@swiftgen
	@xcodegen

app: prepare
	@xcodebuild -project Dozer.xcodeproj -scheme Dozer -configuration Release -derivedDataPath build CODE_SIGN_IDENTITY=- ENABLE_HARDENED_RUNTIME=NO build

test:
	@xcodegen
	@xcodebuild -project Dozer.xcodeproj -scheme Dozer -configuration Debug -derivedDataPath build CODE_SIGN_IDENTITY=- test

release:
	@echo "Running Fastlane deploy"
	@bundle exec fastlane release

.PHONY: build prepare app test release
