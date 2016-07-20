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
    private init(){
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
    private var _heartBeatObjects = [WithHeartBeat]()
    private var _guidCounter:Guid = 0
    
    var displayMessageHandler = [DisplayMessageDelegate]()
    var userStatusUpdateHandler = [UserStatusUpdateDelegate]()
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
    
        
    static func regHeartBeat(ikb: WithHeartBeat)
    {
        instance.registerHeartbeatObject(ikb)
    }
    
    private func heartBeatArrayContains(ob: WithHeartBeat ) -> (isContain: Bool, index: Int?) {
        let oob = ob as! KObject
        let index = _heartBeatObjects.indexOf({
            e in
            let element = e as! KObject
            return element == oob
        })
        return (index != nil, index)
    }
    
    private func registerHeartbeatObject(ob: WithHeartBeat)
    {
        assert(ob is KObject)
        if heartBeatArrayContains(ob).isContain == false {
            _heartBeatObjects.append(ob)
        }
    }
    
    static func unregHeartBeat(ikb: WithHeartBeat){
        instance.unregisterHeartBeatObject(ikb)
    }
    
    private func unregisterHeartBeatObject(ob: WithHeartBeat){
        assert(ob is KObject)
        guard let index = heartBeatArrayContains(ob).index else {
            return
        }
        _heartBeatObjects.removeAtIndex(index)
    }
    
    func HeartBeat() {
        for ob in _heartBeatObjects {
            ob.makeOneHeartBeat()//注意，该过程有可能会删除ob
        }
    }
    
    static func willUpdateUserInfo(){
        for delegate in instance.userStatusUpdateHandler{
            delegate.statusWillUpdate?()
        }
    }
    
    static func didUpdateUserInfo(){
        for delegate in instance.userStatusUpdateHandler{
            delegate.statusDidUpdate()
        }
    }
    
    static func broadcast(msg: String) {
        if msg.isEmpty { return }
        if msg.isOnlyEmptySpacesAndNewLineCharacters() { return }
        //let timeStamp = formatDate(NSDate())
        //add carriage return
        var displayMsg = msg.stringByReplacingOccurrencesOfString("<br>", withString: "\n")
        displayMsg = displayMsg.stringByReplacingOccurrencesOfString("\r", withString: "")
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
    
    static func didUpdateRoomInfo(room:KRoom, ent:KEntity? = nil, type:RoomInfoUpdateType = .NewRoom){
        for delegate in instance.roomInfoHandler {
            delegate.processRoomInfo(room, entity: ent, type: type)
        }
    }
       
}