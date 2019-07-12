//
//  MainViewController.swift
//  TetrisPoint1
//
//  Created by Trung Le on 6/24/19.
//  Copyright © 2019 Trung Le. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let gameView = GameView(frame: CGRect.zero)
    let topHeight: CGFloat = UIScreen.main.bounds.height < 812 ? 20 : 44
    
    var sound = SoundManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        gameView.frame = CGRect(x: 0.0, y: topHeight, width: self.view.frame.width, height: self.view.frame.height - topHeight - 34)
        self.view.addSubview(gameView)
//        self.sound.playBGM()

    }

}
