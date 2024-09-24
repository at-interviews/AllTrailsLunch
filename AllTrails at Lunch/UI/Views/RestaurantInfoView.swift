import UIKit

class RestaurantInfoView: BaseView {

    private enum Constants {
        static let horizontalContentInsets: CGFloat = 16.0
        static let verticalContentInsets: CGFloat = 16.0
        static let horizontalContentSpace: CGFloat = 16.0
        static let verticalContentSpace: CGFloat = 4.0
        static let horizontalRatingsContentSpace: CGFloat = 8.0
        static let contentCornerRadius: CGFloat = 16.0
        static let defaultRating: Double = .zero
        static let defaultReviewCount: Int = .zero
        static let bulletString: String = "•"
        static let previewImageHeight: CGFloat = 76.0
        static let previewImageWidth: CGFloat = 64.0
        static let ratingsStarImageSize: CGFloat = 16.0
        static let savedImageSize: CGFloat = 24.0
        static let supportTextFontSize: CGFloat = 12.0
        static let shadowOpacity: Float = 0.2
        static let shadowOffsetWidth: CGFloat = .zero
        static let shadowOffsetHeight: CGFloat = -1.0
        static let shadowRadius: CGFloat = 8.0
    }

    private let placeholderImage: UIImage = .placeholder
    private let previewImageView: UIImageView = UIImageView.autolayout()
    private let infoTitleLabel: UILabel = UILabel.autolayout()
    private let infoRatingDecimalLabel: UILabel = UILabel.autolayout()
    private let ratingsStarImageView: UIImageView = UIImageView.autolayout()
    private let bulletLabel: UILabel = UILabel.autolayout()
    private let numberOfReviewsLabel: UILabel = UILabel.autolayout()
    private let supportTextLabel: UILabel = UILabel.autolayout()
    private let savedImageView: UIImageView = UIImageView.autolayout()

    private let contentContainer: UIView = {
        let cc = UIView.autolayout()
        cc.layer.cornerRadius = Constants.contentCornerRadius
        cc.backgroundColor = .pureWhite
        cc.layer.shadowColor = UIColor.black.cgColor
        cc.layer.shadowOpacity = Constants.shadowOpacity
        cc.layer.shadowOffset = CGSize(width: Constants.shadowOffsetWidth, height: Constants.shadowOffsetHeight)
        cc.layer.shadowRadius = Constants.shadowRadius
        return cc
    }()

    private let horizontalStackView: UIStackView = {
        let sv = UIStackView.autolayout()
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.alignment = .top
        sv.spacing = Constants.horizontalContentSpace
        return sv
    }()

    private let verticalInfoStackView: UIStackView = {
        let sv = UIStackView.autolayout()
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.alignment = .leading
        sv.spacing = Constants.verticalContentSpace
        return sv
    }()

    private let horizontalRatingsAndReviewsStackView: UIStackView = {
        let sv = UIStackView.autolayout()
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.alignment = .center
        sv.spacing = Constants.horizontalRatingsContentSpace
        return sv
    }()
}

// MARK: - Configuration

extension RestaurantInfoView {

    override func configureView() {
        backgroundColor = .backgroundLight
    }

    override func configureSubviews() {
        configurePreviewImageView()
        configureLabels()
        configureSavedImageView()
    }

    private func configurePreviewImageView() {
        previewImageView.image = placeholderImage
        previewImageView.contentMode = .scaleAspectFit
    }

    private func configureLabels() {
        ratingsStarImageView.image = .star
        ratingsStarImageView.contentMode = .scaleAspectFit

        infoRatingDecimalLabel.text = "\(Constants.defaultRating)"
        bulletLabel.text = Constants.bulletString
        numberOfReviewsLabel.text = "(\(Constants.defaultReviewCount))"

        supportTextLabel.text = ""
        supportTextLabel.lineBreakMode = .byTruncatingTail
        supportTextLabel.numberOfLines = 2
        supportTextLabel.font = .systemFont(ofSize: Constants.supportTextFontSize, weight: .light)
    }

    private func configureSavedImageView() {
        savedImageView.image = .bookmarkSaved
        savedImageView.contentMode = .scaleAspectFit
    }
}

// MARK: - Construction

extension RestaurantInfoView {

    override func constructSubviewHierarchy() {
        addSubview(contentContainer)
        contentContainer.addSubview(horizontalStackView)

        horizontalStackView.addArrangedSubview(previewImageView)
        horizontalStackView.addArrangedSubview(verticalInfoStackView)
        horizontalStackView.addArrangedSubview(savedImageView)

        verticalInfoStackView.addArrangedSubview(infoTitleLabel)
        verticalInfoStackView.addArrangedSubview(horizontalRatingsAndReviewsStackView)
        verticalInfoStackView.addArrangedSubview(supportTextLabel)

        horizontalRatingsAndReviewsStackView.addArrangedSubview(ratingsStarImageView)
        horizontalRatingsAndReviewsStackView.addArrangedSubview(infoRatingDecimalLabel)
        horizontalRatingsAndReviewsStackView.addArrangedSubview(bulletLabel)
        horizontalRatingsAndReviewsStackView.addArrangedSubview(numberOfReviewsLabel)
    }

    override func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalContentInsets),
            contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalContentInsets),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalContentInsets),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalContentInsets)
        ])

        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: Constants.horizontalContentInsets),
            horizontalStackView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: Constants.verticalContentInsets),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -Constants.horizontalContentInsets),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -Constants.verticalContentInsets)
        ])

        NSLayoutConstraint.activate([
            previewImageView.heightAnchor.constraint(equalToConstant: Constants.previewImageHeight),
            previewImageView.widthAnchor.constraint(equalToConstant: Constants.previewImageWidth)
        ])

        NSLayoutConstraint.activate([
            ratingsStarImageView.heightAnchor.constraint(equalToConstant: Constants.ratingsStarImageSize),
            ratingsStarImageView.widthAnchor.constraint(equalToConstant: Constants.ratingsStarImageSize)
        ])

        NSLayoutConstraint.activate([
            savedImageView.heightAnchor.constraint(equalToConstant: Constants.savedImageSize),
            savedImageView.widthAnchor.constraint(equalToConstant: Constants.savedImageSize)
        ])
    }
}

// MARK: - Populate

extension RestaurantInfoView {

    struct Model {
        let imageURLString: String?
        let title: String
        let ratingDecimal: Float
        let numberOfReviews: Int
        let supportingInfo: String?
        let saved: Bool

        init(_ title: String,
             imageURLString: String? = nil,
             ratingDecimal: Float,
             numberOfReviews: Int,
             supportingInfo: String? = nil,
             saved: Bool = false) {

            self.imageURLString = imageURLString
            self.title = title
            self.ratingDecimal = ratingDecimal
            self.numberOfReviews = numberOfReviews
            self.supportingInfo = supportingInfo
            self.saved = saved
        }

        init(_ restaurant: Restaurant, saved: Bool = false) {
            self.imageURLString = restaurant.iconImageURL
            self.title = restaurant.name
            self.ratingDecimal = restaurant.rating
            self.numberOfReviews = restaurant.numberOfReviews
            self.supportingInfo = restaurant.summary
            self.saved = saved
        }
    }

    func populate(_ model: Model) {
        previewImageView.setImage(from: model.imageURLString, placeholder: placeholderImage)
        infoTitleLabel.text = model.title
        infoRatingDecimalLabel.text = String(format: "%.1f", model.ratingDecimal)
        numberOfReviewsLabel.text = "(\(model.numberOfReviews))"
        supportTextLabel.text = model.supportingInfo ?? ""
        savedImageView.image = model.saved ? .bookmarkSaved : .bookmarkResting
    }
}
