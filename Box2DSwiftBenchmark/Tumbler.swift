/**
Copyright (c) 2015 - Yohei Yoshihara

This software is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software
in a product, an acknowledgment in the product documentation would be
appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.
*/
import Foundation
import Box2D

let count = 50
var world: b2World!
var m_joint: b2RevoluteJoint!
var m_count = 0

func tumblerSwift_prepare()
{
  world = b2World(gravity: b2Vec2(0, -10))
  
  var ground: b2Body! = nil
  b2Locally {
    let bd = b2BodyDef()
    ground = world.createBody(bd)
  }
  
  b2Locally {
    var bd = b2BodyDef()
    bd.type = b2BodyType.dynamicBody
    bd.allowSleep = false
    bd.position.set(0.0, 10.0)
    let body = world.createBody(bd)
    
    var shape = b2PolygonShape()
    shape.setAsBox(halfWidth: 0.5, halfHeight: 10.0, center: b2Vec2( 10.0, 0.0), angle: 0.0)
    body.createFixture(shape: shape, density: 5.0)
    shape.setAsBox(halfWidth: 0.5, halfHeight: 10.0, center: b2Vec2(-10.0, 0.0), angle: 0.0)
    body.createFixture(shape: shape, density: 5.0)
    shape.setAsBox(halfWidth: 10.0, halfHeight: 0.5, center: b2Vec2(0.0, 10.0), angle: 0.0)
    body.createFixture(shape: shape, density: 5.0)
    shape.setAsBox(halfWidth: 10.0, halfHeight: 0.5, center: b2Vec2(0.0, -10.0), angle: 0.0)
    body.createFixture(shape: shape, density: 5.0)
    
    var jd = b2RevoluteJointDef()
    jd.bodyA = ground
    jd.bodyB = body
    jd.localAnchorA.set(0.0, 10.0)
    jd.localAnchorB.set(0.0, 0.0)
    jd.referenceAngle = 0.0
    jd.motorSpeed = 0.05 * b2_pi
    jd.maxMotorTorque = 1e8
    jd.enableMotor = true
    m_joint = world.createJoint(jd) as! b2RevoluteJoint
  }
  
  m_count = 0
}

func tumblerSwift_step()
{
  if m_count < count {
    var bd = b2BodyDef()
    bd.type = b2BodyType.dynamicBody
    bd.position.set(0.0, 10.0)
    var body = world.createBody(bd)
    
    var shape = b2PolygonShape()
    shape.setAsBox(halfWidth: 0.125, halfHeight: 0.125)
    body.createFixture(shape: shape, density: 1.0)
    
    ++m_count
  }
  world.step(timeStep: 1.0 / 60.0, velocityIterations: 8, positionIterations: 3)
}

func tumblerSwift_end()
{
  world = nil
}
