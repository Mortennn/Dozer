build:
	@brew bundle --no-upgrade
	@carthage update --no-build --platform osx
	@# Patch Xcode 16 compatibility: libarclite was removed for deployment targets < 10.12
	@sed -i '' \
		's/MACOSX_DEPLOYMENT_TARGET = 10\.10;/MACOSX_DEPLOYMENT_TARGET = 10.13;/g; s/MACOSX_DEPLOYMENT_TARGET = 10\.11;/MACOSX_DEPLOYMENT_TARGET = 10.13;/g' \
		Carthage/Checkouts/MASShortcut/MASShortcut.xcodeproj/project.pbxproj \
		Carthage/Checkouts/Preferences/Preferences.xcodeproj/project.pbxproj
	@sed -i '' 's/GCC_TREAT_WARNINGS_AS_ERRORS = YES;/GCC_TREAT_WARNINGS_AS_ERRORS = NO;/g' \
		Carthage/Checkouts/MASShortcut/MASShortcut.xcodeproj/project.pbxproj
	@rm -rf Carthage/Checkouts/Preferences/Example
	@carthage build --platform osx --cache-builds
	@# Download pre-built Sparkle binary (Carthage cannot sign the Autoupdate command-line tool)
	@mkdir -p Carthage/Build/Mac
	@curl -sL https://github.com/sparkle-project/Sparkle/releases/download/1.27.3/Sparkle-1.27.3.tar.xz \
		| tar xJf - -C /tmp Sparkle.framework Sparkle.framework.dSYM 2>/dev/null; \
		cp -r /tmp/Sparkle.framework /tmp/Sparkle.framework.dSYM Carthage/Build/Mac/
	@# Fix symlinks broken by tar extraction
	@cd Carthage/Build/Mac/Sparkle.framework && \
		rm -rf Versions/Current && ln -s A Versions/Current && \
		for f in Headers Modules PrivateHeaders Resources Sparkle; do \
			[ -e "$$f" ] && rm -rf "$$f"; ln -s "Versions/Current/$$f" "$$f"; done
	@mkdir -p Dozer/Other/Generated
	@swiftgen
	@xcodegen
	@xed "."

release:
	@echo "Running Fastlane deploy"
	@bundle exec fastlane release

.PHONY: build release
