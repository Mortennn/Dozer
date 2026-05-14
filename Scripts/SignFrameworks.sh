LOCATION="${BUILT_PRODUCTS_DIR}"/"${FRAMEWORKS_FOLDER_PATH}"

# By default, use the configured code signing identity for the project/target
IDENTITY="${CODE_SIGN_IDENTITY}"
if [ "$IDENTITY" == "" ]
then
    # If a code signing identity is not specified, use ad hoc signing
    IDENTITY="-"
fi

SPARKLE_FRAMEWORK="$LOCATION/Sparkle.framework"
if [[ -d "$SPARKLE_FRAMEWORK/Versions/A" ]]; then
    SPARKLE_FRAMEWORK="$SPARKLE_FRAMEWORK/Versions/A"
fi

if [[ -d "$SPARKLE_FRAMEWORK/Resources/AutoUpdate.app" ]]; then
    codesign --verbose --force --deep -o runtime --sign "$IDENTITY" "$SPARKLE_FRAMEWORK/Resources/AutoUpdate.app"
fi

if [[ -d "$SPARKLE_FRAMEWORK" ]]; then
    codesign --verbose --force -o runtime --sign "$IDENTITY" "$SPARKLE_FRAMEWORK"
fi
