LOCATION="${BUILT_PRODUCTS_DIR}"/"${FRAMEWORKS_FOLDER_PATH}"

# By default, use the configured code signing identity for the project/target
IDENTITY="${CODE_SIGN_IDENTITY}"
if [ "$IDENTITY" == "" ]
then
    # If a code signing identity is not specified, use ad hoc signing
    IDENTITY="-"
fi
codesign --verbose --force --deep -o runtime --sign "$IDENTITY" "$LOCATION/Sparkle.framework/Versions/A/Resources/AutoUpdate.app"
codesign --verbose --force -o runtime --sign "$IDENTITY" "$LOCATION/Sparkle.framework/Versions/A"
