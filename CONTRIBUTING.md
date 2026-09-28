# Contributing to Dozer

There are various ways to contribute to Dozer, and all are welcome and appreciated!

- [Bug reports](#bug-reports)
- [Feature requests](#feature-requests)
- [Design](#design)
- [Code](#code)
    - [Getting started](#getting-started)
    - [Submitting your pull request](#submitting-your-pull-request)

## Bug reports
Open issues about problems you may be encountering. When doing so please mention the version you're using.

## Feature requests
If you have a good idea for a feature or enhancement open an issue.

## Design
Refresh the Dozer icons or logo. [Design resources for logo and status bar icon](https://www.figma.com/file/g5MhiwxR1YFg5vti0tPANa/Dozer).

## Code
You can submit your own code. This can be bug fixes or new features. Please ask me (@Mortennn) before implementing a new feature. Check out [Issues](https://github.com/Mortennn/Dozer/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc).

### Getting started
Make sure you have at least Xcode 10 installed.

Run the following command:
```shell
git clone https://github.com/mortennn/dozer &&
cd dozer &&
make build
```
Done! The project should open automatically in Xcode.

### Testing the macOS 27 branch

`make app` builds a locally signed universal app; `make test` runs the compatibility
tests. `make build` still prepares the project and opens Xcode. Dependency versions
are pinned in `Cartfile.resolved`; `Configs/Dependencies.xcconfig` applies the
deployment and architecture settings needed by current Xcode.

For a manual check, install in `/Applications`, grant Accessibility, and place
one third-party app left of the left dot and another to its right. Verify hide,
show, repeated clicks, Option-click with the remove dot enabled, shortcut-only
mode, automatic hiding, and quitting while hidden. Check that apps to the right
and system controls remain visible. Also check separate displays and a notched
display; only macOS 27 uses the native visibility service. Use macOS 26 or earlier
to verify the legacy length-based path.

### Submitting your pull request
Please give a small summary of what has changed. Also add any github issues links (`Fixes #100`).
Once your pull request is created, please add a changelog entry to the CHANGELOG.md along with the PR number.
