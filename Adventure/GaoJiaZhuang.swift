//
//  Gao.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
extension TheRoomEngine {
    func generateGaoVillage() {
        var rd = KRoomDescribe(name: "土路",id: "高-土路1")
        rd.describe = "路上人不是很多，偶尔有几个过客．前方是一个小镇，镇上有一户高姓人家，却是这方圆百里土地的主人．附近的农民大多是靠租高家的田度日。\n"
        //rd.npcLists[NSStringFromClass(KLiBai_City.self)] = 1//李白
        rd.npcLists[NSStringFromClass(KOrdinaryPerson.self)] = 4//路人
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"街道" ,id: "高-街道1")
        rd.describe = "进到镇中人似乎多了些，也有些做小买卖的．青青的石板铺在路上，延续到镇的另一端。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"高家大门" ,id: "高-大门")
        rd.describe = "这里便是高家的大门口。北面一对黑木做的大门半开着，门上贴着一对门神。门左右摆着一对张牙舞爪的石狮，倒是清源县运来的正品。看门的老余头正打着瞌睡．听人讲高家近来有祸事，整个院子静悄悄的。\n"
        rd.roomClassString = NSStringFromClass(KGaoGateRoom.self)
        
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"街道" ,id: "高-街道2")
        rd.describe = "一条石板小路，刚下过雨，路上看起来还满干净的。一些乡下人挑着自己种的蔬菜到镇里卖，人不是很多，吆喝声传出很远，在镇子里回荡。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"街道" ,id: "高-街道3")
        rd.describe = "周围有一些店铺，店家为了抢生意，把东西都摆到了街上。把一条本来就不宽的石街占了大半．这里的人也显的较多，大多是些乡下来的，来买上些日常用品。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"土路" ,id: "高-土路2")
        rd.describe = "周围是一片蹈田，一些农夫在田里赶着牲口耕种。西边望去有一座山，雾气蒙蒙，看不清楚。东边是小镇，也是方圆几十里最为繁华的地方．镇虽不大，但柴米油盐样样不缺。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"土路" ,id: "高-土路3")
        rd.describe = "周围是一片蹈田，一些农夫在田里赶着牲口耕种．还有一些孩子在田地里玩耍．远处的村落隐约而见，炊烟饶饶，一幅天下太平的景象。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"稻田" ,id: "高-稻田1")
        rd.describe = "稻田里村民们正在耕种着．一片一片的农田连结成网，小沟小渠密布其中。\n"
        rd.npcLists[NSStringFromClass(KGaoFarmer.self)] = randomInt(3)
        rd.npcLists[NSStringFromClass(KGaoNiu.self)] = 1
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"稻田" ,id: "高-稻田2")
        rd.describe = "稻田里村民们正在耕种着．一片一片的农田连结成网，小沟小渠密布其中。\n"
        rd.npcLists[NSStringFromClass(KGaoNiu.self)] = 1
        rd.npcLists[NSStringFromClass(KGaoFarmer.self)] = randomInt(3)
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"土路" ,id: "高-土路4")
        rd.describe = "一条湿漉漉的小路，路边开着许多野花．路边小渠里溪水缓缓的流着．水田中也偶尔传来青蛙＂呱呱＂的叫声．远远望去，稻田中绿油油的．北边可望到高家镇，南边就到了村里。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"村口" ,id: "高-村口")
        rd.describe = "到了村口，向村中望去，稀稀落落也有百十来间瓦房。村里人都忙忙碌碌的，顾不上搭理你，只有几个小童在村旁的池塘中无忧无虑的玩着。\n"
        rd.npcLists[NSStringFromClass(KGaoCunZhang.self)] = 1
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"农舍" ,id: "高-农舍")
        rd.describe = "一间宽敞的农舍，打扫的干干净净。屋里正中是祖先的牌位，供案上有几乎盘蜡做的水果。墙角堆着各种瓜果蔬菜，让你直流口水。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"书堂" ,id: "高-书堂")
        rd.describe = "一间小小的房子。正中墙上挂着一幅孔子的画像。一个老先生正教着一群孩子念之乎者也。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"布店" ,id: "高-布店")
        rd.describe = "这里的东西虽不高级，却相当符合当地人的口味．逢年过节来光顾的人还真不少．屋中横放一张七尺多长的柜台，柜台后的架子上是一匹匹的布料和成衣。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"铁匠铺" ,id: "高-铁匠铺")
        rd.describe = "铁铺的主人是老李头，他打的铁器坚固耐用，名气在方圆几十里是没的说．他这里的生意也特别的好．屋里到处是铁器，两个学徒正帮着老李头打造农具。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"正院" ,id: "高-正院")
        rd.describe = "院中一棵巨大的兰花树，开了无数朵白色的小花，发出淡淡的清香，令人有几分陶醉．听说是高庄主的爷爷种下的，至今已有一人合抱粗细．东西是一些仆人住的地方，北边是高家的正庭。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"饭厅" ,id: "高-饭厅")
        rd.describe = "饭厅中放了一张八仙桌，桌上杯碟狼籍．一伙客人刚吃过走了．小丫环正打扫着剩汤剩饭．说是剩汤剩饭，其实好些还没碰过。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"闺楼" ,id: "高-闺楼")
        rd.describe = "这里是高小姐的闺楼．室内装饰典雅，家俱全是南方运来的竹器。墙上的一幅字画风骨颇为不俗，字体看起来也相当的漂亮。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"后院" ,id: "高-后院")
        rd.describe = "后院之中极为宽敞，秋收时就是高家晾晒稻谷的地方。东边靠墙有一口土井，旁边放了几只木桶．西边一座小楼，是小姐住的地方，北边是高家的后花园。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"后花园" ,id: "高-后花园")
        rd.describe = "后花园中花草甚多，什么凤仙、鸡冠、秋葵、百合、蔷薇、牡丹等等，不可枚举，满目皆是．遇花开之时，后花园中红红紫紫，漫如锦屏．真想多呆一会，好好看看。\n"
        rd.roomClassString = NSStringFromClass(KGaoHouHuaYuanRoom.self)
        rd.itemLists[NSStringFromClass(KGaoHouHuaYuanWall.self)] = 1
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"内室" ,id: "高-内室")
        rd.describe = "房间不大，却是石门石窗．窗上还有铁打的柱子。\n"
        rd.isOutDoor = false
        rd.hasWindow = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"偏房" ,id: "高-偏房")
        rd.describe = "一间小小的偏房，摆设很简单．只有一张桌子和几张椅子而已．高家养了几个庄丁护院．其实都是些三脚猫功夫，只能吓吓人罢了。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"偏厅" ,id: "高-偏厅")
        rd.describe = "靠窗是张火炕，上面垫着皮褥子．整个房子暖洋洋的．高老太太正盘着腿坐在炕上，低头查着旧帐．旁边一个丫环伺候着。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"洗衣房" ,id: "高-洗衣房")
        rd.describe = "地下到处流着脏水，一个老妈子正洗着一堆衣服。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"账房" ,id: "高-账房")
        rd.describe = "这儿是高家的帐房，里面摆了一排柜子．高家有好几百亩良田，大多租给附近的农家．管家每月会去收租一次．柜子里就是全部的帐簿．由余柜子经常开关，木把已变的油亮。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"正厅" ,id: "高-正厅")
        rd.describe = "正前方是一张八仙桌，左右是两张带皮垫的太师椅。高老爷正坐在椅上正喝着茶水。左右墙上挂着几幅字画，仔细看看好象并没有什么名气。东西是两间偏厅。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"小酒馆" ,id: "高-酒馆")
        rd.describe = "镇子里就这么一家小酒馆，累了一天的生意人都会来喝几盅．酒店里的花雕可都是正经从长安运来的，那个醇味没的说．再配上几粒花生米，神仙也不过如此。\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"雅室" ,id: "高-雅室")
        rd.describe = "高小姐的卧房便是这里。卧房吗．．当然是休息的地方了．．靠内有一张素净的床铺(bed)，但空荡荡地不见一个人影．．．\n"
        rd.isOutDoor = false
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "小路", id: "高-后花园小路")
        rd.describe = "高家后墙外的一条小路，看样子极少有人来．到处是半人多高的杂草，每走一步都会惊起许多小虫子，有些小蚂蚱还蹦到你的身上．．．\n"
        rd.itemLists[NSStringFromClass(KGaoXiaoluWall.self)] = 1
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "小树林", id: "高-小林")
        rd.describe = "林中光线暗淡，隐约看到几个人围作一团说着什么。传来一股烤肉的味道，令你不禁咽了口唾沫。\n"
        rd.roomClassString = NSStringFromClass(KGaoXiaolinMaze.self)
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "山路", id: "高-山路")
        rd.describe = "好不容易走出了小林，迈上了一条山间小路。越走树林越密，树缝中洒下来的阳光也变得斑斑点点。茅草渐厚，灌木丛生。从东北方吹来阵阵的冷风，令人毛骨耸然。\n"
        fakeRooms.append(rd)
        linkRoom(roomIndex["高-土路1"]!, roomid2: roomIndex["高-街道1"]!, direction: .West)
        linkRoom(roomIndex["高-街道1"]!, roomid2: roomIndex["高-大门"]!, direction: .West)
        linkRoom(roomIndex["高-大门"]!, roomid2: roomIndex["高-街道2"]!, direction: .West)
        linkRoom(roomIndex["高-大门"]!, roomid2: roomIndex["高-正院"]!, direction: .North)
        linkRoom(roomIndex["高-街道2"]!, roomid2: roomIndex["高-街道3"]!, direction: .West)
        linkRoom(roomIndex["高-街道2"]!, roomid2: roomIndex["高-酒馆"]!, direction: .South)
        linkRoom(roomIndex["高-街道3"]!, roomid2: roomIndex["高-土路2"]!, direction: .West)
        linkRoom(roomIndex["高-街道3"]!, roomid2: roomIndex["高-布店"]!, direction: .North)
        linkRoom(roomIndex["高-街道3"]!, roomid2: roomIndex["高-铁匠铺"]!, direction: .South)
        linkRoom(roomIndex["高-土路2"]!, roomid2: roomIndex["高-土路3"]!, direction: .West)
        linkRoom(roomIndex["高-土路3"]!, roomid2: roomIndex["高-稻田1"]!, direction: .North)
        linkRoom(roomIndex["高-土路3"]!, roomid2: roomIndex["高-稻田2"]!, direction: .South)
        linkRoom(roomIndex["高-稻田2"]!, roomid2: roomIndex["高-土路4"]!, direction: .South)
        linkRoom(roomIndex["高-土路4"]!, roomid2: roomIndex["高-村口"]!, direction: .South)
        linkRoom(roomIndex["高-村口"]!, roomid2: roomIndex["高-农舍"]!, direction: .East)
        linkRoom(roomIndex["高-村口"]!, roomid2: roomIndex["高-书堂"]!, direction: .SWest)
        linkRoom(roomIndex["高-正院"]!, roomid2: roomIndex["高-正厅"]!, direction: .North)
        linkRoom(roomIndex["高-正院"]!, roomid2: roomIndex["高-账房"]!, direction: .West)
        linkRoom(roomIndex["高-正院"]!, roomid2: roomIndex["高-偏房"]!, direction: .East)
        linkRoom(roomIndex["高-正厅"]!, roomid2: roomIndex["高-饭厅"]!, direction: .East)
        linkRoom(roomIndex["高-正厅"]!, roomid2: roomIndex["高-偏厅"]!, direction: .West)
        linkRoom(roomIndex["高-正厅"]!, roomid2: roomIndex["高-后院"]!, direction: .North)
        linkRoom(roomIndex["高-后院"]!, roomid2: roomIndex["高-洗衣房"]!, direction: .East)
        linkRoom(roomIndex["高-后院"]!, roomid2: roomIndex["高-后花园"]!, direction: .North)
        linkRoom(roomIndex["高-后院"]!, roomid2: roomIndex["高-闺楼"]!, direction: .West)
        linkRoom(roomIndex["高-闺楼"]!, roomid2: roomIndex["高-雅室"]!, direction: .Up)
        linkRoom(roomIndex["高-后花园小路"]!, roomid2: roomIndex["高-小林"]!, direction: .North)
    }
}
