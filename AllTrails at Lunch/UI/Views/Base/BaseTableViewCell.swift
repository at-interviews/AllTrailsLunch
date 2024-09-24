import UIKit

/// A foundational class for table view cells that provides a structured approach to construction and layout.
///
/// `BaseTableViewCell` is meant to be subclassed, offering a framework for setting up cells, configuring subviews,
/// and managing the layout of sublayers. The class conforms to the `Constructible` and `ReusableCell` protocols,
/// which define methods for configuring and constructing the cell's hierarchy and layout constraints.
open class BaseTableViewCell: UITableViewCell, ReusableCell {

    // MARK: - Initialization

    /// Initializes a table view cell with a specific style and reuse identifier.
    ///
    /// This initializer calls `construct()`, which sets up the cell’s view hierarchy and constraints.
    /// Subclasses can override methods within `construct()` to customize the setup process.
    ///
    /// - Parameters:
    ///   - style: A constant indicating the cell style. The default is `.default`.
    ///   - reuseIdentifier: A string used to identify the cell object if it’s reused.
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        construct()
    }

    /// This initializer isn’t available. Use `init(style:reuseIdentifier:)` instead.
    @available(*, unavailable, message: "Use init(style:reuseIdentifier:) instead")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    /// Lays out the sublayers of the cell’s layer.
    ///
    /// This method is called whenever the cell’s sublayers need to be laid out. If the layer being laid out
    /// is the cell's primary layer (`self.layer`), `setSublayerFrames()` is called to update the frames of any custom sublayers.
    ///
    /// - Parameter layer: The layer to be laid out.
    override open func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        // Ensures that only the cell's primary layer triggers the sublayer layout.
        if layer == self.layer {
            setSublayerFrames()
        }
    }

    // MARK: - Helpers

    /// Registers the cell class with a specified table view.
    ///
    /// This method registers the `BaseTableViewCell` subclass with the given table view using its reuse identifier.
    ///
    /// - Parameter tableView: The table view in which to register the cell.
    static func register(in tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: identifier)
    }
}

// MARK: - Constructible Protocol Conformance

@objc
extension BaseTableViewCell: Constructible {

    /// Configures the cell's primary properties.
    ///
    /// Subclasses can override this method to customize the cell’s appearance, such as setting the background color,
    /// accessibility identifiers, or modifying layer properties.
    open func configureView() { /* No-Op: Override in inheriting class */ }

    /// Configures the subviews of the cell.
    ///
    /// This method is a good place to set up subviews before adding them to the cell’s view hierarchy.
    /// Subclasses should override this method to perform any necessary setup.
    open func configureSubviews() { /* No-Op: Override in inheriting class */ }

    /// Constructs and activates Auto Layout constraints.
    ///
    /// Override this method to define and activate the Auto Layout constraints for the cell and its subviews.
    open func constructSubviewConstraints() { /* No-Op: Override in inheriting class */ }

    /// Adjusts the frames of custom sublayers.
    ///
    /// `layoutSublayers(of:)` calls this method when the cell’s primary layer needs to update its sublayers.
    /// Subclasses can override this method to adjust the frames of any custom sublayers.
    open func setSublayerFrames() { /* No-Op: Override in inheriting class */ }

    /// Constructs the hierarchy of sublayers.
    ///
    /// Subclasses can override this method to add and organize any `CALayer` instances that need to be part of the cell's layer hierarchy.
    open func constructSublayerHierarchy() { /* No-Op: Override in inheriting class */ }

    /// Constructs the hierarchy of subviews.
    ///
    /// Override this method to add and organize the cell’s subviews within its view hierarchy.
    open func constructSubviewHierarchy() { /* No-Op: Override in inheriting class */ }
}
