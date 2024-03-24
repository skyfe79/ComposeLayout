# ComposeLayout

![license MIT](https://img.shields.io/cocoapods/l/ListKit.svg)
![Platform](https://img.shields.io/badge/iOS-%3E%3D%2013.0-green.svg)
![Platform](https://img.shields.io/badge/macOS-%3E%3D%2010.15-orange.svg)

ComposeLayout is a DSL for Compositional Layout used in CollectionViews on iOS and MacOS. It is a part of [ListKit](https://github.com/ReactComponentKit/ListKit) that I previously developed and released. I have extracted the Compositional Layout configuration part from ListKit and re-released it as ComposeLayout. 

## Installation

ComposeLayout only support Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/skyfe79/ComposeLayout.git", from: "0.0.2"),
]
```

## [Examples](https://github.com/skyfe79/ComposeLayout/tree/main/Examples)

Using ComposeLayout makes writing complex Compositional Layouts intuitive and easy, allowing for straightforward composition of layouts. When developing iOS apps with UIKit's UICollectionView, ComposeLayout can greatly simplify the process of expressing and managing the layouts of CollectionViews. Below is an example code of Compositional Layout representing a 2-column grid.

```swift
ComposeLayout { index, environment in
    Section {
        HGroup(repeatItems: 2) {
            Item()
                .width(.fractionalWidth(1.0))
                .height(.fractionalHeight(1.0))
        }
        .interItemSpacing(.fixed(10))
        .width(.fractionalWidth(1.0))
        .height(.absolute(44))
    }
    .interGroupSpacing(10)
    .contentInsets(leading: 10, top: 0, trailing: 10, bottom: 0)
}
.build()
```

The [Example folder](https://github.com/skyfe79/ComposeLayout/tree/main/Examples) in this repository contains sample codes that have been rewritten using ComposeLayout for both iOS and MacOS. These examples are based on the [Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views) officially distributed by Apple.


## MIT License

Copyright (c) 2024 ComposeLayout

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
