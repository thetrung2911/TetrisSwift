//
//  GameBroad.swift
//  TetrisPoint1
//
//  Created by Trung Le on 6/24/19.
//  Copyright © 2019 Trung Le. All rights reserved.
//

import UIKit

class GameBroad: UIView {
    
    //Khai báo gameBroad
    static let rows = 21
    static let cols = 12
    
    // khai báo margin
    static let margin = 1
    
    // time
    static var time = Timer()
    var time1 = Timer()
    
    
    static var isPlay = false
    
    // check gameScore ăn
    var lines = 0
    var score = 0
    var level = 1
    
    //tính chiều rộng thiết bị
    static let screenw: CGFloat = UIScreen.main.bounds.size.width
    
    // Kích thước 1 ô
    static let brickSize = Int((GameBroad.screenw - 29) / 12)
    static let emptyColor = UIColor.black
    static let strockeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    
    var board = [[UIColor]]()
    var currentBrick:Brick?
    
    // âm thanh
    var soundManager = SoundManager()
    var soudDrop = SoundManager()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
    }
    
    func gameStart(){
        print("gameStart")
        level = 1
        lines = 0
        score = 0
        GameScore.levelLabel.text = "Level: \(level)"
        GameScore.linesLable.text = "Lines: \(lines)"
        GameScore.scoreLable.text = "Score: \(score)"
        GameScore.playButton.setTitle("Play", for: .normal)
        
        soundManager.bombSoundEffect?.stop()
        self.clear()
        GameView.times = 0.4
        currentBrick = Brick.newBrick()
        gameInteraction()
        self.soundManager.original()
        GameBroad.isPlay = false
        GameBroad.time = Timer.scheduledTimer(timeInterval: GameView.times, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        
    }
    @objc func gameLoop(){
        
        if GameBroad.isPlay == true{
            updataY()
            soundManager.bombSoundEffect?.play()
            GameScore.levelLabel.text = "Level: \(level)"
            GameScore.linesLable.text = "Lines: \(lines)"
            GameScore.scoreLable.text = "Score: \(score)"

        }else{
            soundManager.bombSoundEffect?.pause()
        }
    }
    
    
    func generateBrick() {
        self.currentBrick = Brick.generate()
        
    }
    func update() -> (isGameOver:Bool, droppedBrick:Bool) {
        
        guard let currentBrick = self.currentBrick else { return (false, false)  }
        
        var droppedBrick = false
        
        if self.canMoveDown(currentBrick) {
            currentBrick.moveDown()
            
        } else {
            
            droppedBrick = true
            
            for p in currentBrick.points {
                let r = Int(p.y) + currentBrick.ty
                let c = Int(p.x) + currentBrick.tx
                
                // check game over
                // can't move down and brick is out of top bound.
                if r < 0 {
                    self.setNeedsDisplay()
                    GameView.isOver = true
                    GameBroad.time.invalidate()
                    return (true, false)
                    
                }
                self.board[r][c] = currentBrick.color
            }
            // clear lines
            self.lineClear()
            self.generateBrick()
        }
        self.setNeedsDisplay()
        
        return (false, droppedBrick)
    }
    // xoá dòng
    func lineClear() {
        var lineCount = 0
        var linesToRemove = [Int]()
        
        for i in 0..<self.board.count {
            let row = self.board[i]
            let rows = row.filter { c -> Bool in
                return c != GameBroad.emptyColor
            }
            if rows.count == GameBroad.cols {
                linesToRemove.append(i)
                lineCount += 1
                
                // tính lines
                lines += 1
            }
            
        }
        // tính điểm
        if lineCount == 1 {
            score += 100
        }else if lineCount == 2 {
            score += 300
        }else if lineCount == 3 {
            score += 600
        }else if lineCount == 4 {
            score += 1000
        }
        // điều kiện tăng level
        if score > 20000{
            gameLever(6, 0.16)
        }else if score > 10000{
            gameLever(5, 0.23)
        }else if score > 6000 {
            gameLever(4, 0.28)
        }else if score > 3000 {
            gameLever(3, 0.32)
        }else if score > 1500 {
            gameLever(2, 0.35)
        }
        
        for line in linesToRemove {
            self.board.remove(at: line)
            self.board.insert(self.generateRow(), at: 0)
            self.soudDrop.levelup()
        }
        
    }
    func gameLever(_ levelGame: Int,_ time: Double){
        level = levelGame
        GameView.times = time
        GameBroad.time.invalidate()
        GameBroad.time = Timer.scheduledTimer(timeInterval: GameView.times, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        
    }
    func canMoveDown(_ brick:Brick) -> Bool {
        for p in brick.points {
            let r = Int(p.y) + brick.ty + 1
            
            // not visible brick points
            if r < 0 {
                continue
            }
            
            if r >= GameBroad.rows {
                return false
            }
            let c = Int(p.x) + brick.tx
            if self.board[r][c] !=  GameBroad.emptyColor {
                return false
            }
        }
        return true
    }
    func gameInteraction(){
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeUp.direction = .up
        self.addGestureRecognizer(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeDown.direction = .down
        self.addGestureRecognizer(swipeDown)
        
    }
    
    @objc func swiped(gesture: UISwipeGestureRecognizer){
        if GameBroad.isPlay == true{
            if let swipeGesture = gesture as? UISwipeGestureRecognizer{
                switch swipeGesture.direction{
                case .up:
                    rotateBrick()
                case .left:
                    updateX(-1)
                case .right:
                    updateX(1)
                case .down:
                    upDown()
                default:
                    break
                }
            }
        }
    }
    func rotateBrick() {
        guard let currentBrick = self.currentBrick else { return }
        
        let rotatedPoints = currentBrick.rotatedPoints()
        if self.canRotate(currentBrick, rotatedPoints: rotatedPoints) {
            currentBrick.points = rotatedPoints
            self.setNeedsDisplay()
        }
    }
    
    func canRotate(_ brick:Brick, rotatedPoints:[CGPoint]) -> Bool {
        
        for p in rotatedPoints {
            let r = Int(p.y) + brick.ty
            let c = Int(p.x) + brick.tx
            if r < 0 || r >= GameBroad.rows {
                return false
            }
            if c < 0 || c >= GameBroad.cols {
                return false
            }
            if self.board[r][c] != GameBroad.emptyColor {
                return false
            }
        }
        return true
    }
    func upDown(){
        time1 = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updataY), userInfo: nil, repeats: true)
        updataY()
    }
    
    @objc func updataY(){
        guard let currentBrick = self.currentBrick else { return }
        var canMoveDown = Int(currentBrick.top().y) + currentBrick.ty + 1 <= GameBroad.rows - 1
        if canMoveDown{
            for p in currentBrick.points{
                let r = Int(p.y) + currentBrick.ty + 1
                let c = Int(p.x) + currentBrick.tx
                
                if r < 0 {
                    continue
                }
                
                if r >= GameBroad.rows - 1 {
                    time1.invalidate()
                    canMoveDown = false
                    update()
                    break
                }else if self.board[r][c] != GameBroad.emptyColor{
                    time1.invalidate()
                    canMoveDown = false
                    update()
                    break
                }
            }
        }
        if canMoveDown{
            currentBrick.moveDown()
            self.setNeedsDisplay()
        }
    }
    func updateX(_ x: Int){
        guard let currentBrick = self.currentBrick else { return }
        
        if x > 0 {
            var canMoveRight = Int(currentBrick.right().x) + currentBrick.tx + 1 <= GameBroad.cols-1
            if canMoveRight {
                for p in currentBrick.points {
                    let r = Int(p.y) + currentBrick.ty
                    let c = Int(p.x) + currentBrick.tx + 1
                    
                    // not visible brick point
                    if r < 0 {
                        continue
                    }
                    if self.board[r][c] !=  GameBroad.emptyColor {
                        canMoveRight = false
                        break
                    }
                }
            }
            if canMoveRight {
                currentBrick.moveRight()
                self.setNeedsDisplay()
            }
        } else if x < 0 {
            var canMoveLeft = Int(currentBrick.left().x) + currentBrick.tx - 1 >= 0
            if canMoveLeft {
                for p in currentBrick.points {
                    let r = Int(p.y) + currentBrick.ty
                    let c = Int(p.x) + currentBrick.tx - 1
                    
                    // not visible brick point
                    if r < 0 {
                        continue
                    }
                    if self.board[r][c] !=  GameBroad.emptyColor {
                        canMoveLeft = false
                        break
                    }
                }
            }
            if canMoveLeft {
                currentBrick.moveLeft()
                self.setNeedsDisplay()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // vẽ game board
        for r in  0..<GameBroad.rows {
            for c in 0..<GameBroad.cols {
                let color = self.board[r][c]
                self.drawAtRow(r, c, color)
            }
        }
        
        
        // vẽ viên gạch hiện tại
        guard let currentBrick = self.currentBrick else {return}
        for p in currentBrick.points{
            let r = Int(p.y) + currentBrick.ty
            let c = Int(p.x) + currentBrick.tx
            
            if r>=0{
                self.drawAtRow(r, c, currentBrick.color)
            }
        }
    }
    
    func drawAtRow(_ row: Int,_ col: Int,_ color: UIColor) {
        let context = UIGraphicsGetCurrentContext()
        let block = CGRect(x: CGFloat((col + 1) * GameBroad.margin + col * GameBroad.brickSize),
                           y: CGFloat((row + 1) * GameBroad.margin + row * GameBroad.brickSize),
                           width: CGFloat(GameBroad.brickSize),
                           height: CGFloat(GameBroad.brickSize))
        
        if color == GameBroad.emptyColor {
            GameBroad.strockeColor.set()
            context?.fill(block)
        } else {
            color.set()
            UIBezierPath(roundedRect: block, cornerRadius: 1).fill()
        }
    }
    func clear() {
        
        self.currentBrick = nil
        
        self.board = [[UIColor]]()
        for _ in 0..<GameBroad.rows {
            self.board.append(self.generateRow())
        }
        self.setNeedsDisplay()
        
    }
    
    fileprivate func generateRow() -> [UIColor]! {
        var row = [UIColor]()
        for _ in 0..<GameBroad.cols {
            row.append(GameBroad.emptyColor)
        }
        return row
    }
}
