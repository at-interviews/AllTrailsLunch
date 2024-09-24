import Foundation
import UIKit

/// A protocol that offers a strongly-typed way to access the root view of a view hierarchy.
///
/// By conforming to this protocol, view controllers can define a specific type for their root view,
/// ensuring type safety and reducing the need for type casting when accessing the view. This is particularly
/// handy when the root view is a custom subclass of `UIView` with additional properties or methods.
///
/// - Note: This protocol is designed to be used with `UIViewController` subclasses.
public protocol RootViewOwner {

    /// The type of the root view associated with this view controller.
    ///
    /// This type must conform to `BaseView`, which might be a custom view class that
    /// includes additional setup or functionality beyond what a standard `UIView` offers.
    associatedtype RootViewType: BaseView

    /// The root view of the view hierarchy.
    ///
    /// This property gives access to the root view of the view controller's hierarchy,
    /// casting it to the specified `RootViewType`. It’s safe to use as long as the view
    /// has been loaded and is of the correct type.
    ///
    /// - Warning: This is a force-cast. Ensure the `view` property is actually of type `RootViewType`
    ///   to avoid runtime crashes.
    var rootView: RootViewType { get }

    /// Returns the root view if it has been loaded, or `nil` if it hasn’t.
    ///
    /// This property provides a safe way to access the root view without force unwrapping.
    /// It returns `nil` if the view controller's view hasn’t been loaded yet or if the view
    /// isn’t of type `RootViewType`.
    var rootViewIfLoaded: RootViewType? { get }
}

public extension RootViewOwner where Self: UIViewController {

    /// The root view of the view hierarchy.
    ///
    /// This computed property casts the `UIViewController`'s `view` property to the
    /// specified `RootViewType`. It’s typically accessed after the view has been loaded.
    ///
    /// - Returns: The root view cast to `RootViewType`.
    /// - Warning: This is a force-cast. Ensure the `view` property is of type `RootViewType`
    ///   to avoid a runtime crash.
    var rootView: RootViewType {
        return view as! RootViewType
    }

    /// Returns the root view if it has been loaded, or `nil` if it hasn’t.
    ///
    /// This property safely returns the root view cast to `RootViewType` if the view has been
    /// loaded. If the view isn’t loaded or can’t be cast to `RootViewType`, it returns `nil`.
    ///
    /// - Returns: The root view cast to `RootViewType`, or `nil` if not loaded or if the cast fails.
    var rootViewIfLoaded: RootViewType? {
        return viewIfLoaded as? RootViewType
    }
}
