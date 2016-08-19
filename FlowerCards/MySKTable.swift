//
//  MySKTable.swift
//  Flowers
//
//  Created by Jozsef Romhanyi on 08/04/2016.
//  Copyright © 2016 Jozsef Romhanyi. All rights reserved.
//

import SpriteKit


class MySKTable: SKSpriteNode {

    
    enum MyEvents: Int {
        case GoBackEvent = 0, NoEvent
    }
    
    enum VarType: Int {
        case String = 0, Image
    }
    enum Orientation: Int {
        case Left = 0, Center, Right
    }
    struct MultiVar {
        var varType: VarType
        var stringVar: String?
        var imageVar: UIImage?
        init(string:String) {
            stringVar = string
            varType = .String
        }
        init(image: UIImage) {
            imageVar = image
            varType = .Image
        }
    }
    var heightOfMyHeadRow = CGFloat(0)
    var heightOfLabelRow = CGFloat(0)
    var fontSize = CGFloat(0)
    var myImageSize = CGFloat(0)
    var columns: Int
    var rows: Int
    var sizeOfElement: CGSize
    var touchesBeganAt: NSDate = NSDate()
    var touchesBeganAtNode: SKNode?
    var myParent: SKNode
    let separator = "-"
    var columnWidths: [CGFloat]
    var columnXPositions = [CGFloat]()
    var myHeight: CGFloat = 0
//    var positionsTable: [[CGPoint]]
    var parentView: UIView?
    var showVerticalLines = false
    var myStartPosition = CGPointZero
    var myTargetPosition = CGPointZero
    var headLines: [String]
    var scrolling = false
    var verticalPosition: CGFloat = 0
    
    let goBackImageName = "GoBackImage"
    
    init(columnWidths: [CGFloat], rows: Int, headLines: [String], parent: SKNode, width: CGFloat...) {
        
        self.columns = columnWidths.count
        self.rows = rows
        self.sizeOfElement = CGSizeMake(parent.frame.size.width / CGFloat(self.columns), heightOfLabelRow)
        self.columnWidths = columnWidths
        self.myParent = parent
        self.headLines = headLines.count == 0 ? [""] : headLines
        
        super.init(texture: SKTexture(), color: UIColor.clearColor(), size: CGSizeZero)
        setMyDeviceConstants()
        setMyDeviceSpecialConstants()

        let pSize = parent.parent!.scene!.size
        myStartPosition = CGPointMake(pSize.width, pSize.height / 2)//(pSize.height - size.height) / 2 - 10)
        myTargetPosition = CGPointMake(pSize.width / 2, pSize.height / 2) //(pSize.height - size.height) / 2 - 10)
        let headLineRows = CGFloat(headLines.count)
        
        heightOfMyHeadRow = (headLineRows == 0 ? 1 : headLineRows) * heightOfLabelRow

        self.position = myStartPosition
        
        self.zPosition = parent.zPosition + 200

        myHeight = heightOfLabelRow * CGFloat(rows) + heightOfMyHeadRow
        if myHeight > pSize.height {
            scrolling = true
            let positionToMoveY = myParent.frame.minY - self.frame.minY
            self.myTargetPosition.y += positionToMoveY
        }
        
        var mySize = CGSizeZero
        if width.count > 0 {
            mySize = CGSizeMake(width[0], myHeight)
            self.showVerticalLines = true
        } else {
            mySize = CGSizeMake(parent.frame.size.width * 0.9, myHeight)
        }
        self.size = mySize
        self.alpha = 1.0
        self.texture = SKTexture(image: drawTableImage(mySize, columnWidths: columnWidths, columns: self.columns, rows: rows))
        var columnMidX = -(mySize.width * 0.48)
        for column in 0..<columnWidths.count {
            columnXPositions.append(columnMidX)
            columnMidX += mySize.width * columnWidths[column] / 100
        }
        verticalPosition = (self.size.height - heightOfLabelRow) / 2 - heightOfMyHeadRow
        self.userInteractionEnabled = true
        //        fontSize = CGFloat(0)
        showMyImagesAndHeader(DrawImages.getGoBackImage(CGSizeMake(myImageSize, myImageSize)), position: 10, name: goBackImageName)
        
        //        parent!.addChild(self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeHeadLines(headLines: [String]) {
        self.headLines.removeAll()
        self.headLines.appendContentsOf(headLines)
    }
    
    func showRowOfTable(elements: [MultiVar], row: Int, selected: Bool) {
        for column in 0..<elements.count {
            switch elements[column].varType {
            case .String:
                showElementOfTable(elements[column].stringVar!, column: column, row: row, selected: selected)
            case .Image:
                showImageInTable(elements[column].imageVar!, column: column, row: row, selected: selected)
            }
        }
    }
    
    func showElementOfTable(element: String, column: Int, row: Int, selected: Bool, orientation: Orientation...) {
        let name = "\(column)\(separator)\(row)"
        var label = SKLabelNode()
        var labelExists = false
        
        
        for index in 0..<self.children.count {
            if self.children[index].name == name {
                label = self.children[index] as! SKLabelNode
                labelExists = true
                break
            }
        }
        
        if selected {
            label.fontName = "Times New Roman"
            label.fontColor = SKColor.blueColor()
        } else {
            label.fontName = "Times New Roman"
            label.fontColor = SKColor.blackColor()
        }
        label.text = element
        label.fontSize = fontSize
        
        // when label too long, make it shorter
        
        let cellWidth = self.frame.width * columnWidths[column] / 100
        while label.frame.width + 8 > cellWidth {
           label.fontSize -= 1
        }
        
        if !labelExists {
            label.zPosition = self.zPosition + 10
            label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            label.name = name
            if orientation.count > 0 {
                
            }
            
            let horizontalPosition = columnXPositions[column]
            label.position = CGPointMake(horizontalPosition,  verticalPosition - CGFloat(row) * heightOfLabelRow)
            
            self.addChild(label)
        }
    }
    
    func showMyImagesAndHeader(image: UIImage, position: CGFloat, name: String) {

        let shape = SKSpriteNode(texture: SKTexture(image: image))
 //       shape.texture = SKTexture(image: image)
        shape.name = name
        
        
        shape.position = CGPointMake(-(self.size.width * 0.43), (self.size.height - heightOfMyHeadRow) / 2) //CGPointMake(self.size.width * position, (self.size.height - heigthOfMyImageRow) / 2)
        shape.alpha = 1.0
        shape.size = image.size
        shape.zPosition = self.zPosition + 1000
        self.addChild(shape)
        
        for index in 0..<headLines.count {
            let label = SKLabelNode()
            label.fontName = "Times New Roman"
            label.fontColor = SKColor.blackColor()
            label.text = headLines[index]
            label.name = name
            label.zPosition = self.zPosition + 100
            label.fontSize = fontSize
            var correctur = CGFloat(0)
            switch  headLines.count {
            case 1:
                correctur = heightOfLabelRow * 0.24
            case 2:
                correctur = heightOfLabelRow * -0.3
            case 3:
                correctur = heightOfLabelRow * -0.8
            case 4:
                correctur = heightOfLabelRow * -1.2
            default:
                correctur = heightOfLabelRow / 2
            }
            label.position = CGPointMake(0, (self.size.height - heightOfMyHeadRow) / 2 - correctur - CGFloat(index) * heightOfLabelRow)
            self.addChild(label)
        }
        
    }

    
    func showImageInTable(image: UIImage, column: Int, row: Int, selected: Bool) {
        let name = "\(column)\(separator)\(row)"
        
        for index in 0..<self.children.count {
            if self.children[index].name == name {
                self.children[index].removeFromParent()
                break
            }
        }
        
        if !selected {
            return
        }
        
        let shape = SKSpriteNode()
        shape.texture = SKTexture(image: image)
        shape.name = name
        
        var xPos: CGFloat = 0
        for index in 0..<column {
            xPos += size.width * columnWidths[index] / 100
        }
        xPos += (size.width * columnWidths[column] / 100) / 2
        xPos -= self.size.width / 2
        
        let verticalPosition = (self.size.height - heightOfLabelRow) / 2 - heightOfMyHeadRow
//        label.position = CGPointMake(-size.width * 0.45 + CGFloat(column) * sizeOfElement.width,  verticalPosition - CGFloat(row) * sizeOfElement.height)
        shape.position = CGPointMake(xPos, verticalPosition - CGFloat(row) * heightOfLabelRow)
        shape.alpha = 1.0
        shape.size = image.size
        shape.zPosition = self.zPosition + 1000
        self.addChild(shape)
        
    }
    
    func  showMe(runAfter:()->()) {
        let actionMove = SKAction.moveTo(myTargetPosition, duration: 0.3)
        let alphaAction = SKAction.fadeOutWithDuration(0.5)
        let runAfterAction = SKAction.runBlock({runAfter()})
        myParent.parent!.addChild(self)
        
        myParent.runAction(alphaAction)
        self.runAction(SKAction.sequence([actionMove, runAfterAction]))
    }
    
    func reDrawWhenChanged(columnWidths: [CGFloat], rows: Int) {
        if rows == self.rows {
            return
        }
        self.columns = columnWidths.count
        self.rows = rows
        reDraw()
    }
        
    func reDraw() {
        for _ in 0..<children.count {
            self.children.last!.removeFromParent()
        }
        self.sizeOfElement = CGSizeMake(size.width / CGFloat(columns), size.height / CGFloat(rows))
        myHeight = heightOfLabelRow * CGFloat(rows) + heightOfMyHeadRow

        self.size = CGSizeMake(self.size.width, myHeight)
        self.texture = SKTexture(image: drawTableImage(size, columnWidths: columnWidths, columns: columns, rows: rows))
//        let myTargetPosition = CGPointMake(parentView!.frame.size.width / 2, parentView!.frame.size.height / 2)
        let pSize = myParent.parent!.scene!.size
        myTargetPosition = CGPointMake(pSize.width / 2, pSize.height / 2)
        self.position = myTargetPosition
        myStartPosition = CGPointMake(pSize.width, pSize.height / 2)
        self.removeFromParent()
        showMyImagesAndHeader(DrawImages.getGoBackImage(CGSizeMake(myImageSize, myImageSize)), position: 20, name: goBackImageName)
        myParent.parent!.addChild(self)
        
    }
    
    func getColumnRowOfElement(name: String)->(column:Int, row:Int) {        
        let components = name.componentsSeparatedByString(separator)
        let column = Int(components[0])
        let row = Int(components[1])
        return (column: column!, row: row!)
    }
    
    func drawTableImage(size: CGSize, columnWidths:[CGFloat], columns: Int, rows: Int) -> UIImage {
        let opaque = false
        let scale: CGFloat = 1

//        let heightOfTableRow = size.height -  / CGFloat(rows)
        
        
        let w = size.width / 100
        
        //let mySize = CGSizeMake(size.width - 20, size.height)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, myHeight), opaque, scale)
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextBeginPath(ctx)
        CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)

        CGContextBeginPath(ctx)
        CGContextSetLineJoin(ctx, .Round)
        CGContextSetLineCap(ctx, .Round)
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)

        let roundRect = UIBezierPath(roundedRect: CGRectMake(0, 0, size.width, size.height), byRoundingCorners:.AllCorners, cornerRadii: CGSizeMake(size.width * 0.02, size.height * 0.02)).CGPath
        CGContextAddPath(ctx, roundRect)
        CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor);
        CGContextFillPath(ctx)
        var points = [CGPoint]()
        CGContextStrokePath(ctx)
        
        points.removeAll()
        points = [
            CGPointMake(w * 0, heightOfMyHeadRow),
            CGPointMake(w * 100, heightOfMyHeadRow)
        ]
        CGContextSetLineWidth(ctx, 0.1)
        CGContextSetStrokeColorWithColor(ctx, UIColor.darkGrayColor().CGColor)
        CGContextAddLines(ctx, points, points.count)
        CGContextStrokePath(ctx)
        
        
        
        CGContextBeginPath(ctx)
        
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
        CGContextFillPath(ctx);
        CGContextStrokePath(ctx)
        
        CGContextSetLineWidth(ctx, 0.2)
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
//        CGContextStrokeRect(ctx, CGRectMake(5, 5, mySize.width, mySize.height))
        
        var yPos:CGFloat = (size.height - heightOfMyHeadRow) / CGFloat(rows) + heightOfMyHeadRow
        CGContextBeginPath(ctx)
        
        if rows > 1 {
            for _ in 0..<rows - 1 {
                let p1 = CGPointMake(5, yPos)
                let p2 = CGPointMake(size.width - 5, yPos)
                yPos += heightOfLabelRow
                CGContextMoveToPoint(ctx, p1.x, p1.y)
                CGContextAddLineToPoint(ctx, p2.x, p2.y)
            }
        }
        CGContextStrokePath(ctx)
        
        
        
        if showVerticalLines {
            CGContextBeginPath(ctx)
            var xProcent = CGFloat(0)
            for column in 0..<columnWidths.count {
                xProcent += columnWidths[column]
                let p1 = (CGPointMake(w * xProcent, heightOfMyHeadRow))
                let p2 = (CGPointMake(w * xProcent, myHeight))
                CGContextMoveToPoint(ctx, p1.x, p1.y)
                CGContextAddLineToPoint(ctx, p2.x, p2.y)
            }
            CGContextStrokePath(ctx)
        }
        
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            return image
        }
        
        return UIImage()
    }
    
    func checkTouches(touches: Set<UITouch>, withEvent event: UIEvent?)->(MyEvents, Int) {
        let touchLocation = touches.first!.locationInNode(self)
        let touchesEndedAtNode = nodeAtPoint(touchLocation)
        let row = -Int((touchLocation.y - self.size.height / 2) / heightOfLabelRow)
        if touchesEndedAtNode is SKSpriteNode && (touchesEndedAtNode as! SKSpriteNode).name == goBackImageName {
            return (.GoBackEvent,row)
        }
        return (.NoEvent, row)
        
        
    }
    
    func scrollView(delta: CGFloat) {
        self.position.y += delta
    }
    func setMyDeviceSpecialConstants() {
        
    }
    
    func setMyDeviceConstants() {
        
        switch GV.deviceConstants.type {
        case .iPadPro12_9:
            heightOfLabelRow = CGFloat(40)
            fontSize = CGFloat(30)
            myImageSize = CGFloat(30)
        case .iPad2:
            heightOfLabelRow = CGFloat(40)
            fontSize = CGFloat(30)
            myImageSize = CGFloat(25)
        case .iPadMini:
            heightOfLabelRow = CGFloat(40)
            fontSize = CGFloat(30)
            myImageSize = CGFloat(30)
        case .iPhone6Plus:
            heightOfLabelRow = CGFloat(40)
            fontSize = CGFloat(25)
            myImageSize = CGFloat(23)
        case .iPhone6:
            heightOfLabelRow = CGFloat(40)
            fontSize = CGFloat(25)
            myImageSize = CGFloat(20)
        case .iPhone5:
            heightOfLabelRow = CGFloat(35)
            fontSize = CGFloat(28)
            myImageSize = CGFloat(15)
        case .iPhone4:
            heightOfLabelRow = CGFloat(35)
            fontSize = CGFloat(20)
            myImageSize = CGFloat(15)
        default:
            break
        }
        
    }
    

   
}
