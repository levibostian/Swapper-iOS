# [1.0.0](https://github.com/levibostian/Swapper-iOS/compare/0.2.1...1.0.0) (2020-08-19)


### Features

* swap to view after setting views ([6c0cb88](https://github.com/levibostian/Swapper-iOS/commit/6c0cb88526c704d7efe16bee4a8c1fad649530f6))


### BREAKING CHANGES

* add new required parameter to setSwappingViews()

### [0.2.1] - 2020-01-23

### Fixed 
- swapperview added a padding to childviews

### [0.2.0] - 2019-12-30

### Changed 
- Disable animations through UIView config

### [0.1.1] - 2019-08-21

### Fixed 
- swapTo() cancels previous request

### Changed
- Using new git hooks tool. A packaged bash script. 
- Assert certain functions called from main thread

### [0.1.0] - 2019-08-08

First release!

### Added 
- Created `SwapperView` that is designed to quickly swap between children `UIView`s for you quickly and easily. 
- Swapper automatically fades in and out animation on the views when swapping. 
- Swapper updates AutoLayout constraints of children `UIView`s for you. 
- Added way to set default configuration of `SwapperView` instances. 
- Added way to set configuration of 1 instance of `SwapperView`.
