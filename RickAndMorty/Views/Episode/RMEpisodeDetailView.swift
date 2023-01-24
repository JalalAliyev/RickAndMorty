import UIKit

protocol RMEpisodeDetailViewDelegate: AnyObject {
    func rmEmpisodeDetailView(
        _ detailView: RMEpisodeDetailView,
        selectedCharacter: RMCharacter
    )
}

final class RMEpisodeDetailView: UIView {
    public weak var delegate: RMEpisodeDetailViewDelegate?
    private var viewModel: RMEpisodeDetailViewModel? {
        didSet {
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.4) {
                self.collectionView?.alpha = 1
            }
        }
    }
    
    // MARK: UI widgets
    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .systemRed
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.backgroundColor = .tertiarySystemBackground
        spinner.layer.cornerRadius = 10
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("RMEpisodeDetailView has not been implemented")
    }
    
    // MARK: Public func
    
    public func configure(with viewModel: RMEpisodeDetailViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: Private func

extension RMEpisodeDetailView {
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            RMEpisodeInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.identifier
        )
        collectionView.register(
            RMCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifier
        )
        
        return collectionView
        
    }
    
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else {
            return createInfoLayout()
        }
        switch sections[section] {
        case .info:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
        }
    }
    
    private func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(100)
            ), subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1.0)
                )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 2,
            bottom: 2,
            trailing: 2
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(250)
                ),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 15,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        return section
    }
    
    private func configureSubviews() {
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        configureConstraints()
        spinner.startAnimating()
    }
    
    private func configureConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension RMEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else {return 0}
        let sectionType = sections[section]
        switch sectionType {
        case .characters(let viewModels):
            return viewModels.count
        case .info(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.cellViewModels, let collectionView = self.collectionView else {
            fatalError("No viewModels or collectionView")
        }
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .info(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeInfoCollectionViewCell.identifier,
                for: indexPath
            ) as? RMEpisodeInfoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        case .characters(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.identifier,
                for: indexPath
            ) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else {
            return
        }
        let cellViewModels = viewModel.cellViewModels
        let sectionType = cellViewModels[indexPath.section]
        switch sectionType {
        case .info:
            break
        case .characters:
            guard let character = viewModel.character(at: indexPath.row) else {return}
            delegate?.rmEmpisodeDetailView(self, selectedCharacter: character)
        }
    }
}
