import Foundation

private func check(str: String) {
    // 使用正则表达式一定要加try语句
    do {
        // - 1、创建规则
        //let pattern = "[1-9][0-9]{4,14}"
        let pattern = "<color (\\w+)>"
        // - 2、创建正则表达式对象
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        // - 3、开始匹配
        let res = regex.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
        // 输出结果
        for checkingRes in res {
            debugPrint(checkingRes)
            print((str as NSString).substringWithRange(checkingRes.range))
        }
    }
    catch {
        print(error)
    }
}
check("<color red>df33434<color grre>34343ds343434343f</color>")
//print(message)
