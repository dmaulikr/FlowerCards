//
//  JGXLine.swift
//  JFlowers
//
//  Created by Jozsef Romhanyi on 13.09.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import SpriteKit

class JGXLine {
    // equation of the line:
    // b = (y1-y2) / (x1-x2)
    // y = a + bx --> a = y - bx
    // for vertical lines x = a
    
    enum LineType: Int {
        case normal = 0, vertical, horizontal
    }

    struct Line {
        
        var fromPoint: CGPoint
        var toPoint: CGPoint
        var fromToColumnRow: FromToColumnRow?
        var lineType: LineType
        let b: CGFloat
        let a: CGFloat
        init (from: CGPoint, to: CGPoint){
            fromPoint = from
            toPoint = to
            let offset = toPoint - fromPoint
            if from.x == to.x {
                lineType = .vertical
                b = 0
                a = fromPoint.x
            } else if from.y == to.y {
                lineType = .horizontal
                b = 0
                a = 0
            }
            else {
                lineType = .normal
                b = (offset.y) / (offset.x)
                a = fromPoint.y - b * fromPoint.x
            }
        }
    }
    
    let speed = 0.002
    var line: Line
    var duration: Double = 0
    
    var frameLines = [Line]()
    var mirrorAxis: LineType = .horizontal

    let frame: CGRect
    let lineSize: CGFloat
    let indexLV = 0 // left Vertical
    let indexUH = 1 // upper horizontal
    let indexRV = 2 // right vertical
    let indexBH = 3 // bottom horizontal
//    var delegate: JGXLineDelegate?
    
    init(fromPoint: CGPoint, toPoint: CGPoint, inFrame: CGRect, lineSize: CGFloat) { //, delegate: JGXLineDelegate?) {
        self.line = Line(from: fromPoint, to: toPoint)
        self.frame = inFrame
        self.lineSize = lineSize
//        self.delegate = delegate
        
        var lineOnFrame = Line( from:   CGPoint(x: inFrame.origin.x + lineSize / 2, y: inFrame.origin.y + lineSize / 2),
                                to:     CGPoint(x: inFrame.origin.x + lineSize / 2, y: inFrame.origin.y + inFrame.height - lineSize / 2))
        frameLines.append(lineOnFrame)
        lineOnFrame = Line(     from:   CGPoint(x: inFrame.origin.x + lineSize / 2, y: inFrame.origin.y + inFrame.height - lineSize / 2),
                                to:     CGPoint(x: inFrame.origin.x + inFrame.width - lineSize / 2, y: inFrame.origin.y + inFrame.height - lineSize / 2))
        frameLines.append(lineOnFrame)
        lineOnFrame = Line(     from:   CGPoint(x: inFrame.origin.x + inFrame.width - lineSize / 2, y: inFrame.origin.y + inFrame.height - lineSize / 2),
                                to:     CGPoint(x: inFrame.origin.x + inFrame.width - lineSize / 2, y: inFrame.origin.y + lineSize / 2))
        frameLines.append(lineOnFrame)
        lineOnFrame = Line(     from:   CGPoint(x: inFrame.origin.x + inFrame.width - lineSize / 2, y: inFrame.origin.y + lineSize / 2),
                                to:     CGPoint(x: inFrame.origin.x + lineSize / 2, y: inFrame.origin.y + lineSize / 2))
        frameLines.append(lineOnFrame)
        for index in 0..<frameLines.count {
            let (hasIntersection, intersectionPoint) =  findIntersectionWithFrame(index)
            if hasIntersection {
                line.toPoint = intersectionPoint
                switch frameLines[index].lineType {
                case .vertical:
                    mirrorAxis = .horizontal
                default:
                    mirrorAxis = .vertical
                }
            } 
        }
        let offset = line.toPoint - line.fromPoint
        duration = Double(offset.length()) * speed
//        if let myDelegate = delegate {
//            line.fromToColumnRow = myDelegate.findColumnRowDelegateFunc(fromPoint, toPoint: toPoint)
//        }

    }
    
    func findIntersectionWithFrame(_ index: Int)->(Bool,CGPoint) {
        // to find the intersection point, use the next 2 equations:
        // y = a1 + b1 * x
        // y = a2 + b2 * x
        // a1 + b1 * x = a2 + b2 * x
        // a1 - a2 = (b2 - b1) * x
        // x = (a1 - a2) / (b2 - b1)
        // y = a1 + b1 * (a1 - a2) / (b2 - b1)

        var intersectionPoint = CGPoint.zero
        var hasIntersection = false

        let checkLine = frameLines[index]
        
        
        switch (self.line.lineType, checkLine.lineType) {
            case (.vertical, .vertical):
                hasIntersection = false
            
            case (.vertical, .horizontal):
                if self.line.fromPoint.y > self.line.toPoint.y && index == indexBH || self.line.fromPoint.y < self.line.toPoint.y && index == indexUH {
                    hasIntersection = true
                    intersectionPoint = CGPoint(x: self.line.fromPoint.x, y: checkLine.fromPoint.y)
                }
            case (.horizontal, .horizontal):
                hasIntersection = false
            
            case (.horizontal, .vertical):
                if self.line.fromPoint.x > self.line.toPoint.x && index == indexLV || self.line.fromPoint.x < self.line.toPoint.x && index == indexRV {
                    hasIntersection = true
                    intersectionPoint = CGPoint(x: self.line.fromPoint.y, y: checkLine.fromPoint.x)
                }
            case (.normal, .vertical):
                // for Vertical line x is fix
                // y = a + bx
                intersectionPoint.x = checkLine.fromPoint.x
                intersectionPoint.y = self.line.a + self.line.b * intersectionPoint.x
                let distanceFromPoint =  (intersectionPoint - self.line.fromPoint).length()
                let distanceToPoint =  (intersectionPoint - self.line.toPoint).length()
                if distanceFromPoint > distanceToPoint  && intersectionPoint.y >= self.frame.origin.y && intersectionPoint.y <= self.frame.origin.y + self.frame.height {
                    hasIntersection = true
                }
            case (.normal, .horizontal):
                // for Horizontall line y is fix
                // x = (y - a) / b
                intersectionPoint.y = checkLine.fromPoint.y
                intersectionPoint.x = (intersectionPoint.y - self.line.a) / self.line.b
                let distanceFromPoint =  (intersectionPoint - self.line.fromPoint).length()
                let distanceToPoint =  (intersectionPoint - self.line.toPoint).length()
                

                if distanceFromPoint > distanceToPoint && intersectionPoint.x >= self.frame.origin.x && intersectionPoint.x <= self.frame.origin.x + self.frame.width {
                    hasIntersection = true
                }
            
                
            default: hasIntersection = false
        }
        return (hasIntersection, intersectionPoint)
    }
    
    func createMirroredLine()->JGXLine {
        //var helpLine = JGXLine(fromPoint: self.line.toPoint, toPoint: self.line.fromPoint, inFrame: self.frame, lineSize: self.lineSize)
        let offset = self.line.toPoint - self.line.fromPoint
        var mirroredPoint = self.line.fromPoint
        switch mirrorAxis {
        case .vertical:
            mirroredPoint.x = self.line.toPoint.x + offset.x
        case .horizontal:
            mirroredPoint.y = self.line.toPoint.y + offset.y
        default:
            mirroredPoint.y = self.line.toPoint.y + offset.y
        }
        
        let mirroredOffset = mirroredPoint - line.toPoint
        
        let mirroredLine = JGXLine(fromPoint: self.line.toPoint, toPoint: self.line.toPoint + mirroredOffset.normalized(), inFrame: self.frame, lineSize: self.lineSize) //, delegate: delegate)
        return mirroredLine
    }
}
