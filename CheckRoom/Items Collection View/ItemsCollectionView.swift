import UIKit
import Combine

class ItemsCollectionView: UICollectionView {
    
    @Published
    private(set) var isScrolling: Bool = false
    
    private(set) var selectedIndex: Int = 0
    
    var selectedItem: Wear! {
//        return items.isEmpty ? nil : items[selectedIndex]
        let wear = (visibleCells.first(where: { $0.alpha > 0.6 }) as? ItemsCollectionViewCell)?.wear
        return wear
//        return items.first(where: { $0.image?.pngData() == image?.pngData() }) ?? items[selectedIndex]
    }
    
    enum ItemsAligment {
        case top, bottom, center
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
    
    private(set) var items: [Wear]
    
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
        
        let cellClass = ItemsCollectionViewCell.self
        let identifier = String(describing: cellClass)
        
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func scrollTo(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        
        scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        self.selectedIndex = index
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let cell = visibleCells.first(where: { $0.alpha > 0.99 }),
           let index = indexPath(for: cell)?.item {
            
            selectedIndex = index
            
            isScrolling = false
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !isScrolling { isScrolling = true }
    }
    
    override func deleteItems(at indexPaths: [IndexPath]) {
        indexPaths.forEach { self.items.remove(at: $0.item) }
        
        super.deleteItems(at: indexPaths)
        
        reloadData()
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
        
        let identifier = String(describing: ItemsCollectionViewCell.self)
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ItemsCollectionViewCell else {
            return ItemsCollectionViewCell()
        }
        
        cell.imageView.image = items[indexPath.item].image
        cell.itemsAligment = self.itemsAligment
        cell.wear = items[indexPath.item]
        
        return cell
    }

}

class ItemsCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    fileprivate(set) var wear: Wear!
    
    fileprivate var itemsAligment: ItemsCollectionView.ItemsAligment = .top
    fileprivate var possibleHeightDelta: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
        contentView.backgroundColor = .yellow.withAlphaComponent(0.5)
//        imageView.backgroundColor = .blue.withAlphaComponent(0.5)

        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
            case .center:
                imageView.center.y = bounds.midY
            }
        }
    
    }
    
    private func layout() {
        contentView.addSubview(imageView)
    }
    
}
