# webrtc

# 1.0 SDK快速接入使用流程介绍

添加依赖->初始化SDK ->加入房间并监听回调 -> 监听到他人推流的视频并显示，同时自身也可以开启本地摄像头并推流 ->离开房间

# 1.1 运行环境

需在IOS 9.0以上系统中使用。



# 1.2 添加依赖
倒入QKGPUImage.framework、QKWebRtc.framework、SocketIO.framework、WebRTC.framework、Starscream.framework、YYModel.framework。设置SocketIO.framework、WebRTC.framework、Starscream.framework、YYModel.framework 为Embed&sign。



# QKRTCCloud屏幕分享接口介绍

屏幕分享必须是IOS12以上系统。推荐使用extension进行屏幕分享的录制。
# 屏幕共享占用大量系统资源。开启共享的同时，最好先关闭摄像头、然后停止推流，防止手机性能不足引起问题。
iOS 系统上的跨应用屏幕分享，需要增加 Extension 录屏进程以配合主 App 进程进行推流。Extension 录屏进程由系统在需要录屏的时候创建，并负责接收系统采集到屏幕图像。因此需要：
创建 App Group，并在 XCode 中进行配置（可选）。这一步的目的是让 Extension 录屏进程可以同主 App 进程进行跨进程通信。
在您的工程中，新建一个 Broadcast Upload Extension 的 Target，并在其中集成 SDK。
初始话 App 端的接口，让主 App 等待来自 Broadcast Upload Extension 的录屏数据。
使用 RPSystemBroadcastPickerView唤起屏幕共享程序。
替换Broadcast Upload Extension中的SampleHandler.h 和SampleHandler.m文件。

