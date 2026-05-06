# Backward Compatibility

Please note that this framework supports older OS X versions down to 10.10. When changing the code, be careful not to call any API functions not available in 10.10 or call them conditionally, only where supported.

# Commit Messages

Please use descriptive commit message. As an example, _Bug fix_ commit message doesn’t say much, while _Fix a memory-management bug in formatting code_ works much better. A [nice detailed article about writing commit messages](http://chris.beams.io/posts/git-commit/) is also available.

# How to Release a New Version

The release process is automated using [Fastlane](https://fastlane.tools). To install the tooling:

```bash
bundle install
```

To mint a new release:

```bash
bundle exec fastlane release
```

This will bump the version number, stamp the changelog, etc. By default, the command will produce a patch release. (MASShortcut uses [Semantic Versioning](http://semver.org/), so please read the docs if you’re not sure what the deal is.) If you want a minor or major bump:

```bash
bundle exec fastlane release type:minor
bundle exec fastlane release type:major
```

After pushing the release including tags (`git push --follow-tags`), don’t forget to publish the release in CocoaPods:

```bash
bundle exec fastlane trunk
```

That’s it. Go have a beer or a cup of tea to celebrate.
