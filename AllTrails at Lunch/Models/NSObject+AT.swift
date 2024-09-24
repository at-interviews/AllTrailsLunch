import Foundation

extension NSObject {
    /// A computed property that returns the name of the class as a string.
    ///
    /// This property is particularly useful for generating reuse identifiers or logging.
    /// It returns the class name as a string using `String(describing:)`, which handles
    /// both Swift and Objective-C class names correctly.
    ///
    /// - Returns: The name of the class as a string.
    class var className: String {
        String(describing: self)
    }
}
