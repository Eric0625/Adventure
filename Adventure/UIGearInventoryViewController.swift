//
//  UIGearInventoryViewController.swift
//  Adventure
//
//  Created by 苑青 on 16/7/29.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

class UIGearInventoryViewController: UIViewController {

    var mainView = UIGearInventoryView()
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.clipsToBounds = true
        view.addSubview(mainView)
        // Do any additional setup after loading the view.
        modalPresentationStyle = .OverFullScreen
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.fillSuperview()
        mainView.refresh()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func returnButtonPressed(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
