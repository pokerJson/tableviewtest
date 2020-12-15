//
//  AppDelegate.swift
//  tablev
//
//  Created by CYAX_BOY on 2020/12/5.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    http://pan.peogoo.com/
//    http://oa.peogoo.com/login/Login.jsp?gopage=&_rnd_=bedd7e80-fb68-4403-99f9-d77d13dd1fe5
//        http://10.1.1.19/zentao/my-profile.html
//    https://exmail.qq.com/login
//    http://test-k8s-dzq-admin.peogoo.com/login;JSESSIONID=5965403f-31b6-4fa3-89de-f1d1557dbae7 15011550284 123456abcd
//    http://10.1.1.30:8878/web/#/45?page_id=3527
//    https://lanhuapp.com/web/#/item/project/detailDetach?type=share_mark&pid=a3607b40-9b6d-4b63-bb7b-24d4535eb8df&activeSectionId=&teamId=70c09354-c310-4fe5-9312-a4fc0349714a&param=none&project_id=a3607b40-9b6d-4b63-bb7b-24d4535eb8df&image_id=faea78e6-af6c-43ea-ab6d-57a7af2d7687
//    https://archery.peogoo.com/login/
//    https://www.jianshu.com/p/65b05ab1b130
//    https://juejin.cn/post/6844904130406793224
//    https://www.jianshu.com/p/b3bd6d7d9cc0
//    https://www.bilibili.com/video/BV1J5411L73r/
//    https://www.bilibili.com/video/BV1Gt4y1i72b?from=search&seid=13546923049992605294
//    https://www.bilibili.com/video/BV1pJ411z7ji?from=search&seid=16105578964776107696
//    https://juejihttps://juejin.cn/post/6844904170139418631n.cn/post/6844904170139418631
//    https://juejin.cn/post/6844904170139418631
//    https://www.jianshu.com/p/a6bfa7cec2b6
//    https://www.jianshu.com/p/ec7467202fc3
//    https://www.bilibili.com/video/BV1gi4y1x7YS?p=43
//    https://www.cnblogs.com/zhangxiaoxu/p/12069410.html
//    https://www.jianshu.com/p/4e79e9a0dd82
    
//    export PATH=/usr/local/bin:$PATH
//    export PUB_HOSTED_URL=https://pub.flutter-io.cn
//    export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
//    export PATH=/Users/phjtytj-0003/Documents/flutter/flutter/bin:$PATH
//    export ANDROID_HOME="/Users/phjtytj-0003/Library/Android/sdk"
//    export PATH=${PATH}:${ANDROID_HOME}/tools
//    export PATH=${PATH}:${ANDROID_HOME}/platform-tools
//    # HomeBrew
//    export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
//    export PATH="/usr/local/bin:$PATH"
//    export PATH="/usr/local/sbin:$PATH"
//    alias rewriteoc='clang -x objective-c -rewrite-objc -isysroot /Users/phjtytj-0003/Desktop/Xcode\ 2.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk'
//    # HomeBrew END

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

