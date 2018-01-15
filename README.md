# Swift Semantic Versioning #
A small library that implements [SemVer 2.0.0](https://semver.org/spec/v2.0.0.html). This is designed to be simple to
use and to easily fit into any Swift codebase.


## Examples ##
Let's say you have a release candidate of version 2.0 of your app. The following are all equivalent:

```Swift
_ = SemVer(major: 2, minor: 0, preRelease: ["RC", 1])
_ = SemVer(2,0,0, preRelease: ["RC",1])
_ = SemVer("2.0-RC.1")
_ = SemVer("2.0.0-RC.1")
```

These can also be compared using Swift comparison operators. For instance, all these are true:

```Swift
SemVer("2.0") == SemVer("2.0.0")
SemVer("1.2.0") < SemVer("2.0.0")
SemVer("1.2.0") <= SemVer("2.0.0")
SemVer("12.0") > SemVer("2.9.9")
```

Since this conforms to Semantic Version 2.0.0, attempting to use an invalid semantic version as a string will result in
a `nil` object:

```Swift
nil == SemVer("Obviously Bad")
nil == SemVer("1")
nil == SemVer("-2.0")
nil == SemVer("2.0-β")
nil == SemVer("2.0-beta_1")
nil == SemVer("1.-2")
nil == SemVer("1.2.-3")
nil == SemVer("1.2.3.4")
```


# License #
This is licensed under [BH-1-PS Opus 2](https://github.com/BlueHuskyStudios/Licenses/blob/dc25f90c72d0b88771db773c506f78a10c9699d2/Licenses/BH-1-PS.txt).
