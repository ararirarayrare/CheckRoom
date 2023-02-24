import UIKit

class ItemsCollectionView: UICollectionView {
    
   private(set) var selectedIndex: Int = 0
    
    var selectedItem: Wear! {
        return items.isEmpty ? nil : items[selectedIndex]
    }
    
    enum ItemsAligment {
        case top, bottom
    }
    
    var itemsAligment: ItemsAligment = .top
    
    var itemSize: CGSize {
        get {
            return (collectionViewLayout as? ItemsCollectionViewLayout)?.itemSize ?? .zero
        }
        
        set {
            (collectionViewLayout as? ItemsCollectionViewLayout)?.itemSize = newValue
        }
    }
    
    var spacing: CGFloat {
        get {
            return (collectionViewLayout as? ItemsCollectionViewLayout)?.spacing ?? 0
        }
        
        set {
            (collectionViewLayout as? ItemsCollectionViewLayout)?.spacing = newValue
        }
    }
    
    var possibleHeightDelta: CGFloat = 16.0
    
    let items: [Wear]
    
    init(items: [Wear]) {
        self.items = items
        
        let layout = ItemsCollectionViewLayout()
        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: frame.width * 0.75,
//                                 height: frame.height)
        
        layout.spacing = 0
        
        super.init(frame: .zero, collectionViewLayout: layout)
                
        contentInset = .zero
        
        clipsToBounds = false

        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        delegate = self
        dataSource = self
        
        backgroundColor = .clear
        
        let cellClass = COItemsCollectionViewCell.self
        let identifier = String(describing: cellClass)
        
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
//    init(items: [Wear], frame: CGRect) {
//        self.items = items
//
//        let layout = ItemsCollectionViewLayout()
//        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: frame.width * 0.75,
//                                 height: frame.height)
//
//        layout.spacing = 0
//
//        super.init(frame: frame, collectionViewLayout: layout)
//
//        contentInset = .zero
//
//        clipsToBounds = false
//
//        showsVerticalScrollIndicator = false
//        showsHorizontalScrollIndicator = false
//
//        delegate = self
//        dataSource = self
//
//        let cellClass = COItemsCollectionViewCell.self
//        let identifier = String(describing: cellClass)
//
//        register(cellClass, forCellWithReuseIdentifier: identifier)
//    }
    
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
        cell.itemsAligment = self.itemsAligment
        
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
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    fileprivate var itemsAligment: ItemsCollectionView.ItemsAligment = .top
    fileprivate var possibleHeightDelta: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
//        contentView.backgroundColor = .yellow.withAlphaComponent(0.5)
//        imageView.backgroundColor = .blue.withAlphaComponent(0.5)

        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        guard true == false else {
//            imageView.frame = contentView.bounds
//            return
//        }
        
        guard let imageSize = imageView.image?.size, contentView.bounds != .zero else {
            return
        }
        
        let bounds = contentView.bounds
        
        // width / height
        let aspectRatio = imageSize.width / imageSize.height
    
        let newWidth = bounds.width
        
        let newHeight = newWidth / aspectRatio
                
        if (newHeight - bounds.height) > possibleHeightDelta {
            
            let newHeight = bounds.height + possibleHeightDelta
            let newWidth = newHeight * aspectRatio
            
            let newSize = CGSize(width: newWidth, height: newHeight)
//            let newImage = imageView.image?.resize(to: newSize, with: .accelerate)
            
//            imageView.image = newImage
            imageView.frame.size = newSize
            
            imageView.center = contentView.center
            imageView.frame.origin.y = -(possibleHeightDelta / 2)
            
        } else {
            
            let newSize = CGSize(width: newWidth, height: newHeight)
//            let newImage = imageView.image?.resize(to: newSize, with: .accelerate)
//
//            imageView.image = newImage
            imageView.frame.size = newSize
            
            imageView.center.x = contentView.center.x
            
            switch itemsAligment {
            case .top:
                imageView.frame.origin.y = 0
            case .bottom:
                imageView.frame.origin.y = (bounds.height - newSize.height)
            }
        }
    
    }
    
    private func layout() {
        addSubview(imageView)
    }
    
}
