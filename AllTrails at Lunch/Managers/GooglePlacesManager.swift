import GooglePlaces

class GooglePlacesManager {
    typealias SearchCompletionHandler = (Result<[Restaurant], Error>) -> Void

    enum Constants {
        static let defaultRadius: CLLocationDistance = 1000
        static let includedTypes = ["restaurant"]
    }

    // Properties of the place that we are interested in.
    private let placeProperties = [
        GMSPlaceProperty.name,
        GMSPlaceProperty.coordinate,
        GMSPlaceProperty.iconImageURL,
        GMSPlaceProperty.rating,
        GMSPlaceProperty.userRatingsTotal,
        GMSPlaceProperty.editorialSummary
    ].map { $0.rawValue }

    // Shared Google Places Client instance
    private var placesClient: GMSPlacesClient {
        GMSPlacesClient.shared()
    }

    // Singleton instance of GooglePlacesManager
    static let shared = GooglePlacesManager()

    // Private initializer to enforce singleton usage
    private init() {}
}

// MARK: - Public Methods

extension GooglePlacesManager {
    /// Searches for nearby places within a specified radius around a center coordinate.
    ///
    /// - Parameters:
    ///   - center: The geographic center of the search area.
    ///   - radius: The radius around the center to search for places.
    ///   - completion: A completion handler that provides the search results or an error.
    func searchNearbyPlaces(_ center: CLLocationCoordinate2D,
                            radius: CLLocationDistance,
                            completion: @escaping SearchCompletionHandler) {
        let restriction = GMSPlaceCircularLocationOption(center, radius)
        let request = GMSPlaceSearchNearbyRequest(locationRestriction: restriction, placeProperties: placeProperties)
        request.includedTypes = Constants.includedTypes

        let callback: GMSPlaceSearchNearbyResultCallback = { results, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let results = results else {
                completion(.failure(NSError(domain: "GooglePlacesManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred."])))
                return
            }

            completion(.success(results.map { Restaurant($0) }))
        }
        placesClient.searchNearby(with: request, callback: callback)
    }

    /// Searches for places based on a text query.
    ///
    /// - Parameters:
    ///   - queryText: The text query to search for places.
    ///   - completion: A completion handler that provides the search results or an error.
    func searchForPlace(_ queryText: String, completion: @escaping SearchCompletionHandler) {
        let request = GMSPlaceSearchByTextRequest(textQuery: queryText, placeProperties: placeProperties)

        let callback: GMSPlaceSearchByTextResultCallback = { results, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let results = results else {
                completion(.failure(NSError(domain: "GooglePlacesManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred."])))
                return
            }

            completion(.success(results.map { Restaurant($0) }))
        }

        placesClient.searchByText(with: request, callback: callback)
    }
}
