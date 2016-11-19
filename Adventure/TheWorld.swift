//
//  TheWorld.swift
//  Adventure
//
//  Created by 苑青 on 16/4/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
import UIKit
typealias Guid = UInt32

//func deepCopy(data:[AnyObject]) -> [AnyObject] {
//    return data.map {item -> AnyObject in
//        if (item is KObject) {
//            return (item as! KObject).clone()
//        } else {
//            return item
//        }
//    }
//}


class TheWorld {
    //MARK: Singleton
    fileprivate init(){
        DEBUG("theworld inited")        
    }
    
    static var instance: TheWorld{
        struct Singleton {
            static let _instance = TheWorld()
        }
        return Singleton._instance
    }
    
    //MARK:variables
    static let ME = KUser()
    static let VOIDROOM = KVoidRoom()
    static let worldInterval:TimeInterval = 0.1//心跳的速度，单位为秒
    fileprivate var _heartBeatObjects = [WithHeartBeat]()
    fileprivate var _guidCounter:Guid = 0
    
    var displayMessageHandler = [DisplayMessageDelegate]()
    var statusUpdateHandler = [StatusUpdateDelegate]()
    var roomInfoHandler = [RoomInfoUpdateDelegate]()
    

    
    //MARK: functions
    
    /**
     用于生成游戏中唯一的类标识
     - parameters:
        - dfedfe: llll
    */
    class func newGuid() -> Guid{
        instance._guidCounter += 1
        if instance._guidCounter % 100 == 0 { print(instance._guidCounter) }
        return instance._guidCounter
    }
    
        
    class func regHeartBeat(_ ikb: WithHeartBeat)
    {
        instance.registerHeartbeatObject(ikb)
    }
    
    fileprivate func heartBeatArrayContains(_ ob: WithHeartBeat ) -> (isContain: Bool, index: Int?) {
        if let oob = ob as? KObject {
            let index = _heartBeatObjects.index(where: {
                e in
                let element = e as? KObject
                return element === oob
            })
            return (index != nil, index)
        }else  if let oob = ob as? NSObject {
            let index = _heartBeatObjects.index(where: {
                e in
                let element = e as? NSObject
                return element === oob
            })
            return (index != nil, index)
        }
       fatalError()
    }
    
    fileprivate func registerHeartbeatObject(_ ob: WithHeartBeat)
    {
        assert(ob is KObject || ob is NSObject)
        if heartBeatArrayContains(ob).isContain == false {
            _heartBeatObjects.append(ob)
        }
    }
    
    class func unregHeartBeat(_ ikb: WithHeartBeat){
        instance.unregisterHeartBeatObject(ikb)
    }
    
    fileprivate func unregisterHeartBeatObject(_ ob: WithHeartBeat){
        assert(ob is KObject || ob is NSObject)
        guard let index = heartBeatArrayContains(ob).index else {
            return
        }
        _heartBeatObjects.remove(at: index)
    }
    
    var lastCalled = Date()
    func HeartBeat() {
        let currentTime = Date()
        let interval = currentTime.timeIntervalSince(lastCalled)
        for ob in _heartBeatObjects {
            if ob is KObject  && interval < 1 {
                continue //如果两次heartbeat之间的时间小于1秒，并且是游戏物体，那么不进行心跳
            }
            ob.makeOneHeartBeat()//注意，该过程有可能会删除ob
        }
        //重置时间标记的行为应等到整个循环结束以后
        if interval >= 1 {
            lastCalled = currentTime
        }
    }
    
//    class func willUpdateUserInfo(){
//        for delegate in instance.userStatusUpdateHandler{
//            delegate.statusWillUpdate?()
//        }
//    }
    
    class func didUpdateUserInfo(_ c:KCreature, type:CreatureStatusUpdateType, info:AnyObject?){
        for delegate in instance.statusUpdateHandler{
            delegate.statusDidUpdate(c, type: type, information: info)
        }
    }
    
    class func broadcast(_ msg: String) {
        if msg.isEmpty { return }
        if msg.isBlank { return }
        //let timeStamp = formatDate(NSDate())
        //add carriage return
        var displayMsg = msg.replacingOccurrences(of: "<br>", with: "\n")
        displayMsg = displayMsg.replacingOccurrences(of: "\r", with: "")
//        displayMsg = displayMsg.stringByReplacingOccurrencesOfString("'", withString: "&quot;")
        var test = displayMsg
        while test.hasSuffix("</color>") {
            test = test.cutLeft(8)
        }
        if test.hasSuffix("\n") == false {
            displayMsg += "\n"
        }
        for delegate in instance.displayMessageHandler {
            delegate.displayMessage(displayMsg)
        }
    }
    
    class func didUpdateRoomInfo(_ room:KRoom, ent:KEntity? = nil, type:RoomInfoUpdateType = .newRoom){
        for delegate in instance.roomInfoHandler {
            delegate.processRoomInfo(room, entity: ent, type: type)
        }
    }
       
}
