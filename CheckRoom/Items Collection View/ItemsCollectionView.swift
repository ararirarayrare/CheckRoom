import UIKit

class ItemsCollectionView: UICollectionView {
    
   private(set) var selectedIndex: Int = 0
    
    var selectedItem: Wear! {
        return items.isEmpty ? nil : items[selectedIndex]
    }
    
    let items: [Wear]
    
    init(items: [Wear], frame: CGRect) {
        self.items = items
        
        let layout = ItemsCollectionViewLayout()
        layout.scrollDirection = .horizontal        
        layout.itemSize = CGSize(width: frame.width * 0.75,
                                 height: frame.height)
        
        layout.spacing = 0
        
        super.init(frame: frame, collectionViewLayout: layout)
                
        contentInset = .zero
        
        clipsToBounds = false

        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        delegate = self
        dataSource = self
        
        let cellClass = COItemsCollectionViewCell.self
        let identifier = String(describing: cellClass)
        
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func scrollTo(index: Int) {
        self.scrollToItem(at: IndexPath(item: index, section: 0),
                          at: [.centeredVertically, .centeredHorizontally],
                          animated: true)
        self.selectedIndex = index
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ItemsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = String(describing: COItemsCollectionViewCell.self)
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? COItemsCollectionViewCell else {
            return COItemsCollectionViewCell()
        }
        
        cell.imageView.image = items[indexPath.item].image
        
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let cell = visibleCells.first(where: { $0.alpha > 0.99 }),
           let index = indexPath(for: cell)?.item {
            
            selectedIndex = index
        }
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 0, left: bounds.width / 4, bottom: 0, right: 0)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: bounds.width * 0.5,
//                      height: bounds.height)
//    }
}

class COItemsCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
        backgroundColor = .blue.withAlphaComponent(0.5)

        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
