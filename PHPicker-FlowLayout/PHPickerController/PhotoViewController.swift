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
//layout
extension PhotoViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let interItemSpacing: CGFloat = 2
        let padding: CGFloat = 16
        let width = (collectionView.bounds.width - interItemSpacing * 2) / 3
        let height = (collectionView.frame.size.height - padding * 2) / 5
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
