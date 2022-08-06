//
//  ViewController.swift
//  PHPickerController
//
//  Created by 김정은 on 2022/08/06.
//
import PhotosUI
import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    //image - UIImage 타입
    var imageArray = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //layout
        collectionView.collectionViewLayout = layout()
    }
    private func layout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 2
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalWidth(0.33))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
        let groupLayout = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: itemLayout, count:   3)
        groupLayout.interItemSpacing = .fixed(spacing)
        
        // Section
        let section = NSCollectionLayoutSection(group: groupLayout)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }

    //button을 누르면 ImageView로 사진앱에 저장된 사진 가져오기
    @IBAction func addPhotoButtonTapped(_ sender: UIBarButtonItem) {
        var config = PHPickerConfiguration()
        //선택 가능한 image 갯수
        config.selectionLimit = 3
        let phPickerVC = PHPickerViewController(configuration : config)
        phPickerVC.delegate = self
        self.present(phPickerVC ,animated:  true )
    }
    
}

extension PhotoViewController : PHPickerViewControllerDelegate{
    //이미지 선택 후 add 누루면 collectionView의 Cell인 imageView에 나타나는 함수
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true )
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error  in
                if let image = object as? UIImage{
                    //image UIImage 타입
                   // print (image)
                    //image-UIImage타입이면 imageArray에 추가
                    self.imageArray.append(image)
                }
                //이미지 선택 완료 후
                //main thread에서 작동
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
//presentation
extension PhotoViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.phtoImageView.image = imageArray[indexPath.row]
        return cell
    }
    
    
}

