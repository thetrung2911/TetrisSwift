//
//  GameView.swift
//  TetrisPoint1
//
//  Created by Trung Le on 6/24/19.
//  Copyright © 2019 Trung Le. All rights reserved.
//

import UIKit

class GameView: UIView {
    let gameScore = GameScore(frame: CGRect.zero)
    let gameBroad = GameBroad(frame: CGRect.zero)
    let gameover = UIImageView(image: UIImage(named: "gameover"))
    
    var topHeight: CGFloat = 0
    var margin: CGFloat = 8.0
    
    var soundManager = SoundManager()
    static var isOver = false
    
    // timer
    static var timeGV = Timer()
    static var times: Double = 0.4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topHeight = UIScreen.main.bounds.height < 812 ? 20 : 44
        self.backgroundColor = .black
        gameStart()
        
    }
    func gameStart(){
        setupLayout()
        soundManager.bombSoundEffect?.stop()
        GameView.isOver = false
        gameBroad.gameStart()
        // timeGV dùng để xác định lúc gameOver
        GameView.timeGV = Timer.scheduledTimer(timeInterval: GameView.times, target:self, selector: #selector(gameOver), userInfo: nil, repeats: true)
        
    }

     @objc func gameOver(){
        
        if GameBroad.isPlay == true{
            if GameView.isOver{
                gameBroad.soundManager.bombSoundEffect?.stop()
                GameBroad.time.invalidate()
                GameView.timeGV.invalidate()
                
                soundManager.gameOver()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.gameBroad.removeFromSuperview()
                    self.gameScore.removeFromSuperview()
                    self.gameover.isHidden = false
                    UIView.animate(withDuration: 2, animations: {
                        self.gameover.center = self.center
                        let reset = UITapGestureRecognizer(target: self, action: #selector(self.reset(gesture:)))
                        self.gameover.addGestureRecognizer(reset)
                        self.gameover.isUserInteractionEnabled = true
                    }){ (_) in
                        
                    }
                })
            }
        }
    }
    @objc func reset(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            self.gameover.removeFromSuperview()
            self.gameBroad.clear()
            gameStart()
        }
    }
    
    
    func setupLayout(){
        
        // tạo gameBroad
        self.addSubview(gameBroad)
        
        gameBroad.translatesAutoresizingMaskIntoConstraints = false
        gameBroad.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        gameBroad.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -margin).isActive = true
        gameBroad.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0 ).isActive = true
        gameBroad.topAnchor.constraint(equalTo: self.bottomAnchor, constant:-CGFloat((GameBroad.rows + 1) * GameBroad.margin + GameBroad.rows * GameBroad.brickSize)).isActive = true
        
        // tạo gameScore
        self.addSubview(gameScore)
        
        gameScore.translatesAutoresizingMaskIntoConstraints = false
        gameScore.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        gameScore.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        gameScore.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -margin).isActive = true
        gameScore.bottomAnchor.constraint(equalTo: self.gameBroad.topAnchor, constant: -margin ).isActive = true
        
        // tạo ảnh gameover
        self.addSubview(self.gameover)
        self.gameover.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height + 34 + self.gameover.bounds.height * 0.5)
        self.gameover.isHidden = true
        
        
    }
    public func clear(){
        self.removeFromSuperview()
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
