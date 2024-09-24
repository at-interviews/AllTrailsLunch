import GooglePlaces

struct Restaurant {
    let name: String
    let rating: Float
    let numberOfReviews: Int
    let summary: String
    let coordinate: CLLocationCoordinate2D
    let iconImageURL: String?

    /// Initializes a `Restaurant` with the provided details.
    ///
    /// - Parameters:
    ///   - name: The name of the restaurant.
    ///   - rating: The restaurant's rating, represented as a `Float`.
    ///   - numberOfReviews: The total number of reviews for the restaurant.
    ///   - summary: A brief summary or description of the restaurant.
    ///   - coordinate: The geographic coordinates of the restaurant.
    ///   - iconImageURL: An optional URL string for the restaurant's icon image.
    init(_ name: String,
         rating: Float,
         numberOfReviews: Int,
         summary: String,
         coordinate: CLLocationCoordinate2D,
         iconImageURL: String?) {
        self.name = name
        self.rating = rating
        self.numberOfReviews = numberOfReviews
        self.summary = summary
        self.coordinate = coordinate
        self.iconImageURL = iconImageURL
    }

    /// Initializes a `Restaurant` from a `GMSPlace` instance.
    ///
    /// - Parameter place: A `GMSPlace` object that contains details about the place.
    ///
    /// This initializer extracts relevant information from a `GMSPlace` object to create a
    /// `Restaurant` instance, including the name, rating, number of reviews, summary,
    /// geographic coordinates, and an optional icon image URL.
    init(_ place: GMSPlace) {
        self.name = place.name ?? ""
        self.rating = place.rating
        self.numberOfReviews = Int(place.userRatingsTotal)
        self.summary = place.editorialSummary ?? ""
        self.coordinate = place.coordinate
        self.iconImageURL = place.iconImageURL?.absoluteString
    }
}
