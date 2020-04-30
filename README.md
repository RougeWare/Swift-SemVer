# Swift Semantic Versioning #
A small library that implements [SemVer 2.0.0](https://semver.org/spec/v2.0.0.html), which is copyrighted to Tom Preston-Werner CC BY 3.0. This is designed to be simple to use and to easily fit into any Swift codebase.

This is designed to be as easy as possible to use. You may use the extremely-verbose and explicit initializer which labels every parameter, or the one that does the same thing but excludes the labels, or the one that simply takes any valid SemVer string and gently fails to `nil` if that string is invalid. You are encouraged to use whichever one of these suits the needs at the time of use. Some examples are included in the unit tests.

Keep in mind that the pre-release and build extensions can be easily represented as string- and integer-literals. For instance, `SemVer(1,2,0, SemVer.Build(identifiers: ["123", "4"]))` has the same result as `SemVer(1,2,0, "123.4")` and `SemVer(1,2,0, [123,4])`. Again, this is done for ease-of-use. `SemVer` itself would also be expressible by a string literal, but it has too many resrictions so a failable initializer is presented instead.

This also already conforms to `Comparable`, since comparison and precedence are a major part of the spec.


# Examples #
Let's say you have a release candidate of version 2.0.0 of your app. The following are all equivalent:

```swift
_ = SemVer(major: 2, minor: 0, preRelease: ["RC", 1])
_ = SemVer(2,0,0, preRelease: ["RC",1])
_ = SemVer("2.0.0-RC.1")
```

These can also be compared using Swift comparison operators. For instance, all these are true:

```swift
SemVer("2.0.0") == SemVer("2.0.0+42")
SemVer("1.2.0") < SemVer("2.0.0")
SemVer("1.2.0") <= SemVer("2.0.0")
SemVer("12.0.0") > SemVer("2.9.9")
SemVer("1.2.0-alpha.7") < SemVer("1.2.0")
```

Since this conforms to Semantic Version 2.0.0, attempting to use an invalid semantic version as a string will result in
a `nil` object:

```swift
nil == SemVer("Obviously Bad")
nil == SemVer("1")
nil == SemVer("1.2")
nil == SemVer("-2.0")
nil == SemVer("2.0-β")
nil == SemVer("2.0-beta_1")
nil == SemVer("1.-2")
nil == SemVer("1.2.-3")
nil == SemVer("1.2.3.4")
```


# License #
This is licensed under [BH-1-PS](https://github.com/BlueHuskyStudios/Licenses/blob/master/Licenses/BH-1-PS.txt).
