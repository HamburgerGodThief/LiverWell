//
//  WorkoutViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/11.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

struct Workout {
    
    let title: String
    
    let info: String
    
    let totalRepeat: Int
    
    let totalCount: Int
    
    let perDuration: TimeInterval
    
}

// swiftlint:disable identifier_name
class WorkoutViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var workoutTitleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var repeatCollectionView: UICollectionView!
    
    @IBOutlet weak var barProgressView: UIProgressView!
    
    var timer: Timer?
    
    var startTime = 0
    
    var counter = 1
    
    var workoutSet = [
        Workout(
            title: "看電視順便做",
            info: "轉到手臂有明顯緊繃感為止",
            totalRepeat: 2,
            totalCount: 3,
            perDuration: 2
        ),
        Workout(
            title: "預防腰痛",
            info: "轉到手臂有明顯緊繃感為止",
            totalRepeat: 2,
            totalCount: 5,
            perDuration: 1
        )
    ]
    
    var workoutIndex = 0
    
    var repeatCountingText = [String]()
    
    var nowRepeat = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        changeTitleAndRepeats()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
        repeatCountingText = [String]()
    }
    
    private func changeRepeatCounts(totalCount: Int, timeInterval: TimeInterval) {
        
        for i in 1...totalCount {
            let repeatCount = "\(i)/\(totalCount)次"
            repeatCountingText.append(repeatCount)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            
            if self.counter < totalCount {
                self.repeatLabel.text = self.repeatCountingText[self.counter]
                self.counter += 1
            } else {
                self.timer?.invalidate()
                self.moveToNextVC()
                
                if self.nowRepeat < self.workoutSet[self.workoutIndex].totalRepeat {
                    self.nowRepeat += 1
                    
                    self.changeTitleAndRepeats()
                    
                } else {
                    self.workoutIndex += 1
                    self.nowRepeat = 1
                }
            }
        })
    }
    
    private func changeTitleAndRepeats() {
        
        let nowWorkout = workoutSet[workoutIndex]
        
        workoutTitleLabel.text = nowWorkout.title
        infoLabel.text = nowWorkout.info
        
        counter = 1
        repeatLabel.text = "\(self.counter)/\(nowWorkout.totalCount)次"
        
        changeRepeatCounts(totalCount: nowWorkout.totalCount, timeInterval: nowWorkout.perDuration)
        
        repeatCollectionView.reloadData()
        
    }
    
    private func moveToNextVC() {
        
        if nowRepeat == workoutSet[workoutIndex].totalRepeat && workoutIndex == (workoutSet.count - 1) {
            performSegue(withIdentifier: "finishWorkout", sender: self)
        } else if nowRepeat == workoutSet[workoutIndex].totalRepeat {
            performSegue(withIdentifier: "startRest", sender: self)
        } else {
            return
        }
        
    }
    
}

extension WorkoutViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workoutSet[workoutIndex].totalRepeat
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = repeatCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: RepeatCollectionViewCell.self),
            for: indexPath
        )
        
        guard let repeatCell = cell as? RepeatCollectionViewCell else { return cell }
        
        var bgColorArray = [UIColor?]()
        var textColorArray = [UIColor?]()
        
        for _ in 0..<workoutSet[workoutIndex].totalRepeat {
            let defaultViewColor = UIColor.B5
            bgColorArray.append(defaultViewColor)
            
            let defaultTextColor = UIColor.B1
            textColorArray.append(defaultTextColor)
        }
        
        for i in 0..<nowRepeat {
            let finishedViewColor = UIColor.G2
            bgColorArray[i] = finishedViewColor
            
            let finishedTextColor = UIColor.white
            textColorArray[i] = finishedTextColor
        }
        
        repeatCell.counterLabel.text = String(indexPath.item + 1)
        repeatCell.counterLabel.textColor = textColorArray[indexPath.item]
        repeatCell.cellBackground.backgroundColor = bgColorArray[indexPath.item]
        
        return repeatCell
    }
    
}

extension WorkoutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        let collectionViewWidth = repeatCollectionView.bounds.width
        let cellSpace = Int(collectionViewWidth) / workoutSet[workoutIndex].totalRepeat
        return CGSize(width: cellSpace, height: 25)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 0
    }
    
}
