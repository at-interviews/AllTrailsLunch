import UIKit
/// A base class for all views in the application, providing a structured approach to view construction and layout.
///
/// The `BaseView` class is designed to be subclassed, offering a framework for setting up views, configuring
/// subviews, and managing the layout of sublayers. It adheres to the `Constructible` protocol, which defines
/// methods for configuring and constructing the view hierarchy and layout constraints.
open class BaseView: UIView {

    // MARK: - Initialization

    /// Initializes the view with the specified frame.
    ///
    /// This initializer calls the `construct()` method, which triggers the configuration and
    /// setup of the view hierarchy and constraints.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    /// This initializer is unavailable. Use `init(frame:)` instead.
    @available(*, unavailable, message: "Use init(frame:) instead")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    /// Lays out sublayers of the view's layer.
    ///
    /// This method is called whenever the view's sublayers need to be laid out. If the layer
    /// being laid out is the view's backing layer (`self.layer`), the `setSublayerFrames()` method
    /// is called to update the frames of any custom sublayers.
    ///
    /// - Parameter layer: The layer to be laid out.
    override open func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        // Ensure that only the view's primary layer triggers the sublayer layout.
        if layer == self.layer {
            setSublayerFrames()
        }
    }
}

// MARK: - Constructible Protocol Conformance

@objc
extension BaseView: Constructible {
    /// Configures the view's primary properties.
    ///
    /// This method is intended to be overridden by subclasses to configure the main view properties,
    /// such as background color, accessibility identifiers, or layer properties.
    open func configureView() { /* No-Op: Override in inheriting class */ }

    /// Configures the properties of the subviews.
    ///
    /// This method should be overridden by subclasses to set up subviews before they are added to the view hierarchy.
    open func configureSubviews() { /* No-Op: Override in inheriting class */ }

    /// Constructs and activates AutoLayout constraints.
    ///
    /// This method should be overridden by subclasses to define and activate the Auto Layout constraints
    /// for the view and its subviews.
    open func constructSubviewConstraints() { /* No-Op: Override in inheriting class */ }

    /// Sets the frames of any custom sublayers.
    ///
    /// This method is called by `layoutSublayers(of:)` and should be overridden to adjust the frames
    /// of any custom sublayers within the view's layer hierarchy.
    open func setSublayerFrames() { /* No-Op: Override in inheriting class */ }

    /// Constructs the hierarchy of sublayers.
    ///
    /// This method should be overridden by subclasses to add and organize any `CALayer` instances
    /// that need to be part of the view's layer hierarchy.
    open func constructSublayerHierarchy() { /* No-Op: Override in inheriting class */ }

    /// Constructs the hierarchy of subviews.
    ///
    /// This method should be overridden by subclasses to add and organize the view's subviews.
    open func constructSubviewHierarchy() { /* No-Op: Override in inheriting class */ }
}
