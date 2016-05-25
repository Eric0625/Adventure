//
//  GlobalFunctions.swift
//  Adventure
//
//  Created by 苑青 on 16/4/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation


func randomInt(upper:Int)->Int{
    assert(upper >= 0)
    return Int(arc4random_uniform(UInt32(upper)))
}

func deepCopy<T:KObject>(data:[T]) -> [T] {
    return data.map{
        T(k: $0)
    }
}

func deepCopy<T:KObject>(data:Set<T>) -> Set<T> {
    return Set(data.map({T(k: $0)}))
}


func DEBUG(message:Any){
    debugPrint(message)
}

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    //formatter.dateStyle = .NoStyle
    formatter.timeStyle = .ShortStyle
    return formatter
}()

func formatDate(date: NSDate) -> String { return dateFormatter.stringFromDate(date) }

func tellPlayer(msg: String, usr: KEntity){
    if usr is KUser {
        TheWorld.broadcast(msg)
    }
}

func notifyFail(msg: String, to chr: KEntity) -> Bool {
    if chr is KUser {
        TheWorld.broadcast(KColors.ChatMsg + msg + KColors.NOR)
    }
    return false
}

func tellRoom(msg:String, room: KEntity){
    var acturalRoom = room
    if !(room is KRoom){
        if room.environment == nil { return }
        acturalRoom = room.environment!//有时候消息来自房间内的容器里的物体
    }
    guard let inventory = acturalRoom._entities else { return }
    for ent in inventory {
        tellPlayer(KColors.ChatMsg + msg + KColors.NOR, usr: ent)
    }
}

func rankRespect(c: KCreature) -> String{
    switch c.gender {
    case .中性:
        return "大侠"
    case .女性:
        switch c.age {
        case 0...19:
            return "小姑娘"
        case 20...49:
            return "姑娘"
        default:
            return "婆婆"
        }
    case .男性:
        switch c.age {
        case 0...19:
            return "小兄弟"
        case 20...49:
            return "壮士"
        default:
            return "老爷子"
        }
    }
}

func rankRude (c: KCreature) -> String{
    switch c.gender {
    case .中性:
        return "狗东西"
    case .女性:
        switch c.age {
        case 0...19:
            return "小贱人"
        case 20...49:
            return "贱人"
        default:
            return "死老太婆"
        }
    case .男性:
        switch c.age {
        case 0...19:
            return "小王八蛋"
        case 20...49:
            return "臭贼"
        default:
            return "老匹夫"
        }
    }
}

private let _chineseNumber = [ "零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" ]
private let _chineseDigit = ["零", "十", "百", "千", "万", "亿", "兆" ]
private let _chineseTianGan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸" ]
private let _chineseDiZhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥" ]
func toChineseNumber(number: Int) -> String {
    var delta:Int, deltaDigit:Int
    var n2:Int
    var str:String
    if number < 0 { return "负" + toChineseNumber(-number) }
    if number < 11 {return _chineseNumber[number] }
    if number > 99999 {
        if number <= 99999999 {
            n2 = number / 10000
            str = toChineseNumber(n2) + "万"
            delta = number - n2 * 10000
            if delta == 0 { return str }
            
            if delta < 1000 { str += "零" }
            return str + toChineseNumber(delta)
        }
        n2 = number / 100000000
        str = toChineseNumber(n2) + "亿"
        delta = number - n2 * 100000000
        if delta == 0  { return str }
        if delta < 10000000 { str += "零" }
        return str + toChineseNumber(delta)
    }
    let digit = Int(log10(Double(number)))
    let k = Int(pow(10, Double(digit)))
    let i = number / k
    delta = number - i * k
    if delta == 0 { return _chineseNumber[i] + _chineseDigit[digit] }
    deltaDigit = Int(log10(Double(delta)))
    if digit - deltaDigit > 1 {
        return _chineseNumber[i] + _chineseDigit[digit] + "零" + toChineseNumber(delta)
    } else {
        return _chineseNumber[i] + _chineseDigit[digit] + toChineseNumber(delta)
    }
}

private let _perLevelMale =
    [
        KColors.BLU + "眉歪眼斜，瘌头癣脚，不象人样。" + KColors.NOR,
        KColors.BLU + "呲牙咧嘴，黑如锅底，奇丑无比。" + KColors.NOR,
        KColors.BLU + "面如桔皮，头肿如猪，让人不想再看第二眼。" + KColors.NOR,
        KColors.HIB + "贼眉鼠眼，身高三尺，宛若猴状。" + KColors.NOR,
        KColors.HIB + "肥头大耳，腹圆如鼓，手脚短粗，令人发笑。" + KColors.NOR,
        KColors.nor + "面颊凹陷，瘦骨伶仃，可怜可叹。" + KColors.NOR,
        KColors.nor + "傻头傻脑，痴痴憨憨，看来倒也老实。" + KColors.NOR,
        KColors.nor + "相貌平平，不会给人留下什么印象。" + KColors.NOR,
        KColors.YEL + "膀大腰圆，满脸横肉，恶形恶相。" + KColors.NOR,
        KColors.YEL + "腰圆背厚，面阔口方，骨格不凡。" + KColors.NOR,
        KColors.Red + "眉目清秀，端正大方，一表人才。" + KColors.NOR,
        KColors.Red + "双眼光华莹润，透出摄人心魄的光芒。" + KColors.NOR,
        KColors.HIY + "举动如行云游水，独蕴风情，吸引所有异性目光。" + KColors.NOR,
        KColors.HIY + "双目如星，眉梢传情，所见者无不为之心动。" + KColors.NOR,
        KColors.HIR + "粉面朱唇，身姿俊俏，举止风流无限。" + KColors.NOR,
        KColors.HIR + "丰神如玉，目似朗星，令人过目难忘。" + KColors.NOR,
        KColors.Purple + "面如美玉，粉妆玉琢，俊美不凡。" + KColors.NOR,
        KColors.Purple + "飘逸出尘，潇洒绝伦。" + KColors.NOR,
        KColors.Purple + "丰神俊朗，长身玉立，宛如玉树临风。" + KColors.NOR,
        KColors.HIP + "神清气爽，骨格清奇，宛若仙人。" + KColors.NOR,
        KColors.HIP + "一派神人气度，仙风道骨，举止出尘。" + KColors.NOR,
]

private let _perLevelFemale = [
    KColors.BLU +  "丑如无盐，状如夜叉。" + KColors.NOR,
    KColors.BLU +  "歪鼻斜眼，脸色灰败，直如鬼怪一般。" + KColors.NOR,
    KColors.BLU +  "八字眉，三角眼，鸡皮黄发，让人一见就想吐。" + KColors.NOR,
    KColors.HIB + "眼小如豆，眉毛稀疏，手如猴爪，不成人样。" + KColors.NOR,
    KColors.HIB + "一嘴大暴牙，让人一看就没好感。" + KColors.NOR,
    KColors.nor + "满脸疙瘩，皮色粗黑，丑陋不堪。" + KColors.NOR,
    KColors.nor + "干黄枯瘦，脸色腊黄，毫无女人味。" + KColors.NOR,
    KColors.YEL + "身材瘦小，肌肤无光，两眼无神。" + KColors.NOR,
    KColors.YEL + "虽不标致，倒也白净，有些动人之处。" + KColors.NOR,
    KColors.Red + "肌肤微丰，雅淡温宛，清新可人。" + KColors.NOR,
    KColors.Red + "鲜艳妍媚，肌肤莹透，引人遐思。" + KColors.NOR,
    KColors.HIR + "娇小玲珑，宛如飞燕再世，楚楚动人。" + KColors.NOR,
    KColors.HIR + "腮凝新荔，肌肤胜雪，目若秋水。" + KColors.NOR,
    KColors.HIW + "粉嫩白至，如芍药笼烟，雾里看花。" + KColors.NOR,
    KColors.HIW + "丰胸细腰，妖娆多姿，让人一看就心跳不已。" + KColors.NOR,
    KColors.Purple + "娇若春花，媚如秋月，真的能沉鱼落雁。" + KColors.NOR,
    KColors.Purple + "眉目如画，肌肤胜雪，真可谓闭月羞花。" + KColors.NOR,
    KColors.Purple + "气质美如兰，才华馥比山，令人见之忘俗。" + KColors.NOR,
    KColors.HIP + "灿若明霞，宝润如玉，恍如神妃仙子。" + KColors.NOR,
    KColors.HIP + "美若天仙，不沾一丝烟尘。" + KColors.NOR,
    KColors.HIP + "宛如" + KColors.HIW + "玉雕冰塑"  + KColors.NOR + "，似梦似幻，已不再是凡间人物。" + KColors.NOR
]
func getPerMsg(chr: KCreature) -> String {
    let per = chr.per
    switch chr.gender {
    case .中性:
        break
    case .女性:
        switch per {
        case 0...9:
            break
        case 10...30:
            return _perLevelFemale[per - 10]
        default:
            return _perLevelFemale[20]
        }
    case .男性:
        switch per {
        case 0...9:
            break
        case 10...30:
            return _perLevelMale[per - 10]
        default:
            return _perLevelMale[20]
        }
    }
    return "长得怎样你没什么概念。"
}

/// 格式化消息，A为第一个人，D为第二个人，R代表尊称，r代表蔑称，l代表第二个人的肢体，W代表第一个人的武器，w代表第二个人的武器
/// - parameters:
///   - info:消息体
func processInfomation( info: String, attacker: KCreature? = nil, defenser: KCreature? = nil, limbDesc:String = "") -> String{
    var message = info
    if let attacker = attacker {
        let attackerName = attacker is KUser ? "你" : attacker.name
        message = message.stringByReplacingOccurrencesOfString("$AR", withString: rankRespect(attacker)).stringByReplacingOccurrencesOfString("$Ar", withString: rankRude(attacker)).stringByReplacingOccurrencesOfString("$A", withString: attackerName)
        if let wp = attacker.getEquippedItem(EquipPosition.RightHand) as? KWeapon {
            message = message.stringByReplacingOccurrencesOfString("$W", withString: wp.name)
        } else {message = message.stringByReplacingOccurrencesOfString("$W", withString: "手指")}
    }
    if let defenser = defenser {
        let denfenserName = defenser is KUser ? "你" : defenser.name
        if let wp = defenser.getEquippedItem(EquipPosition.RightHand) as? KWeapon {
            message = message.stringByReplacingOccurrencesOfString("$w", withString: wp.name)
        }
        message = message.stringByReplacingOccurrencesOfString("$DR", withString: rankRespect(defenser))
        message = message.stringByReplacingOccurrencesOfString("$Dr", withString: rankRude(defenser))
        message = message.stringByReplacingOccurrencesOfString("$D", withString: denfenserName)
    }
    if !limbDesc.isEmpty { message = message.stringByReplacingOccurrencesOfString("$l", withString: limbDesc)}
    return message
}


func getStatusMsg(chr:KCreature, type: DamageType) -> String
{
    let ratio = chr.lifeProperty[type]! * 100 / chr.lifePropertyMax[type]!
    var msg = ""
    switch ratio {
    case 100:
        msg = KColors.HIG + "（$D看起来充满活力，一点也不累。）\n" + KColors.NOR
    case 96..<100:
        msg =  KColors.HIG + "（$D似乎有些疲惫，但是仍然十分有活力。）\n" + KColors.NOR
    case 91...95:
        msg = KColors.HIY + "（$D看起来可能有些累了。）\n" + KColors.NOR
    case 81...90:
        msg =  KColors.HIY + "（$D动作似乎开始有点不太灵光，但是仍然有条不紊。）\n" + KColors.NOR
    case 61...80:
        msg =  KColors.HIY + "（$D气喘嘘嘘，看起来状况并不太好。）\n" + KColors.NOR
    case 41...60:
        msg =  KColors.HIR + "（$D似乎十分疲惫，看来需要好好休息了。）\n" + KColors.NOR
    case 31...40:
        msg =  KColors.HIR + "（$D已经一副头重脚轻的模样，正在勉力支撑着不倒下去。）\n" + KColors.NOR
    case 21...30:
        msg =  KColors.HIR + "（$D看起来已经力不从心了。）\n" + KColors.NOR
    case 11...20:
        msg =  KColors.Red + "（$D摇头晃脑、歪歪斜斜地站都站不稳，眼看就要倒在地上。）\n" + KColors.NOR
    default:
        msg =  KColors.Red + "（$D已经犹如风中残烛，随时都可能断气。）\n" + KColors.NOR
    }
    return processInfomation(msg, attacker: nil, defenser: chr)
}

func getDamageMsg(damage:Int, type: DamageActionType) -> String {
    if damage == 0 { return "结果没有造成任何伤害。\n" }
    var str = ""
    switch type {
    case .Ci:
        if (damage < 10) { return "结果只是轻轻地刺破$D的皮肉。\n" }
        else if (damage < 20) { return "结果在$D的$l刺出一个创口。\n" }
        else if (damage < 40) { return "结果「噗」地一声刺入了$D的$l寸许！\n" }
        else if (damage < 80) { return "结果「噗」地一声刺进$D的$l，使$D不由自主地退了步！\n" }
        else if (damage < 160) { return "结果「噗嗤」地一声，$W已在$D的$l刺出一个血肉模糊的血窟窿！\n" }
        else { return "结果只听见$D一声惨嚎，$W已在$D的$l对穿而出，鲜血溅得满地！\n" }
    case .Za:
        if (damage < 10) { return "结果只是轻轻地碰到，等于给$D搔了一下痒。\n" }
        else if (damage < 20) { return "结果在$D的$l砸出一个小鼓包。\n" }
        else if (damage < 40) { return "结果砸个正着，$D的$l登时肿了一块老高！\n" }
        else if (damage < 80) { return "结果砸个正着，$D闷哼一声显然吃了不小的亏！\n" }
        else if (damage < 120) { return "结果「砰」地一声，$D疼得连腰都弯了！\n" }
        else if (damage < 160) { return "结果这一下「轰」地一声砸得$D眼冒金星，差一点摔倒！\n" }
        else if (damage < 240) { return "结果重重地砸中，$D眼前一黑，「哇」地一声吐出一口鲜血！\n" }
        else { return "结果只听见「轰」地一声巨响，$D被砸得血肉模糊，惨不忍睹！\n" }
    case .Ge, .Zhua:
        if (damage < 10) { return "结果只是轻轻地划破$D的皮肉。\n" }
        else if (damage < 20) { return "结果在$D的$l划出一道细长的血痕。\n" }
        else if (damage < 40) { return "结果「嗤」地一声划出一道伤口！\n" }
        else if (damage < 80) { return "结果「嗤」地一声划出一道血淋淋的伤口！\n" }
        else if (damage < 160) { return "结果「嗤」地一声划出一道又长又深的伤口，溅得$N满脸鲜血！\n" }
        else { return "结果只听见$D一声惨嚎，$l被划出一道深及见骨的可怕伤口！\n" }
    case .Pi, .Kan:
        if (damage < 10) { return "结果只是在$D的皮肉上碰了碰，跟蚊子叮差不多。\n" }
        else if (damage < 20) { return "结果在$D的$l砍出一道细长的血痕。\n" }
        else if (damage < 40) { return "结果「噗嗤」一声劈出一道血淋淋的伤口！\n" }
        else if (damage < 80) { return "结果只听「噗」地一声，$D的$l被劈得血如泉涌，痛得$D咬牙切齿！\n" }
        else if (damage < 160) { return "结果「噗」地一声砍出一道又长又深的伤口，溅得$D满脸鲜血！\n" }
        else { return "结果只听见$D一声惨嚎，$l被劈开一道深及见骨的可怕伤口！\n" }
    case .Zhang,.Yu:
        if damage < 10 { return "结果只是轻轻地碰到，比拍苍蝇稍微重了点。\n" }
        else if damage < 20 { return "结果在$D的$l造成一处瘀青。\n" }
        else if damage < 40 { return "结果一击命中，$D的$l登时肿了一块老高！\n" }
        else if (damage < 80) { return "结果一击命中，$D闷哼了一声显然吃了不小的亏！\n" }
        else if (damage < 120) { return "结果「砰」地一声，$D退了两步！\n" }
        else if (damage < 160) { return "结果这一下「砰」地一声打得$D连退了好几步，差一点摔倒！\n" }
        else if (damage < 240) { return "结果重重地击中，$D「哇」地一声吐出一口鲜血！\n" }
        else { return "结果只听见「砰」地一声巨响，$D像一捆稻草般飞了出去！\n" }
    case .Nei:
        if (damage < 20) { return "结果在$D身上一触即逝，等于给$D搔了一下痒。\n" }
        else if (damage < 40) { return "结果$D晃了一晃，吃了点小亏。\n" }
        else if (damage < 80) { return "结果$D气息一窒，显然有点呼吸不畅！\n" }
        else if (damage < 120) { return "结果$D体内一阵剧痛，看起来内伤不轻！\n" }
        else if (damage < 160) { return "结果「嗡」地一声$D只觉得眼前一黑，双耳轰鸣不止！\n" }
        else { return "结果只听见「嗡」地一声巨响，$D「哇」地一声吐出一口鲜血，五脏六腑都错了位！\n" }
    case .Chou:
        if (damage < 10) { return "结果只是在$D的皮肉上碰了碰，跟蚊子叮差不多。\n" }
        else if (damage < 20) { return "结果在$D的$l抽出一道轻微的紫痕。\n" }
        else if (damage < 40) { return "结果「啪」地一声在$D的$l抽出一道长长的血痕！\n" }
        else if (damage < 80) { return "结果只听「啪」地一声，$D的$l被抽得皮开肉绽，痛得$p咬牙切齿！\n" }
        else if (damage < 160) { return "结果「啪」地一声爆响！这一下好厉害，只抽得$D皮开肉绽，血花飞溅！\n" }
        else { return "结果只听见$D一声惨嚎，$W重重地抽上了$D的$l，$D顿时血肉横飞，十命断了九条！\n" }
    case .Default:
        if (damage < 10) { str = "结果只是勉强造成一处轻微" }
        else if (damage < 20) { str = "结果造成轻微的" }
        else if (damage < 30) { str = "结果造成一处" }
        else if (damage < 50) { str = "结果造成一处严重" }
        else if (damage < 80) { str = "结果造成颇为严重的" }
        else if (damage < 120) { str = "结果造成相当严重的" }
        else if (damage < 170) { str = "结果造成十分严重的" }
        else if (damage < 230) { str = "结果造成极其严重的" }
        else { str = "结果造成非常可怕的严重" }
        str += "伤害";
        return str;
    }
    //switch (type)
    //{
    //    case "擦伤":
    //    case "抓伤":
    //    case "割伤":
    
    //        break;
    //    case "砍伤":
    //    case "劈伤":
    
    //        break;
    //    case "枪伤":
    //    case "刺伤":
    
    //        break;
    //    case "筑伤":
    //        if (damage < 10) return "结果只是轻轻地一触，在$n的皮肤上留下一点白痕。\n";
    //        else if (damage < 20) return "结果在$p的$l留下几道血痕。\n";
    //        else if (damage < 40) return "结果一下子筑中，$n的$l顿时出现几个血孔！\n";
    //        else if (damage < 80) return "结果一下子筑中，$n立刻血流如注！\n";
    //        else if (damage < 120) return "结果「哧」地一声，$n顿时鲜血飞溅！\n";
    //        else if (damage < 160) return "结果这一下「哧」地一声，$n被筑得浑身是血！\n";
    //        else return "结果「哧」重重地砸中，$n被筑得千疮白孔，血肉四处横飞！\n";
    //        break;
    //    case "掌伤":
    //    case "拳伤":
    //    case "瘀伤":
    //        break;
    //    case "撞伤":
    //    case "砸伤":
    
    //        break;
    //    case "震伤":
    //    case "内伤":
    //        break;
    //    case "鞭伤":
    //    case "抽伤":
    //        break;
    //    default:
    //        if (!type) type = "伤害";
    //        return str + type + "！\n";
    //}
}