import UIKit
import Kingfisher

extension UIImageView {
    /// Loads an image from a URL string, displaying a placeholder while it’s being fetched.
    ///
    /// This method uses the Kingfisher library to load an image from the provided URL string.
    /// If the URL is invalid or the image fails to load, the specified placeholder image is shown instead.
    ///
    /// - Parameters:
    ///   - urlString: The URL string where the image is located.
    ///   - placeholder: The image to display while the main image is loading. If not specified, no placeholder is shown.
    func setImage(from urlString: String?, placeholder: UIImage? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        kf.setImage(with: url, placeholder: placeholder) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("Error loading image from URL: \(urlString). Error: \(error.localizedDescription)")
                self.image = placeholder
            }
        }
    }
}
