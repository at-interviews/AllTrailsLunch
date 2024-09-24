import UIKit

// MARK: - Auto Layout Initialization

extension UIView {
    /// Creates and returns a view instance with Auto Layout enabled.
    ///
    /// This method instantiates a new view of the class it’s called on and sets it up
    /// for use with Auto Layout by turning off `translatesAutoresizingMaskIntoConstraints`.
    ///
    /// - Returns: A new instance of the view with Auto Layout enabled.
    ///
    /// - Note: This method makes it easier to create views that will be used with Auto Layout,
    ///   as it automatically disables `translatesAutoresizingMaskIntoConstraints`, which is
    ///   necessary when setting up constraints programmatically.
    ///
    /// # Example:
    /// ```swift
    /// let customView = UIView.autolayout()
    /// ```
    /// In this example, `customView` is a `UIView` instance that’s ready to have Auto Layout constraints applied.
    class func autolayout() -> Self {
        let view = Self()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
