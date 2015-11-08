# TableViewSwipe
TableViewの各Cellにスワイプの機能を追加する。


![demo](https://cloud.githubusercontent.com/assets/4962215/11019848/f2b60a44-864f-11e5-91d5-88e3d1f0ae3e.gif)

## Installation

Podfileに下記を追加する（未対応）

```
pod 'TableViewSwipe'
```

## Usage
Swipeを適用したいTableViewに対して以下を記述する。

```
tableView.swipeEnabled(true)
```

ラベルや色をカスタマイズしたい場合はTableViewを持っているViewControllerに `SwipeDelegate`を実装する。

```
self.setSwipeDelegate(delegate)
```

```
extension ViewController: SwipeDelegate {
	    // スワイプのジェスチャを検知し、そのindexPathに対してスワイプを適用するかを返す
    func swipe(direction: SwipeDirection, shouldBeginAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    // スワイプされたときにセルの下に表示されるラベルを返す
    // ただし、新規生成されたラベルに対しては非対応
    func swipe(direction: SwipeDirection, titleLabel: UILabel, atIndexPath indexPath: NSIndexPath, active: Bool) -> UILabel {
        switch direction {
        case .Left:
            titleLabel.text = "Right side"
        case .Right:
            titleLabel.text = "Left side"
        }
        if active {
            titleLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        } else {
            titleLabel.textColor = UIColor(red: 244 / 255, green: 67 / 255, blue: 54 / 255, alpha: 1.0)
        }
        return titleLabel
    }
    
    // スワイプされたときにセルの下に表示される背景色を返す
    func swipe(direction: SwipeDirection, backgroundColorAtIndexPath indexPath: NSIndexPath, active: Bool) -> UIColor {
        if active {
            return UIColor(red: 244 / 255, green: 67 / 255, blue: 54 / 255, alpha: 1.0/2)
        } else {
            return UIColor(red: 236 / 255, green: 239 / 255, blue: 241 / 255, alpha: 1.0/2)
        }
    }
    // スワイプのrate（TableViewに対して何%移動したか）を元にアクティブかどうかを返す
    func swipe(direction: SwipeDirection, acitiveWithRate rate: CGFloat) -> Bool {
        return abs(rate) > 0.3
    }

}
```

スワイプの開始、終了時には以下のデリゲートメソッドが呼ばれる

```
    optional func swipe(direction: SwipeDirection, willBeginAtIndexPath indexPath: NSIndexPath)
    optional func swipe(direction: SwipeDirection, didBeginAtIndexPath indexPath: NSIndexPath)
    optional func swipe(direction: SwipeDirection, atIndexPath indexPath: NSIndexPath, rate: CGFloat)
    optional func swipe(direction: SwipeDirection, willEndAtIndexPath indexPath: NSIndexPath)
    optional func swipe(direction: SwipeDirection, didEndAtIndexPath indexPath: NSIndexPath)
```


## TODO
- [ ] CocoaPods
- [ ] Carthage
- [ ] Testing
- [ ] ドキュメントの英語化
- [ ] 閉じるアニメーションを自然にする
- [ ] 拡大時のアニメーション
- [ ] SwipeViewのカスタマイズオプション
- [ ] SwipeLabelの新規対応
- [ ] リッチなデモアプリ
- [ ] スワイプ中は他のセルのスワイプを制限
- [ ] マルチスワイプ
- [ ] その他バグ修正
