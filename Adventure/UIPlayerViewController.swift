//
//  UIPlayerViewController.swift
//  Adventure
//
//  Created by Eric on 16/10/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

//点击人物血量按钮后出现的状态面板，包括人物属性、技能、物品等
class UIPlayerViewController: UIViewController {
    
    var playerView = UIPlayerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.clipsToBounds = true
        view.addSubview(playerView)
        // Do any additional setup after loading the view.
        modalPresentationStyle = .overFullScreen
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playerView.fillSuperview()
        playerView.refresh()
    }
}
