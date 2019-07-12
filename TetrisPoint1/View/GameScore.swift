//
//  GameScore.swift
//  TetrisPoint1
//
//  Created by Trung Le on 6/27/19.
//  Copyright © 2019 Trung Le. All rights reserved.
//

import UIKit

class GameScore: UIView {
    
    static var levelLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    static var linesLable: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    static var scoreLable: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    static let playButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.setTitle("Play", for: UIControl.State())
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        layoutGameScore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutGameScore(){
        // level
        GameScore.levelLabel.translatesAutoresizingMaskIntoConstraints = false
        GameScore.levelLabel.textColor = UIColor.white
        GameScore.levelLabel.text = "Level: \(GameScore.levelLabel.text!) " //self.gameLevel
        GameScore.levelLabel.adjustsFontSizeToFitWidth = true
        GameScore.levelLabel.minimumScaleFactor = 1.0
        GameScore.levelLabel.textAlignment = .center
        GameScore.levelLabel.font = .boldSystemFont(ofSize: 20)
        self.addSubview(GameScore.levelLabel)
        
        GameScore.levelLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        GameScore.levelLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:-25).isActive = true
        
        // lines
        GameScore.linesLable.translatesAutoresizingMaskIntoConstraints = false
        GameScore.linesLable.textColor = UIColor.white
        GameScore.linesLable.text = "Lines: \(GameScore.linesLable.text!) " //self.gameLevel
        GameScore.linesLable.adjustsFontSizeToFitWidth = true
        GameScore.linesLable.minimumScaleFactor = 1.0
        GameScore.linesLable.textAlignment = .center
        GameScore.linesLable.font = .boldSystemFont(ofSize: 20)
        self.addSubview(GameScore.linesLable)
        
        GameScore.linesLable.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -30).isActive = true
        GameScore.linesLable.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:-25).isActive = true
        
        //Score
        GameScore.scoreLable.translatesAutoresizingMaskIntoConstraints = false
        GameScore.scoreLable.textColor = UIColor.white
        GameScore.scoreLable.text = "Score: \(GameScore.scoreLable.text!) " //self.gameLevel
        GameScore.scoreLable.adjustsFontSizeToFitWidth = true
        GameScore.scoreLable.minimumScaleFactor = 1.0
        GameScore.scoreLable.textAlignment = .center
        GameScore.scoreLable.font = .boldSystemFont(ofSize: 20)
        
        self.addSubview(GameScore.scoreLable)
        
        GameScore.scoreLable.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 100).isActive = true
        GameScore.scoreLable.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:-25).isActive = true
        
        // Botton Play Pause
        self.addSubview(GameScore.playButton)
        GameScore.playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -10).isActive = true
        GameScore.playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:20).isActive = true
        GameScore.playButton.widthAnchor.constraint(equalToConstant: 120  ).isActive = true
        GameScore.playButton.heightAnchor.constraint(equalToConstant: 40 ).isActive = true
//        GameScore.playButton.setTitleColor(.red, for: .normal)
    }
    @objc func playAction(sender: UIButton!) {
        GameBroad.isPlay = !GameBroad.isPlay
        if GameBroad.isPlay == false{
            GameScore.playButton.setTitle("Play", for: .normal)
        }else{
            GameScore.playButton.setTitle("Pause", for: .normal)
        }
        
        
    }
    
}
