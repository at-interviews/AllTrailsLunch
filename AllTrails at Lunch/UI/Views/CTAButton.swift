import UIKit

protocol CTAButtonDelegate: AnyObject {
    func didTapCTAButton()
}

class CTAButton: BaseView {

    private enum Constants {
        static let intrinsicHeight: CGFloat = 48.0
        static let shadowRadius: CGFloat = 4.0
        static let shadowOpacity: Float = 0.25
        static let shadowOffset: CGSize = CGSize(width: .zero, height: 4.0)
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let imageLeadingInset: CGFloat = 24.0
        static let titleLeadingInset: CGFloat = 8.0
        static let titleTrailingInset: CGFloat = 24.0
        static let imageSize: CGFloat = 24.0
    }

    private let imageView: UIImageView = {
        let iv = UIImageView.autolayout()
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .pureWhite
        return iv
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel.autolayout()
        lbl.textColor = .pureWhite
        return lbl
    }()

    weak var delegate: CTAButtonDelegate?
    private var tapGR: UITapGestureRecognizer = UITapGestureRecognizer()

    init(delegate: CTAButtonDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration

extension CTAButton {

    override func configureView() {
        layer.shadowColor = Constants.shadowColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOpacity = Constants.shadowOpacity
        layer.cornerRadius = Constants.intrinsicHeight / 2.0

        backgroundColor = .ctaButtonBackground

        tapGR.addTarget(self, action: #selector(didTapButton))
        addGestureRecognizer(tapGR)
    }
}

// MARK: - Construction

extension CTAButton {

    override func constructSubviewHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
    }

    override func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Constants.intrinsicHeight)
        ])

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.imageLeadingInset),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize)
        ])

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.titleLeadingInset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.titleTrailingInset),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - Populate

extension CTAButton {

    func populate(using model: Model) {
        titleLabel.text = model.style.title
        imageView.image = model.style.iconImage
    }

    @objc
    private func didTapButton() {
        delegate?.didTapCTAButton()
    }
}

// MARK: - Model

extension CTAButton {

    enum Style {
        case list
        case map

        var iconImage: UIImage {
            switch self {
            case .list: .list
            case .map:  .map.withTintColor(.pureWhite)
            }
        }

        var title: String {
            switch self {
            case .list:
                "List".localizedCapitalized
            case .map:
                "Map".localizedCapitalized
            }
        }
    }

    struct Model {
        let style: Style

        init(_ style: Style) {
            self.style = style
        }
    }
}
