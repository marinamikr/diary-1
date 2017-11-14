//
//  changeController.swift
//  Calender
//
//  Created by Hazuki♪ on 2017/08/05.
//  Copyright © 2017年 hazuki. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
//import FirebaseDatabase
//import FirebaseStorage
import SVProgressHUD

class changeController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    
    var saveNumber = UserDefaults.standard
    
    @IBOutlet var showpic: UIImageView!
    
    @IBOutlet weak var getCollectionView: UICollectionView!
    var refreshControl:UIRefreshControl!
    var images: [UIImage] = []
    
    @IBOutlet var batsubtn: UIButton!
    @IBAction func bakku() {
        showpic.image = nil
        getCollectionView.isHidden = false
        
        if showpic.image != nil{
            // 部品を消したいとき
            batsubtn.isHidden = true
            //
        }else{  // 消した部品を出す
            batsubtn.isHidden = false
        }
    }
    //   var diaryPicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCollectionView.dataSource = self
        getCollectionView.delegate = self
        getCollectionView.register(UINib(nibName: "CollectionChangeCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        batsubtn.isHidden = true
        
        SVProgressHUD.show()
        
        /*
        // databaseから画像の名前を取得
        let ref = Database.database().reference().child("photo")
        ref.observe(DataEventType.value, with: { snapshot in
            let postDict = snapshot.value as! [String : AnyObject]
            var names: [String] = []
            var count = 0
            for (_, value) in postDict {
                if let number = self.saveNumber.object(forKey: "SAVE") as? Int {
                    if count == number {
                        break
                    }
                } else {
                    print("ダメでした")
                    break
                }
                print("きたきた")
                SVProgressHUD.dismiss()
                count += 1
                if let name = value as? String {
                    names.append(name)
                }
            }
            self.download(names: names)
        })
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(changeController.refresh), for: UIControlEvents.valueChanged)
        //self.getCollectionView.addSubview(refreshControl)
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        
        
        // databaseから画像の名前を取得
        let ref = Database.database().reference().child("photo")
        ref.observe(DataEventType.value, with: { snapshot in
            let postDict = snapshot.value as! [String : AnyObject]
            var names: [String] = []
            var count = 0
            for (_, value) in postDict {
                if let number = self.saveNumber.object(forKey: "SAVE") as? Int {
                    if count == number {
                        break
                    }
                } else {
                    print("ダメでした")
                    break
                }
                print("きたきた")
                SVProgressHUD.dismiss()
                count += 1
                if let name = value as? String {
                    names.append(name)
                }
                
                
            }
            self.download(names: names)
        })
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(changeController.refresh), for: UIControlEvents.valueChanged)
    }
    
    func refresh() {
        images.removeAll()
        getCollectionView.reloadData()
        
    }
    
    func download(names: [String]) {
        // 画像ダウンロード
        print("画像きた")
        images.removeAll()
        // collection viewに表示
        var newImage: [UIImage] = []
        for name in names {
            
            print(name)
            
            print("画像きたよ")
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
            //storageRefのかくにん
            print(storageRef)
            
            storageRef.child(name).getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print("Uh-oh, an error occurred!")
                } else {
                    self.images.append(UIImage(data: data!)!)
                    self.getCollectionView.reloadData()
                }
            }
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for:
            indexPath) as! CollectionChangeCell
        cell.imgSample.image = images[indexPath.row]
        return cell
    }
    
    
    // 表示するセルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showpic.image = images[indexPath.row]
        
        batsubtn.isHidden = false
        
        getCollectionView.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    // Dispose of any resources that can be recreated.
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}



