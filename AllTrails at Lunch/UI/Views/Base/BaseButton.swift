import UIKit

/// A foundational class for buttons, providing a structured approach to setup and layout.
///
/// `BaseButton` is designed to be subclassed, offering a framework for configuring button properties,
/// setting up subviews, and managing the layout of sublayers. The class conforms to the `Constructible` protocol,
/// which outlines methods for structuring the construction and layout process.
open class BaseButton: UIButton {

    // MARK: - Initialization

    /// Initializes a button with a specific frame.
    ///
    /// This initializer calls `construct()`, setting up the view hierarchy and constraints
    /// for the button. Subclasses can override methods within `construct()` to customize
    /// the setup process as needed.
    ///
    /// - Parameter frame: The frame rectangle for the button, measured in points.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }

    /// This initializer isn’t available. Use `init(frame:)` instead.
    @available(*, unavailable, message: "Use init(frame:) instead")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    /// Lays out the button’s sublayers.
    ///
    /// This method is called whenever the button’s sublayers need to be laid out. If the layer
    /// being laid out is the button's primary layer (`self.layer`), `setSublayerFrames()` is called
    /// to update the frames of any custom sublayers.
    ///
    /// - Parameter layer: The layer to be laid out.
    override open func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        // Ensures that only the button's primary layer triggers the sublayer layout.
        if layer == self.layer {
            setSublayerFrames()
        }
    }
}

// MARK: - Constructible Protocol Conformance

@objc
extension BaseButton: Constructible {

    /// Configures the primary properties of the button.
    ///
    /// Subclasses can override this method to customize the button’s appearance, such as
    /// setting the background color, accessibility identifiers, or adjusting layer properties.
    open func configureView() { /* No-Op: Override in inheriting class */ }

    /// Configures the subviews of the button.
    ///
    /// This method is a good place to set up subviews before adding them to the button’s view hierarchy.
    /// Subclasses should override this method to perform any necessary setup.
    open func configureSubviews() { /* No-Op: Override in inheriting class */ }

    /// Constructs and activates Auto Layout constraints.
    ///
    /// Override this method to define and activate the Auto Layout constraints
    /// for the button and its subviews.
    open func constructSubviewConstraints() { /* No-Op: Override in inheriting class */ }

    /// Adjusts the frames of custom sublayers.
    ///
    /// `layoutSublayers(of:)` calls this method when the button’s primary layer
    /// needs to update its sublayers. Subclasses can override this method to
    /// adjust the frames of any custom sublayers.
    open func setSublayerFrames() { /* No-Op: Override in inheriting class */ }

    /// Constructs the hierarchy of sublayers.
    ///
    /// Subclasses can override this method to add and organize any `CALayer` instances
    /// that need to be part of the button's layer hierarchy.
    open func constructSublayerHierarchy() { /* No-Op: Override in inheriting class */ }

    /// Constructs the hierarchy of subviews.
    ///
    /// Override this method to add and organize the button’s subviews within its view hierarchy.
    open func constructSubviewHierarchy() { /* No-Op: Override in inheriting class */ }
}
