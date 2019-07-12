#  Game Tetris
1. Game Tetris là một loại game sắp xếp các khối gạch chồng lên nhau.
2. Mô tả chi tiết:

    **Các đối tượng trong trò chơi:**
    - Các đối tượng gạch đang rơi
    - Các đối tượng gạch đã rơi ở đáy

    **Tương tác người chơi:**
    - Chơi: Chạm vào nút Play để bắt đầu trò chơi.
    - Tạm dừng: Chạm vào nút Pause để tạm dừng trò chơi.
    - Di chuyển sang trái: vuốt sang trái, gạch di chuyển sang trái một ô.
    - Di chuyển sang phải: vuốt sang phải, gạch di chuyển sang phải một ô.
    - Rơi nhanh xuống dưới: Vuốt xuống dưới, gạch di chuyển nhanh xuống dưới đến khi dừng.
    - Xoay: Vuốt lên trên gạch sẽ xoay một góc 90 độ theo kim đồng hồ.
3. Cấu trúc game:

    - MainViewController.swift
    - GameView.swift:
        + GameBroad.swift
        + GameScore.swift
        + Brick.swift
    - SoundManager.swift
    
    **GameView**
    - Dùng để Layout giao diện của game.
    - Game sẽ có 2 phần chính là phần Score và Broad
    ```
    class GameView: UIView {
        let gameScore = GameScore(frame: CGRect.zero)
        let gameBroad = GameBroad(frame: CGRect.zero)
        ...
        func setupLayout(){
            // tạo gameBroad
            self.addSubview(gameBroad)
            gameBroad.translatesAutoresizingMaskIntoConstraints = false
            gameBroad.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
            gameBroad.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -margin).isActive = true
            gameBroad.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0 ).isActive = true
            gameBroad.topAnchor.constraint(equalTo: self.bottomAnchor, constant:-CGFloat((GameBroad.rows + 1) * GameBroad.margin + GameBroad.rows * GameBroad.brickSize)).isActive = true
            ...
        }
        ...
    }
    ```
    
    **Brick**
    - Game có 7 loại gạch khác nhau gồm: i, j, l, t, z, s, o.
    - Gạch có các loại màu khác nhau.

    ```
    enum BrickType {
        case i(UIColor)
        case j(UIColor)
        case l(UIColor)
        case t(UIColor)
        case z(UIColor)
        case s(UIColor)
        case o(UIColor)
   }  
   class Brick: NSObject {

    ...
    static var bricks = [
    BrickType.i(UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0)),
    BrickType.j(UIColor(red:0.20, green:0.60, blue:1.00, alpha:1.0)),
    BrickType.l(UIColor(red:0.20, green:0.80, blue:0.20, alpha:1.0)),
    BrickType.t(UIColor(red:0.80, green:0.00, blue:1.00, alpha:1.0)),
    BrickType.z(UIColor(red:0.00, green:0.60, blue:0.60, alpha:1.0)),
    BrickType.s(UIColor(red:1.00, green:0.80, blue:1.00, alpha:1.0)),
    BrickType.o(UIColor(red:1.00, green:0.60, blue:0.60, alpha:1.0))
    ]
    ...    
    }
    ```
    
    **Game Broad**
    - GameBroad là nơi xử lý logic và tương tác người chơi.
    - GameBroad gồm 21 hàng 12 cột, mảng hai chiều của UIColor.
    ```
    class GameBroad: UIView {
        static let rows = 21
        static let cols = 12
        ...
        var board = [[UIColor]]()
        ...
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
        ...
        func gameInteraction(){
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
            swipeUp.direction = .up
            self.addGestureRecognizer(swipeUp)
        ...
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
        ...
    }
    ```

    **Game Score**
    - Dùng để hiện thông tin Level, Score, Line, Button Play/Stop:
        + Level: Hiển thị Level người chơi đang chơi. Game gồm có 6 Level từ 1-6 tốc độ mỗi Level sẽ tăng dần.
        + Line: Hiển thị số hàng mà mình đã ăn được.
        + Score: Hiển thị điểm của người chơi, sẽ có bốn thang điểm khi người chơi ăn cùng lúc ăn nhiều hàng với nhau.
        + Button Play/Pause: Dùng để bắt đầu và tạm dừng game.
    ```
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
    ```
        
    **SoundManager**
    - Cung cấp hiệu ứng âm thanh.
    - Nhạc nền, nhạc GameOver, nhạc lúc người chơi ăn điểm.
    ```
    class SoundManager {
    var bombSoundEffect: AVAudioPlayer?
    
    ...
    }
    ```
    
