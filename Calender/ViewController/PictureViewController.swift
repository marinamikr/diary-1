//
//  PictureViewController.swift
//  Calender
//
//  Created by Hazuki♪ on 2018/04/14.
//  Copyright © 2018年 hazuki. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {
    
      var userDefaults:UserDefaults = UserDefaults.standard
    
      var selectedPicture : UIImage!
   
    @IBOutlet weak var photo: UIImageView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
         photo.image = selectedPicture
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 1 {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
