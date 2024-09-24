import UIKit

extension UITableView {
    /// Registers a reusable table view cell using the cell's type.
    ///
    /// This method registers a `UITableViewCell` subclass that conforms to the `ReusableCell`
    /// protocol, which provides a reuse identifier for the cell. The identifier is automatically
    /// derived from the class name, ensuring that each cell type has a unique and consistent identifier.
    ///
    /// - Parameter type: The `UITableViewCell` subclass type to register. The type must
    ///   conform to the `ReusableCell` protocol, which ensures that it has a reuse identifier.
    ///
    /// - Note: This method makes the registration process easier by automatically using the
    ///   cell's type to determine its reuse identifier, reducing the chances of errors that
    ///   can happen when manually specifying the identifier as a string.
    ///
    /// # Example:
    /// ```swift
    /// tableView.register(CustomTableViewCell.self)
    /// ```
    /// In this example, `CustomTableViewCell` is registered with the table view. The
    /// `CustomTableViewCell` class must conform to the `ReusableCell` protocol.
    func register<T: UITableViewCell>(_ type: T.Type) where T: ReusableCell {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
}
