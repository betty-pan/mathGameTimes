//
//  ViewController.swift
//  mathGameTimes
//
//  Created by Betty Pan on 2021/1/14.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var heartsLabel: UILabel!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numOfQuestionLabel: UILabel!
    @IBOutlet weak var numOfQuestionSlider: UISlider!
    
    @IBOutlet weak var num1Label: UILabel!
    @IBOutlet weak var num2Label: UILabel!
    @IBOutlet var ansBtns: [UIButton]!
    @IBOutlet weak var playAgainBtn: UIButton!
    
    var index = 1
    var score = 0
    var heart = ""
    var player: AVPlayer?
    
    //亂數(被乘數&乘數)
    var count1 = Int.random(in: 1...9)
    var count2 = Int.random(in: 1...9)
    
    //選擇題選項（生成兩個亂數一個答案）
    var options:[Int] = []
    var option1 = Int.random(in: 1...99)
    var option2 = Int.random(in: 1...99)
    var ans = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomQuestions()
        num1Label.text = "\(count1)"
        num2Label.text = "\(count2)"
        numOfQuestionLabel.text = "Q.\(index)"
        numOfQuestionSlider.value = Float(index)
        scoreLabel.text = "\(score)"
        //更改slider Thumb圖示
        numOfQuestionSlider.setThumbImage(UIImage(named: "car2"), for: .normal)
        //隱藏Btn
        playAgainBtn.isHidden = true
    }
    
    func randomQuestions(){
        //亂數出題：被乘數與成數亂數
        count1 = Int.random(in: 1...9)
        count2 = Int.random(in: 1...9)
        num1Label.text = "\(count1)"
        num2Label.text = "\(count2)"

        //選擇題選項-Array三個選項(btn)
        //每次array須歸零，否則將一直append上去！
        options = []
        //選項需要三個數字（兩個錯誤答案，一個正確答案）
        option1 = Int.random(in: 1...99)
        option2 = Int.random(in: 1...99)
        ans = count1*count2
        //三個數字加進array
        options.append(option1)
        options.append(option2)
        options.append(ans)
        //答案btn位置變換
        options.shuffle()
        //選擇題選項-數字顯示
        for i in 0...2{
            ansBtns[i].setTitle(String(options[i]), for: .normal)
        }
        //題數連動slider
        numOfQuestionLabel.text = "Q.\(index)"
        numOfQuestionSlider.value = Float(index)
        //分數label顯示
        scoreLabel.text = "\(score)"
        //愛心表示答對與答錯
        heartsLabel.text = "\(heart)"
    }
    
    
    @IBAction func multiChoices(_ sender: UIButton) {
        index = index + 1
        //當點選btn時，點選到正確答案時
        if sender.currentTitle == String(ans) {
            score = score + 10
            scoreLabel.text = "\(score)"
            heart = heart + "❤️"
            //匯入答對音效
            if let url = Bundle.main.url(forResource: "correctAnswer", withExtension: "mp3"){
                player = AVPlayer(url: url)
                player?.play()
            }
        //當點選btn時，點選到錯誤答案時
        }else{
            //匯入答錯音效
            heart = heart + "🖤"
            if let url = Bundle.main.url(forResource: "wrongAnswer", withExtension: "mp3") {
                player = AVPlayer(url: url)
                player?.play()
            }
        }
        //當有五顆愛心時，換下一行
        if heart.count == 5{
            heart = heart + "\n"
        }
        //更改score顏色
        if score <= 30 {
            scoreLabel.textColor = UIColor.black
        }else if score <= 60 {
            scoreLabel.textColor = UIColor.orange
        }else{
            scoreLabel.textColor = UIColor.red
        }
        
        //第十題時（遊戲結束）
        if index > 10 {
            index = 10
            playAgainBtn.isHidden = false
            //當分數小於等於30時，image顯示驚訝臉
            if score <= 30 {
                faceImageView.image = UIImage(named: "shocked")
            //當分數小於等於60時，image顯示無言臉
            }else if score <= 60 {
                faceImageView.image = UIImage(named: "neutral")
            //當分數大於等於70，image顯示開心臉
            }else{
                faceImageView.image = UIImage(named: "happy")
            }
        }
        randomQuestions()
    }
    

    @IBAction func playAgain(_ sender: UIButton) {
        //將所有數值歸零
        index = 1
        score = 0
        heart = ""
        scoreLabel.textColor = UIColor.black
        faceImageView.image = UIImage(named: "thinking")
        playAgainBtn.isHidden = true
        randomQuestions()
    }
    
}

