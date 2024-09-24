import UIKit
import CoreLocation
import MapKit

class RestaurantResultsViewController: UIViewController, RootViewOwner {
    typealias RootViewType = RestaurantResultsContainerRootView

    private let locationManager: CLLocationManager
    private let googlePlacesManager: GooglePlacesManager
    private var lastKnownLocation: CLLocation?
    private var currentDisplayType: DisplayType = .list {
        didSet {
            refreshUI()
        }
    }
    private var restaurants: [Restaurant] = [] {
        didSet {
            refreshUI()
        }
    }

    init(locationManager: CLLocationManager = CLLocationManager(), googlePlacesManager: GooglePlacesManager = .shared) {
        self.locationManager = locationManager
        self.googlePlacesManager = googlePlacesManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle

extension RestaurantResultsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view = RootViewType(self)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
}

// MARK: - RestaurantResultsContainerRootViewDelegate

extension RestaurantResultsViewController: RestaurantResultsContainerRootViewDelegate {
    func didTapCTAButton() {
        toggleViewStyle()
    }
}

// MARK: - UITableViewDelegate & DataSource

extension RestaurantResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantInfoTableViewCell.identifier, for: indexPath) as! RestaurantInfoTableViewCell
        let restaurantModel = RestaurantInfoView.Model(restaurants[indexPath.row])
        cell.populate(restaurantModel)
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension RestaurantResultsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty, let coordinate = lastKnownLocation?.coordinate {
            searchNearbyPlaces(coordinate)
        } else {
            googlePlacesManager.searchForPlace(searchText) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let restaurants):
                        self?.restaurants = restaurants
                    case .failure(let error):
                        self?.handleError(error)
                    }
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}

// MARK: - CLLocationManagerDelegate

extension RestaurantResultsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            handleError(LocationError.authorizationDenied)
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            handleError(LocationError.unknownAuthorizationStatus)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastKnownLocation = location
        searchNearbyPlaces(location.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        handleError(error)
    }
}

// MARK: - Helpers

private extension RestaurantResultsViewController {
    func toggleViewStyle() {
        currentDisplayType = (currentDisplayType == .list) ? .map : .list
    }

    func searchNearbyPlaces(_ coordinate: CLLocationCoordinate2D) {
        let radius = GooglePlacesManager.Constants.defaultRadius
        googlePlacesManager.searchNearbyPlaces(coordinate, radius: radius) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let restaurants):
                    self?.restaurants = restaurants
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }

    func refreshUI() {
        let model = RestaurantResultsContainerRootView.Model(displayType: currentDisplayType, restaurants: restaurants)
        DispatchQueue.main.async {
            self.rootView.refresh(with: model)
        }
    }

    func handleError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

// MARK: - Error Types

enum LocationError: Error {
    case authorizationDenied
    case unknownAuthorizationStatus
}
