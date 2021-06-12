//
//  ViewController.swift
//  WordDemo
//
//  Created by anshul shah on 12/06/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lettersStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    var textFields     : [UITextField] = []
    var focusedIndex   : Int = 0
    var randomAlphabets: [String] = []
    
    var timer: Timer?
    var seconds = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let first = GameManager.shared.getNextLevel(){
            self.setup(first)
        }
        
    }
    
    
    private func setup(_ level: Level){
        
        self.imageView.image = nil
        if let url = level.image{
            DispatchQueue.global().async { [weak self] in
                guard let `self` = self else {return}
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                }
            }
        }
        
        self.textFields.removeAll()
        self.lettersStackView.subviews.forEach({
            $0.removeFromSuperview()
        })
        
        if let count = level.name?.count{
            for i in 0..<count{
                let textField = UITextField()
                textField.translatesAutoresizingMaskIntoConstraints = false
                textField.addConstraint(NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
                textField.addConstraint(NSLayoutConstraint(item: textField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
                textField.tag = i + 10
                textField.borderStyle = .bezel
                textField.delegate = self
                self.textFields.append(textField)
                self.lettersStackView.addArrangedSubview(textField)
            }
        }
        
        self.randomAlphabets = level.getAlphabetsArray().shuffled()
        self.collectionView.reloadData()
        
        
        self.focusedIndex = 0
        self.seconds = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
     
    @objc func updateTime(){
        seconds -= 1
        self.timeLabel.text = "\(seconds) Seconds"
        if seconds == 0{
            timer?.invalidate()
            let alert = UIAlertController.init(title: "Oh no", message: "Game over, your score is \(GameManager.shared.score)", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func checkResult(){
        if GameManager.shared.selectedLevel?.name ?? " " == self.textFields.joined(){
            if let level = GameManager.shared.getNextLevel(){
                timer?.invalidate()
                GameManager.shared.score += (seconds)
                self.scoreLabel.text = "\(GameManager.shared.score) Points"
                self.setup(level)
            }else{
                timer?.invalidate()
                let alert = UIAlertController.init(title: "Wow", message: "You have completed all the levels, your score is \(GameManager.shared.score)", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        focusedIndex = textField.tag - 10
        let filteredTextField = self.textFields.filter({$0.tag >= (focusedIndex + 10)})
        for tf in filteredTextField{
            tf.text = ""
        }
        
        return false
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.randomAlphabets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.label.text = self.randomAlphabets[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height :CGFloat = 40.0
        let width  :CGFloat = (UIScreen.main.bounds.width - 40.0 - 70.0) / 8.0
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if focusedIndex < self.textFields.count{
            if let textField = self.lettersStackView.viewWithTag(focusedIndex + 10) as? UITextField{
                textField.text = self.randomAlphabets[indexPath.row]
                focusedIndex += 1
                if focusedIndex == self.textFields.count{
                    self.checkResult()
                }
            }
        }
    }
    
}

class Cell: UICollectionViewCell{
    @IBOutlet weak var label: UILabel!
}
