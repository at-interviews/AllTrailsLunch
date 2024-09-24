import Foundation

/// A protocol that defines a structured approach to setting up views, subviews, and layers.
///
/// Types that conform to this protocol can follow a standardized series of steps
/// to ensure consistent initialization and configuration of views, subviews, and their
/// associated layout constraints and sub-layers.
public protocol Constructible {

    /// Configures the main view's properties and initial setup.
    ///
    /// Use this method to perform any necessary setup for the main view itself,
    /// like setting background colors, configuring layer properties, or assigning
    /// accessibility identifiers. It’s called as the first step in the construction process.
    func configureView()

    /// Configures the properties and initial setup for any subviews.
    ///
    /// This method is where you set up subviews before they’re added to the view hierarchy.
    /// Common tasks here include initializing subviews, setting their properties, and getting
    /// them ready for display.
    func configureSubviews()

    /// Constructs the hierarchy of sub-layers, if needed.
    ///
    /// This method handles adding and organizing any `CALayer` instances that
    /// should be part of the view's layer hierarchy. It’s optional and only necessary
    /// if the view uses custom layers.
    func constructSublayerHierarchy()

    /// Constructs the view hierarchy by adding subviews to their parent view.
    ///
    /// This method takes care of adding configured subviews to the main view by calling `addSubview(_:)`
    /// for each one. It ensures that all subviews are correctly placed within the view
    /// hierarchy.
    func constructSubviewHierarchy()

    /// Constructs and activates Auto Layout constraints for the view and its subviews.
    ///
    /// This method is where you define and activate the Auto Layout constraints
    /// needed to lay out the main view and its subviews. It ensures that everything is
    /// positioned and sized according to the constraints you’ve set.
    func constructSubviewConstraints()

    /// Updates the frames of any custom sub-layers.
    ///
    /// This method adjusts the frames of any sub-layers within the view's layer hierarchy.
    /// It’s typically called during layout updates or when the view's bounds change.
    func setSublayerFrames()
}

extension Constructible {

    /// A convenience method that calls the `Constructible` methods in the correct order.
    ///
    /// This method ensures that all steps in the construction process are executed in a
    /// consistent sequence. It’s typically called within the initializer (`init`)
    /// of types that conform to the `Constructible` protocol, providing a structured
    /// and predictable setup process for views.
    ///
    /// The order of invocation is:
    /// 1. `configureView()`
    /// 2. `configureSubviews()`
    /// 3. `constructSublayerHierarchy()`
    /// 4. `constructSubviewHierarchy()`
    /// 5. `constructSubviewConstraints()`
    ///
    /// By using this method, you ensure that the view and its subviews are properly
    /// configured, added to the view hierarchy, and laid out according to Auto Layout
    /// constraints.
    public func construct() {
        configureView()
        configureSubviews()
        constructSublayerHierarchy()
        constructSubviewHierarchy()
        constructSubviewConstraints()
    }
}
