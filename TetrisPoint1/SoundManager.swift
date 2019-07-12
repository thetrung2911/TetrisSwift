//
//  SoundManager.swift
//  TetrisPoint1
//
//  Created by Trung Le on 6/28/19.
//  Copyright © 2019 Trung Le. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager {
    var bombSoundEffect: AVAudioPlayer?
    
    func playSound(_ sound: String){
        
        let path = Bundle.main.path(forResource: sound, ofType: nil)
        let url = URL(fileURLWithPath: path!)
        
        do {
            
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
            
        } catch {
            print("couldn't load file")
        }
        
    }
    
    func dropBrick(){
        playSound("bomb.mp3")
    }
    func original(){
        playSound("tetris_original.mp3")
        bombSoundEffect?.numberOfLoops = -1
    }
    func gameOver(){
        playSound("gameover.mp3")
    }
    
    func levelup(){
        playSound("levelup.mp3")
    }

    
}
