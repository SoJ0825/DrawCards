import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animationView: UIView!
    @IBOutlet var maskView: UIView!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var cardAura: UIImageView!
    @IBOutlet weak var backsideCard: UIImageView!
    @IBOutlet weak var borderImageView: UIImageView!
    
    let whiteView = UIView(frame: CGRect(x: 79, y: 70, width: 82, height: 100))
    let firstBackground = UIImageView(frame: CGRect(
        x: 79,
        y: 70,
        width: 82,
        height: 100))
    let firstShiny = UIImageView(frame: CGRect(
        x: 0,
        y: 0,
        width: 82,
        height: 100))
    let firstImageView = UIImageView(frame: CGRect(
        x: 0,
        y: 0,
        width: 82,
        height: 100))
    
    let secondBackground = UIImageView(frame: CGRect(
        x: 79 + 82,
        y: 70,
        width: 82,
        height: 100))
    let secondShiny = UIImageView(frame: CGRect(
        x: 0,
        y: 0,
        width: 82,
        height: 100))
    let secondImageView = UIImageView(frame: CGRect(
        x: 0,
        y: 0,
        width: 82,
        height: 100))
    
    let randomColor = ["gray", "green", "blue", "red"]
    
    var timer = Timer()
    var shinyTimer = Timer()
    let timeInterval: Double = 0.01
    var timeCount: Double = 10
    var moveRatio: Double = 1
    
    var isOpen = true
    var canReset = false
    
    @IBAction func openCard(_ sender: UIButton) {
        
        if isOpen {
            shinyTimer.invalidate()
            openButton.setTitle("Hide", for: .normal)
            isOpen = false
            
            whiteView.alpha = 1
            self.backsideCard.isHidden = true
            self.cardAura.isHidden = true
            //            self.borderImageView.isHidden = true
            self.borderImageView.layer.zPosition = 2
            
            maskView.frame = CGRect(x: 79, y: 70, width: 82, height: 100)
            self.animationView.mask = self.maskView
            
            let firstRandom = Int(arc4random_uniform(4))
            let firstCharacterRandom = Int(arc4random_uniform(8)+1)
            let firstImageName = "card_aura_\(self.randomColor[firstRandom])_128x128_"
            let firstImages = self.createImages(name: firstImageName)
            self.firstBackground.image = UIImage(named: "card_slot_60x73_0\(firstRandom+2)")
            self.firstShiny.image = UIImage.animatedImage(with: firstImages, duration: 2)
            self.firstImageView.image = UIImage(named: "character\(firstCharacterRandom)")
            
            
            let secondRandom = Int(arc4random_uniform(4))
            let secondCharacterRandom = Int(arc4random_uniform(8)+1)
            let secondImageName = "card_aura_\(self.randomColor[secondRandom])_128x128_"
            let secondImages = self.createImages(name: secondImageName)
            self.secondBackground.image = UIImage(named: "card_slot_60x73_0\(secondRandom+2)")
            self.secondShiny.image = UIImage.animatedImage(with: secondImages, duration: 2)
            self.self.secondImageView.image = UIImage(named: "character\(secondCharacterRandom)")
            
//            self.firstBackground.addSubview(self.firstShiny)
            self.firstBackground.addSubview(self.firstImageView)
            self.animationView.addSubview(self.firstBackground)
            
//            self.secondBackground.addSubview(self.secondShiny)
            self.secondBackground.addSubview(self.secondImageView)
            self.animationView.addSubview(self.secondBackground)
            
            
            self.timer = Timer.scheduledTimer(timeInterval:self.timeInterval, target: self , selector: #selector( self.moveImage), userInfo: nil , repeats: true )
        } else if canReset {
            backsideCard.isHidden = false
            cardAura.isHidden = false
            
            maskView.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
            firstBackground.removeFromSuperview()
            secondBackground.removeFromSuperview()
            
            openButton.setTitle("Open", for: .normal)
            isOpen = true
            borderImageView.image = UIImage(named: "card_slot_line_94x112-(1)_01")
            shinyTimer = Timer.scheduledTimer(timeInterval:2, target: self , selector: #selector( borderShiny), userInfo: nil , repeats: true )
        }
    }
    
    
    
    @objc func moveImage() {
        
        whiteView.backgroundColor = .white
        animationView.addSubview(whiteView)
        UIView.animate(withDuration: 0.5, animations: {
            self.whiteView.alpha = 0
            
        })
        let firstRandom = Int(arc4random_uniform(4))
        let firstCharacterRandom = Int(arc4random_uniform(8)+1)
        let secondRandom = Int(arc4random_uniform(4))
        let secondCharacterRandom = Int(arc4random_uniform(8)+1)
        
        var firstBorderImageName = "card_slot_line_94x112-(1)_0"
        var secondBorderImageName = "card_slot_line_94x112-(1)_0"
        
        if timeCount > 0 {
            timeCount -= 1 * timeInterval
//            print(timeCount)
            moveRatio += 0.3
            firstBackground.frame.origin.x -= CGFloat(82 / moveRatio)
            secondBackground.frame.origin.x -= CGFloat(82 / moveRatio)
            if firstBackground.frame.origin.x < -3 {

                let firstImageName = "card_aura_\(randomColor[firstRandom])_128x128_"
                let firstImages = createImages(name: firstImageName)
                firstBackground.image = UIImage(named: "card_slot_60x73_0\(firstRandom+2)")
                firstBorderImageName += "\(firstRandom+2)"
                firstShiny.image = UIImage.animatedImage(with: firstImages, duration: 2)
                firstImageView.image = UIImage(named: "character\(firstCharacterRandom)")
                firstBackground.frame.origin.x = secondBackground.frame.origin.x + secondBackground.frame.width
            }
            if secondBackground.frame.origin.x < -3 {

                let secondImageName = "card_aura_\(randomColor[secondRandom])_128x128_"
                let secondImages = createImages(name: secondImageName)
                secondBackground.image = UIImage(named: "card_slot_60x73_0\(secondRandom+2)")
                secondBorderImageName += "\(secondRandom+2)"
                secondShiny.image = UIImage.animatedImage(with: secondImages, duration: 2)
                secondImageView.image = UIImage(named: "character\(secondCharacterRandom)")
                secondBackground.frame.origin.x = firstBackground.frame.origin.x + 82
            }
        } else {
            timer.invalidate()
            timeCount = 10
            moveRatio = 1
            whiteView.alpha = 1
            canReset = true
            UIView.animate(withDuration: 0.5, animations: {
                self.whiteView.alpha = 0
            })
            if firstBackground.frame.origin.x > 79 && firstBackground.frame.origin.x < 79+41 {
                firstBackground.frame.origin.x = 79
                secondBackground.frame.origin.x = 79 + 82
                borderImageView.image = UIImage(named: firstBorderImageName)
//                print("first: \(firstRandom)")
                firstBackground.addSubview(firstShiny)
                firstImageView.layer.zPosition = 2
            } else {
                firstBackground.frame.origin.x = 79  + 82
                secondBackground.frame.origin.x = 79
                borderImageView.image = UIImage(named: secondBorderImageName)
//                print("second: \(secondRandom)")
                secondBackground.addSubview(secondShiny)
                secondImageView.layer.zPosition = 2
            }
        }
        
    }
    
    func createImages(name: String) -> [UIImage] {
        
        var images = [UIImage]()
        
        for i in 1...30 {
            var imageName: String = name
            if i < 10 {
                imageName += "0\(i)"
                images.append(UIImage(named: imageName)!)
            } else {
                imageName += "\(i)"
                images.append(UIImage(named: imageName)!)
            }
        }
        return images
    }

    @objc func borderShiny() {
        
        UIView.animate(withDuration: 1, animations: {
            self.borderImageView.alpha = 0
        }) { go in
            UIView.animate(withDuration: 1, animations: {
                self.borderImageView.alpha = 1
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let images = createImages(name: "card_aura_gray_180x180_")
        cardAura.image = UIImage.animatedImage(with: images, duration: 2)
        shinyTimer = Timer.scheduledTimer(timeInterval:2, target: self , selector: #selector( borderShiny), userInfo: nil , repeats: true )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

