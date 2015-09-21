//
//  RandomizationScene.swift
//  GameplayKitSandbox
//
//  Created by Tatsuya Tobioka on 2015/09/20.
//  Copyright © 2015年 tnantoka. All rights reserved.
//

import UIKit

import SpriteKit
import GameplayKit

class RandomizationScene: ExampleScene {

    let degrees = [Int](0...72).map { $0 * (360 / 72) }
    let examples = [
        [GKARC4RandomSource.self, SKColor.cyanColor(), "ARC4"],
        [GKLinearCongruentialRandomSource.self, SKColor.magentaColor(), "LinearCongruential"],
        [GKMersenneTwisterRandomSource.self, SKColor.yellowColor(), "MersenneTwister"],
    ]

    var distributionIndex = 0 {
        didSet {
            removeAllChildren()
            createSceneContents()
        }
    }
    var distributions = [
        GKRandomDistribution.self,
        GKGaussianDistribution.self,
        GKShuffledDistribution.self,
    ]

    override func createSceneContents() {
        for (i, example) in examples.enumerate() {
            let type = example[0] as! GKRandomSource.Type
            let source = type.sharedRandom()

            let color = example[1] as! UIColor
            let radius = CGRectGetWidth(frame) * (0.4 - CGFloat(i) * 0.05)

            draw(distribution(source), color: color, radius: radius)

            let text = "● \(example[2] as! String)"
            createLabel(text, color: color, order: i)
        }
    }

    func distribution(source: GKRandomSource) -> GKRandomDistribution {
        return distributions[distributionIndex].init(randomSource: source, lowestValue: 0, highestValue: degrees.count - 1)
    }

    func draw(distribution: GKRandomDistribution, color: SKColor, radius: CGFloat) {
        let circle = SKShapeNode(circleOfRadius: radius)
        circle.position = center
        addChild(circle)

        for _ in 0..<degrees.count {
            let degree = Float(degrees[distribution.nextInt()])
            let radian = CGFloat(GLKMathDegreesToRadians(degree))
            let x = center.x + radius * sin(radian)
            let y = center.y + radius * cos(radian)
            let circle = SKShapeNode(circleOfRadius: 3.0)
            circle.position = CGPointMake(x, y)
            circle.fillColor = color
            circle.strokeColor = SKColor.clearColor()
            addChild(circle)
        }
    }
}
