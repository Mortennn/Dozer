build:
	@brew bundle --no-upgrade
	@mkdir -p Dozer/Other/Generated
	@xcodegen 
	@xed "."

release:
	@echo "Running Fastlane deploy"
	@bundle exec fastlane release

.PHONY: build release 
