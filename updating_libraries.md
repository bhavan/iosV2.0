# IMPORTANT!
## Please read this before updating libraries through CocoaPods!


### RestKit / JSONKit issue

With release of 64-bit architecture, Apple has deprecated usage of `_isa` directive, which was actively used by JSONKit library.

Since RestKit library 0.10.3, used in this project, depends on it, it prevented building on 64-bit architectures.

Updating to RestKit 0.20 and higher requires major changes in codebase, and therefore wasn't implemented. It was started on `experimental` branch, but remains there for now, as it's not completed.

For now we've created local RestKit specification(RestKit.podspec), that does not have JSONKit dependency inside. JSONKit was manually removed from RESTKit codebase and replaced with native NSJSONSerialization class. This required adding Pods directory to repository.

When updating libraries through CocoaPods, make sure RestKit is not reinstalled, because this would destroy implemented fix.

