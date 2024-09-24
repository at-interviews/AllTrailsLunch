import UIKit

class RestaurantInfoTableViewCell: BaseTableViewCell {
    private let infoView: RestaurantInfoView = RestaurantInfoView.autolayout()
}

// MARK: - Construction

extension RestaurantInfoTableViewCell {
    override func constructSubviewHierarchy() {
        contentView.addSubview(infoView)
    }

    override func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: - Populate

extension RestaurantInfoTableViewCell {
    func populate(_ model: RestaurantInfoView.Model) {
        infoView.populate(model)
    }
}
