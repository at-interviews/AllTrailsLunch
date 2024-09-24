
import UIKit
import MapKit

protocol RestaurantResultsContainerRootViewDelegate: CTAButtonDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate { }

class RestaurantResultsContainerRootView: BaseView {

    private enum Constants {
        static let verticalInset: CGFloat = 8.0
        static let horizontalInset: CGFloat = 16.0
        static let seperatorHeight: CGFloat = 1.0
        static let placeholderText: String = "Search restaurants"
        static let desiredZoomLevel: CLLocationDistance = 1000
    }

    private let headerImage: UIImageView = {
        let iv = UIImageView.autolayout()
        iv.image = .logoLockup
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar.autolayout()
        sb.placeholder = Constants.placeholderText
        sb.image(for: .search, state: .normal)
        sb.searchBarStyle = .minimal
        sb.delegate = delegate
        return sb
    }()
    private let headerContainerView: UIView = {
        let hv = UIView.autolayout()
        hv.backgroundColor = .pureWhite
        return hv
    }()
    private let seperatorView: UIView = {
        let sv = UIView.autolayout()
        sv.backgroundColor = .separatorColor
        return sv
    }()

    private lazy var mapView: MKMapView = {
        let mv = MKMapView.autolayout()
        mv.showsUserLocation = true
        mv.delegate = self
        return mv
    }()

    private lazy var listView: UITableView = {
        let tv = UITableView.autolayout()
        tv.backgroundColor = .backgroundLight
        tv.separatorStyle = .none
        tv.dataSource = delegate
        tv.delegate = delegate
        tv.register(RestaurantInfoTableViewCell.self)
        tv.allowsSelection = false
        tv.showsVerticalScrollIndicator =  false
        return tv
    }()

    private lazy var ctaButon: CTAButton = {
        let ctab = CTAButton(delegate: delegate)
        ctab.translatesAutoresizingMaskIntoConstraints = false
        return ctab
    }()

    private let delegate: RestaurantResultsContainerRootViewDelegate
    private var restaurants: [Restaurant] = [] {
        didSet {
            datasourceDidChange()
        }
    }

    init(_ delegate: RestaurantResultsContainerRootViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
    }
}

// MARK: - Configuration

extension RestaurantResultsContainerRootView {
    override func configureView() {
        backgroundColor = .pureWhite
    }
}

// MARK: - Construction

extension RestaurantResultsContainerRootView {
    override func constructSubviewConstraints() {

        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerContainerView.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Constants.verticalInset)
        ])

        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: Constants.verticalInset),
            headerImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: Constants.verticalInset),
            searchBar.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -Constants.horizontalInset),
            searchBar.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: Constants.horizontalInset),
        ])

        NSLayoutConstraint.activate([
            seperatorView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            seperatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: Constants.seperatorHeight)
        ])

        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: seperatorView.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            listView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: trailingAnchor),
            listView.topAnchor.constraint(equalTo: seperatorView.bottomAnchor),
            listView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            ctaButon.centerXAnchor.constraint(equalTo: centerXAnchor),
            ctaButon.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.verticalInset)
        ])
    }

    override func constructSubviewHierarchy() {
        addSubview(headerContainerView)
        headerContainerView.addSubview(headerImage)
        headerContainerView.addSubview(searchBar)

        addSubview(seperatorView)
        addSubview(mapView)
        addSubview(listView)
        addSubview(ctaButon)
    }
}

// MARK: - MapViewDelegate

extension RestaurantResultsContainerRootView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        let identifier = "RestaurantAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.image = .pinResting

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }

        if let foundRestaraunt = (restaurants.first{ annotation.title == $0.name}) {
            let calloutView = RestaurantInfoView()
            calloutView.populate(RestaurantInfoView.Model(foundRestaraunt))
            view.detailCalloutAccessoryView = calloutView
        }
        view.image = .pinSelected
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = .pinResting
    }
}

// MARK: - Public Helpers

extension RestaurantResultsContainerRootView {
    func refresh(with model: Model) {
        switch model.displayType {
        case .list:
            bringSubviewToFront(listView)
            ctaButon.populate(using: CTAButton.Model(.map))

        case .map:
            bringSubviewToFront(mapView)
            ctaButon.populate(using: CTAButton.Model(.list))
            // Set the center to the user's current location
            let userLocation = mapView.userLocation.coordinate
            let regionRadius: CLLocationDistance = Constants.desiredZoomLevel
            let coordinateRegion = MKCoordinateRegion(center: userLocation,
                                                      latitudinalMeters: regionRadius,
                                                      longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }

        restaurants = model.restaurants

        bringSubviewToFront(ctaButon)
    }

    func datasourceDidChange() {
        listView.reloadData()
        mapView.removeAnnotations(mapView.annotations)

        var mapRect: MKMapRect = .null
        var annotations: [MKPointAnnotation] = []
        for restaraunt in restaurants {
            let annotation = MKPointAnnotation()
            annotation.title = restaraunt.name
            annotation.coordinate = restaraunt.coordinate
            annotations.append(annotation)
        }

        annotations.forEach {
            let annotationPoint = MKMapPoint($0.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x,
                                      y: annotationPoint.y,
                                      width: .zero,
                                      height: .zero)
            mapRect = mapRect.union(pointRect)
        }

        mapView.addAnnotations(annotations)
        mapView.setVisibleMapRect(mapRect, animated: true)
    }
}

// MARK: - Accessibility Identifiers

extension RestaurantResultsContainerRootView {
    func setupAccessibility() {
        mapView.accessibilityIdentifier = "mapView"
        listView.accessibilityIdentifier = "listView"
        searchBar.accessibilityIdentifier = "searchBar"
    }
}

// MARK: - Model

extension RestaurantResultsContainerRootView {

    struct Model {
        let displayType: DisplayType
        let restaurants: [Restaurant]
    }
}
