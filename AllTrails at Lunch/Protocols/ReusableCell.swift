import UIKit

/// A protocol that defines a reusable cell's unique identifier.
///
/// When a `UIView` subclass, like `UITableViewCell` or `UICollectionViewCell`, conforms to this protocol,
/// it provides a static identifier that can be used for cell reuse within a `UITableView` or `UICollectionView`.
/// This approach eliminates the need to manually define string-based identifiers, which helps reduce potential errors.
protocol ReusableCell: AnyObject {
    /// A unique identifier for the reusable cell.
    ///
    /// This identifier is typically used when registering and dequeuing cells in a `UITableView` or `UICollectionView`.
    /// By default, it returns the class name of the conforming type, ensuring that each cell type has a unique identifier.
    static var identifier: String { get }
}

extension ReusableCell where Self: UIView {
    /// Provides a default implementation of the `identifier` property.
    ///
    /// The default implementation returns the class name of the conforming `UIView` subclass.
    /// This way, each cell type gets a unique identifier without needing to manually define it.
    /// The class name is naturally unique within a project, making it a reliable choice for this purpose.
    static var identifier: String {
        className
    }
}
