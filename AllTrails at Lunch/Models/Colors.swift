import UIKit

// MARK: - Design Colors

extension UIColor {

    /// Creates a color from the provided RGB values.
    ///
    /// - Parameters:
    ///   - r: The red component of the color (0-255).
    ///   - g: The green component of the color (0-255).
    ///   - b: The blue component of the color (0-255).
    ///   - a: The alpha component of the color (0-1). The default value is 1.0.
    /// - Returns: A `UIColor` object with the specified RGB values.
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }

    /// RGBA: (239, 239, 236, 1)
    static var backgroundLight: UIColor {
        return rgb(239, 239, 236)
    }

    /// A pure white color, equivalent to `UIColor.white`.
    static var pureWhite: UIColor {
        return .white
    }

    /// RGBA: (219, 218, 210, 1)
    static var separatorColor: UIColor {
        return rgb(219, 218, 210)
    }

    /// RGBA: (44, 86, 1, 1)
    static var ctaButtonBackground: UIColor {
        return rgb(44, 86, 1)
    }

}
