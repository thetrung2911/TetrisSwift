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
    - GameBroad gồm 21 hàng 12 cột, mảng hai chiều của UIColor.


    **Game Score**
    - Dùng để hiện thông tin Level, Score, Line, Button Play/Stop:
        + Level: Hiển thị Level người chơi đang chơi. Game gồm có 6 Level từ 1-6 tốc độ mỗi Level sẽ tăng dần.
        + Line: Hiển thị số hàng mà mình đã ăn được.
        + Score: Hiển thị điểm của người chơi, sẽ có bốn thang điểm khi người chơi ăn cùng lúc ăn nhiều hàng với nhau.
        + Button Play/Pause: Dùng để bắt đầu và tạm dừng game.
