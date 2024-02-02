import Foundation

#if os(iOS)
import UIKit
#else
import AppKit
#endif

public struct ComposeLayout {
    @SectionBuilder
    private var layoutBuilder: (_ environment: NSCollectionLayoutEnvironment) -> ComposeLayoutModel
    private var configuration: PlatformCompositionalLayoutConfiguration?
    private var decorationViewClasses: [String: AnyClass] = [:]
    
    public init(@ComposeLayoutBuilder layout: @escaping (_ environment: NSCollectionLayoutEnvironment) -> ComposeLayoutModel) {
        self.layoutBuilder = layout
    }
        
    public func register(_ viewClass: AnyClass, forDecorationViewOfKind elementKind: String) -> ComposeLayout {
        return mutable(self) { $0.decorationViewClasses[elementKind] = viewClass }
    }
}


// MARK: - Update Layout
extension ComposeLayout {
    public func configuration(_ configuration: PlatformCompositionalLayoutConfiguration) -> ComposeLayout {
        return mutable(self) { $0.configuration = configuration }
    }
}

// MARK: - Build Layout
extension ComposeLayout {
    public func build() -> PlatformCompositionalLayout {
        let layout = PlatformCompositionalLayout { index, environment in
            let composeLayoutModel = layoutBuilder(environment)
            return if index < composeLayoutModel.sections.count {
                composeLayoutModel.sections[index].toNSCollectionLayoutSection()
            } else {
                composeLayoutModel.sections.last?.toNSCollectionLayoutSection()
            }
                
        }

        decorationViewClasses.forEach { (key: String, value: AnyClass) in
            layout.register(value, forDecorationViewOfKind: key)
        }
        
        return layout
    }
}

// MARK: - Support List
#if !os(macOS)
extension ComposeLayout {
    @available(iOS 14.0, *)
    public static func list(using configuration: UICollectionLayoutListConfiguration) -> PlatformCompositionalLayout {
        return PlatformCompositionalLayout.list(using: configuration)
    }
}
#endif

