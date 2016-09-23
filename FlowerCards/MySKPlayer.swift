//
//  MySKPlayer.swift
//  Flowers
//
//  Created by Jozsef Romhanyi on 04/04/2016.
//  Copyright © 2016 Jozsef Romhanyi. All rights reserved.
//

import SpriteKit
import RealmSwift

class MySKPlayer: MySKTable, UITextFieldDelegate {
    
    var callBack: ()->()
//    var heightOfTableRow: CGFloat = 0
    var nameInputField = UITextField()
    var nameTable = [PlayerModel]()
    var nameTableIndex = 0
    var parentNode: SKSpriteNode
    var positionMultiplier = GV.deviceConstants.cardPositionMultiplier * 0.6
    var countLines = 0
    let myColumnWidths: [CGFloat] = [70, 15, 15]  // in %
    let imageSize = CGSize(width: 30 * GV.deviceConstants.imageSizeMultiplier,height: 30 * GV.deviceConstants.imageSizeMultiplier)
    var deleteImage: UIImage
    var modifyImage: UIImage
    var OKImage: UIImage
//    let statisticImage = DrawImages.getStatisticImage(CGSizeMake(30,30))
    let myName = "MySKPlayer"
    var sleepTime: Double = 0



    init(parent: SKSpriteNode, view: UIView, callBack: @escaping ()->()) {
        nameTable = Array(realm.objects(PlayerModel.self).sorted(byProperty: "created", ascending: true))
        countLines = nameTable.count// + (nameTable[0].name == GV.language.getText(.TCGuest) ? 0 : 1)
        self.parentNode = parent
        self.callBack = callBack
        self.deleteImage = DrawImages.getDeleteImage(imageSize)
        self.modifyImage = DrawImages.getModifyImage(imageSize)
        self.OKImage = DrawImages.getOKImage(imageSize)

        
//        let texture: SKTexture = SKTexture(image: DrawImages().getTableImage(parent.frame.size,countLines: Int(countLines), countRows: 1))
        super.init(columnWidths: myColumnWidths, rows:countLines, headLines: [], parent: parent)

        self.name = myName
        self.parentView = view
//        let size = CGSizeMake(parent.frame.width * 0.9, CGFloat(countLines) * self.heightOfLabelRow)
        
//        let myStartPosition = CGPointMake(0, (parent.size.height - size.height) / 2 - 10)
//        self.position = myStartPosition
        
//        let myTargetPosition = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2)
        
        self.nameInputField.delegate = self
        self.zPosition = parent.zPosition + 200
        
        
        showMe(showPlayers)
        

//        self.alpha = 1.0
//        let actionMove = SKAction.moveTo(myTargetPosition, duration: 0.5)
//        let alphaAction = SKAction.fadeOutWithDuration(0.5)
//        parent.parent!.addChild(self)
//        
//        parent.runAction(alphaAction)
//        self.runAction(actionMove)
//        parent.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getPlayerName(_ row: Int) {
        self.isUserInteractionEnabled = false
        let name = nameTable[row].name == GV.language.getText(.tcAnonym) ? "" : nameTable[row].name
        let myFont = UIFont(name: "Times New Roman", size: fontSize)
        
        let labelName = "0\(separator)\(row)"
        
        if childNode(withName: labelName) == nil {
           _ = addNewPlayerWhenRequired()
        }
        
        let position = (self.childNode(withName: labelName) as! SKLabelNode).position

        
        let xPosition = parentView!.frame.size.width / 2 + position.x
        let yPosition = parentView!.frame.size.height / 2 - position.y - heightOfLabelRow * 0.45
        nameInputField.isHidden = false
        nameInputField.font = myFont
        nameInputField.textColor = UIColor.blue
        nameInputField.text = name
        nameInputField.placeholder = GV.language.getText(.tcNewName)
        nameInputField.backgroundColor = UIColor.white
        nameInputField.frame = CGRect(x: xPosition, y: yPosition,
                                          width: size.width * 0.6,
                                          height: heightOfLabelRow * 0.8)
        nameInputField.autocorrectionType = .no
        nameInputField.layer.borderWidth = 0.0
        nameInputField.becomeFirstResponder()
        parentView!.addSubview(nameInputField)
        
//        return nameInputField.text!
    }
    
    func removeBraces(_ s:String)->String {
        return s.trimmingCharacters(in: CharacterSet.init(charactersIn: "{}"))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            try! realm.write({
                nameTable[nameTableIndex].name = nameInputField.text!
            })
            _ = addNewPlayerWhenRequired()
        } else {
            changeActPlayer()
        }
        showPlayers()
        nameInputField.isHidden = true
        nameInputField.removeFromSuperview()
        nameTableIndex = nameTable.count - 2
        self.isUserInteractionEnabled = true
    }
    
    func sleep(_ delay: Double) {
        let startTime = Date()
        var endTime: Date
        repeat {
            endTime = Date()
        } while endTime.timeIntervalSince(startTime) < delay
        print(endTime.timeIntervalSince(startTime))
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField)->Bool {
        nameInputField.removeFromSuperview()
        return true
    }

    func showPlayers() {
        reDrawWhenChanged(myColumnWidths, rows: realm.objects(PlayerModel.self).count)
        for index in 0..<nameTable.count {
            let name = nameTable[index].name == GV.language.getText(.tcAnonym) ? "+        " : nameTable[index].name
            var elements: [MultiVar] = [MultiVar(string: name)]
            if !(name == "+") {
                elements.append(MultiVar(image: modifyImage))
                if nameTable.count > 2 {
                    elements.append(MultiVar(image: deleteImage))
                }
            }
            showRowOfTable(elements, row: index, selected: nameTable[index].isActPlayer)
        }
        if nameTable[0].name == GV.language.getText(.tcAnonym) {
            getPlayerName(0)
        }
    }
    

    func changeActPlayer () {
        try! realm.write({
            let oldActPlayer = realm.objects(PlayerModel.self).filter("isActPlayer = true").first
            var newActPlayer = realm.objects(PlayerModel.self).filter("ID =  \(nameTable[nameTableIndex].ID)").first
            if newActPlayer == nil || newActPlayer!.name == GV.language.getText(.tcGuest) {
                newActPlayer = PlayerModel()
                newActPlayer!.ID = nameTable[nameTableIndex].ID
                newActPlayer!.name = nameTable[nameTableIndex].name
            }
            oldActPlayer!.isActPlayer = false
            newActPlayer!.isActPlayer = true
            let oldIndex = indexOfPlayerID(oldActPlayer!.ID)
            let newIndex = indexOfPlayerID(newActPlayer!.ID)
            nameTable[oldIndex!].isActPlayer = false
            nameTable[newIndex!].isActPlayer = true
            realm.add(oldActPlayer!, update: true)
            realm.add(newActPlayer!, update: true)
            GV.player = newActPlayer
        })
        GV.language.setLanguage(GV.player!.aktLanguageKey)
        showPlayers()
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first!.location(in: self)
        touchesBeganAtNode = atPoint(touchLocation)
        if !(touchesBeganAtNode is SKLabelNode || (touchesBeganAtNode is SKSpriteNode && touchesBeganAtNode!.name != myName)) {
            touchesBeganAtNode = nil
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = touches.first!.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first!.location(in: self)
        let touchesEndedAtNode = atPoint(touchLocation)
        let (_, touchRow) = checkTouches(touches, withEvent: event)
        switch touchRow {
        case 0:
            GV.player = realm.objects(PlayerModel.self).filter("isActPlayer = true").first
            let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
            myParent.run(fadeInAction)
            removeFromParent()
            callBack()
        case 1..<100:

            if (touchesEndedAtNode.name == myName || touchesEndedAtNode is SKLabelNode) && touchRow == nameTable.count {
                let newPlayerID = addNewPlayerWhenRequired()
                nameTableIndex = nameTable.count - 1
                getPlayerName(indexOfPlayerID(newPlayerID)!)
            } else if touchesEndedAtNode.name == myName || touchesEndedAtNode is SKLabelNode {
                nameTableIndex = touchRow - 1
                changeActPlayer()
            } else if touchesBeganAtNode != nil && touchesEndedAtNode is SKLabelNode ||
                    (touchesEndedAtNode is SKSpriteNode && touchesEndedAtNode.name != myName) {
                let (column, row) = getColumnRowOfElement(touchesBeganAtNode!.name!)
                nameTableIndex = row
                switch column {
                    case 0: // select a Player
                        changeActPlayer()
                    case 1: // modify the player
                        let playerToModify = realm.objects(PlayerModel.self).filter("ID = \(nameTable[nameTableIndex].ID)").first
                        getPlayerName(indexOfPlayerID(playerToModify!.ID)!)
                    case 2: // delete the player
                        let playerName = realm.objects(PlayerModel.self).filter("ID = \(nameTable[nameTableIndex].ID)").first!.name
                        let alert = UIAlertController(title: GV.language.getText(.tcAreYouSureToDelete, values: playerName),
                                                      message: "",
                                                      preferredStyle: .alert)
                        
                        let OKAction = UIAlertAction(title: GV.language.getText(.tcok), style: .default,
                                                       handler: {(paramAction:UIAlertAction!) in
                                                        self.deletePlayer()
                        })
                        alert.addAction(OKAction)
                        let cancelAction = UIAlertAction(title: GV.language.getText(.tcCancel), style: .default,
                                                     handler: {(paramAction:UIAlertAction!) in
                        })
                        alert.addAction(cancelAction)
                        GV.mainViewController!.showAlert(alert)
                    
                    default: break
                }
            }
        default: break
        }
        
    }
    
    func addNewPlayerWhenRequired() -> Int {
        let lastPlayer = realm.objects(PlayerModel.self).sorted(byProperty: "created", ascending: false).first!
        if lastPlayer.name == GV.language.getText(.tcAnonym) {
            return lastPlayer.ID
        } else {
            let newPlayerID = GV.createNewPlayer()
            if newPlayerID > 0 {
                let array = Array(realm.objects(PlayerModel.self).filter("ID = %d", newPlayerID))
                nameTable.append(contentsOf: array)
                nameTableIndex = nameTable.count - 1
            }
            return newPlayerID
        }
    }
    
    func deletePlayer() {
        if realm.objects(PlayerModel.self).count > 1 {
            let playerToDelete = realm.objects(PlayerModel.self).filter("ID = %d", nameTable[nameTableIndex].ID).first!
            try! realm.write({
                nameTable.remove(at: nameTableIndex)
                realm.delete(realm.objects(StatisticModel.self).filter("playerID = %d", playerToDelete.ID))
                realm.delete(realm.objects(GameModel.self).filter("playerID = %d", playerToDelete.ID))
                realm.delete(playerToDelete)
                let playerToSetActPlayer = nameTable[0]
                playerToSetActPlayer.isActPlayer = true
                realm.add(playerToSetActPlayer, update: true)
                GV.player = playerToSetActPlayer
                //                        nameTable.removeAtIndex(nameTableIndex)
            })
            if realm.objects(PlayerModel.self).filter("name = %c", GV.language.getText(.tcAnonym)).count == 0 {
                _ = addNewPlayerWhenRequired()
            }
            showPlayers()
        }
    }
    
    func indexOfPlayerID(_ ID:Int)->Int? {
        for index in 0..<nameTable.count {
            if nameTable[index].ID == ID {
                return index
            }
        }
        return nil
    }
    override func setMyDeviceSpecialConstants() {
        switch GV.deviceConstants.type {
        case .iPadPro12_9:
            fontSize = CGFloat(20)
            heightOfLabelRow = 40
        case .iPadPro9_7:
            fontSize = CGFloat(20)
            heightOfLabelRow = 40
        case .iPad2:
            fontSize = CGFloat(20)
            heightOfLabelRow = 40
        case .iPadMini:
            fontSize = CGFloat(20)
            heightOfLabelRow = 40
        case .iPhone6Plus:
            fontSize = CGFloat(15)
            heightOfLabelRow = 35
        case .iPhone6:
            fontSize = CGFloat(15)
            heightOfLabelRow = 35
        case .iPhone5:
            fontSize = CGFloat(13)
            heightOfLabelRow = 30
        case .iPhone4:
            fontSize = CGFloat(12)
            heightOfLabelRow = 30
        default:
            break
        }
    }
}
