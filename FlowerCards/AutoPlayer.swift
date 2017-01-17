//
//  AutoPlayer.swift
//  FlowerCards
//
//  Created by Jozsef Romhanyi on 24/11/2016.
//  Copyright © 2016 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import SpriteKit

class AutoPlayer {
    enum runStatus: Int {
        case getTipp = 0, touchesBegan, touchesMoved, touchesEnded
    }
    struct GameToPlay {
        var level: Int
        var gameNumber: Int
        var stopAt: Int
        init(level: Int, gameNumber: Int, stopAt: Int = 0) {
            self.level = level
            self.gameNumber = gameNumber
            self.stopAt = stopAt
        }
    }
    var scene: CardGameScene
//    @objc let nextStepSelector = "nextStep:"
    var timer: Timer = Timer()
    var bestTipp = Tipps()
    var autoPlayStatus: runStatus = .getTipp
    var replay: Bool
    var indexForReplay: Int = 0
    var stopTimer = false
    var gamesToPlay: [GameToPlay] = [
//        GameToPlay(level: 2, gameNumber: 272),    // Game Lost
//        GameToPlay(level: 2, gameNumber: 424),    // Game Lost
//        GameToPlay(level: 2, gameNumber: 616),    // Game Lost
//        GameToPlay(level: 2, gameNumber: 644),    // OK
//        GameToPlay(level: 2, gameNumber: 810),    // OK

        
//        GameToPlay(level: 30, gameNumber: 128), //, stopAt: 97),   // ?
//        GameToPlay(level: 30, gameNumber: 378),     //, stopAt: 87),
//        GameToPlay(level: 30, gameNumber: 476),
//        GameToPlay(level: 30, gameNumber: 480),
//        GameToPlay(level: 30, gameNumber: 542),
//        GameToPlay(level: 30, gameNumber: 860),
        
        GameToPlay(level: 66, gameNumber: 377),
        GameToPlay(level: 66, gameNumber: 470),
        GameToPlay(level: 66, gameNumber: 557),
        GameToPlay(level: 66, gameNumber: 882)
        
    ]
    var gameIndex = 0

    init(scene: CardGameScene) {
        self.scene = scene
        self.replay = false
        self.stopTimer = false
    }
    
    func startPlay(replay: Bool) {
        self.replay = replay
        scene.replaying = replay
        stopTimer = false
        if self.replay {
            scene.startNewGame(false)
            scene.durationMultiplier = scene.durationMultiplierForAutoplayer
            indexForReplay = 0
        } else {
            startNextGame()
        }
        scene.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(nextStep(timerX:)), userInfo: nil, repeats: false)
    }
    
    func startNextGame() {
        realm.beginWrite()
        GV.player!.levelID = gamesToPlay[gameIndex].level - 1
        try! realm.commitWrite()
        scene.gameNumber = gamesToPlay[gameIndex].gameNumber - 1
        scene.startNewGame(false)
        scene.durationMultiplier = scene.durationMultiplierForAutoplayer
    }
    
    
    @objc func nextStep(timerX: Timer) {
        if scene.cardCount > 0 /*&& scene.tippArray.count > 0*/ {
            switch autoPlayStatus {
            case .getTipp:
                if scene.tippsButton!.alpha == 1 && scene.countMovingCards == 0 {  // if tipps are ready
                    bestTipp = Tipps()
                    if replay {
                        if indexForReplay < realm.objects(HistoryModel.self).filter("gameID = %d", scene.actGame!.ID).count {
                            let historyRecord = realm.objects(HistoryModel.self).filter("gameID = %d", scene.actGame!.ID)[indexForReplay]
                            indexForReplay += 1
                            bestTipp.points.append(CGPoint(x: historyRecord.points[0].x, y: historyRecord.points[0].y))
                            bestTipp.points.append(CGPoint(x: historyRecord.points[1].x, y: historyRecord.points[1].y))
                        } else {
                            stopAutoplay()
                        }
                    } else {
                        for tipp in scene.tippArray {
                            if bestTipp.value < tipp.value {
                                bestTipp = tipp
                            }
                        }
                    }
                    if bestTipp.points.count > 0 {
                        autoPlayStatus = .touchesBegan
                    } else {
                        if gamesToPlay.count == 0 {
                            stopAutoplay()
                        } else {
                            gameIndex += 1
                            if gameIndex < gamesToPlay.count {
                               startNextGame()
                            }
                        }
                    }
                    
                }
            case .touchesBegan:
                scene.myTouchesBegan(touchLocation: bestTipp.points[0])
                autoPlayStatus = .touchesMoved
            case .touchesMoved:
                scene.myTouchesMoved(touchLocation: bestTipp.points[1])
                autoPlayStatus = .touchesEnded
            case .touchesEnded:
                scene.myTouchesEnded(touchLocation: bestTipp.points[1])
                if MySKCard.cardCount == gamesToPlay[gameIndex].stopAt { 
                    stopAutoplay()
                }
                autoPlayStatus = .getTipp
            }
            if stopTimer {
                timer.invalidate()
            } else {
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(nextStep(timerX:)), userInfo: nil, repeats: false)
            }
        } else {
                if gamesToPlay.count == 0 {
                    stopAutoplay()
                } else {
                    gameIndex += 1
                    if gameIndex < gamesToPlay.count {
                        startNextGame()
                    } else {
                        stopAutoplay()
                    }
                }
            if !stopTimer {
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(nextStep(timerX:)), userInfo: nil, repeats: false)
            }
        }
    }
    
    func stopAutoplay() {
        scene.isUserInteractionEnabled = true
        scene.autoPlayerActive = false
        scene.replaying = false
        stopTimer = true
        timer.invalidate()
        print("timer stopped at indexForReplay: \(indexForReplay)")
    }
    
}
