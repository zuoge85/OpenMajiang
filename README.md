# OpenMajiang(麻将)

> 一个完整的麻将软件（h5 + app）

现在我决定继续更新这个项目！并在我的blog 和公众号发布系列文章！

测试服务器已经可以用，请不要用微信打开！

地址<www.paipaimj.com>

我的blog地址: <https://www.forkjoin.org>

关注我的微信公众号:

![小草的泡码笔记](https://www.forkjoin.org/images/wxqrcode.jpg )

开发QQ群 173103450

## 麻将开发系列blog

第一篇 服务器入门 <https://www.forkjoin.org/2017/09-06-majiang-0/>

## 说明

1. OpenMajiang 是一个开源h5麻将游戏

2. 麻将算法基于网上流行的哪位日本老师的查表算法。。

3. 客户端是 layabox 的h5 引擎，性能还行
4. 服务器是 基于netty'+spring 的架构，主要用于之前我参与的几个项目的服务器端代码修改
5. 服务器的结构大致说下， boss 服务器单点中控，  gataway 网关 负责加密转发消息和保持客户端websocket 长连接， scene 是游戏的房间
6. 管理后台未开放完毕！！
7. app基于cordova 打包
##




8. 全部代码开源 lib 依赖库地址
https://github.com/zuoge85/game-lib
9. 外壳部分依赖 lib
https://github.com/forkjoinorg/base/tree/2.0.1


## 测试服务器 

可以微信打开了，但是不能微信登录。谢谢，




## 游戏服务器启动说明

服务器需要启动3个进程，启动顺序没有关系！
相关端口都可以修改，只有gateway 端口应该暴露出去，其他都是内部端口


### 1. mj-boss （中心控制服务器，控制登录等）

主文件 类名 game.boss.BossMain
配置文件 resources/BossConfig.xml 修改数据库连接
数据库初始化文件 server/boss.sql


### 2. mj-scene （场景服务器可以多开，但是没测试，游戏的主要逻辑在这儿）

主文件 类名 game.scene.SceneMain
配置文件 resources/SceneConfig.xml 修改数据库连接
也需要连接 boss 对应数据库。但是实际上只是配置了，未使用



### 3. mj-gateway （网关服务器，可以多开）

主文件 类名 game.scene.GatewayMain
配置文件 resources/GatewayConfig.xml
不需要数据库

* 当3个进程都启动完毕，游戏服务器就启动成功了 *

>> boss 服务器会显示Scene 和Gateway 注册成功

##外围服务器

外围服务器只要是实现微信登录和管理这些的


### 1.mj-client （h5壳+微信登录等相关接口 + 管理接口)

>这个项目是一个spring boot 项目

static 下放copy 的游戏h5 静态文件

application.yml 是配置人均

启动 majiang.client.boss.BossClient
然后访问启动后的http服务器
http://127.0.0.1:8080 就能打开游戏的h5版本




## 游戏服务器开发说明

首先如果你已经能成功启动游戏服务器，那么恭喜你，哈哈
现在进入开发阶段



### 1. 数据库（mj-dao）

数据库dao层在mj-dao 子项目内
框架主要是基于spring jdbc template的生成器
生成器生成dao 和 实体内，注意生成的内不压修改，扩展可以采用 继承来实现

生成器主类 game.game.db.DaoBuilder,执行这个类就能生成相关文件，

开发流程是 修改数据库接口->生成器生成dao->调用

执行有日志，注意生成文件路径是否正确



### 1. 消息（mj-data）

客户端和服务器间通信都需要消息模块进行解包
游戏协议是基于socket或者websocket 的二进制协议，
协议会自动缩减 字段占用字节，所以不用在乎int long 等类似的区别

协议定义文件在mj-data 下面的resources/msg目录内
可以参考之前的文件了解消息可以互相引用，头部handler 定义是否生成客户端或者服务器的Handler类

[消息协议文档](./MSG.md)

协议生成执行 game.msg.MsgMain，生成后会覆盖相关文件

*消息到达服务器后通过gateway 处理*
msg.login 目录下的消息都会转发给boss 服务器，其他全部到scene 服务器
转发代码在 game.gateway.GatewayService的 forwardFormUser 函数

scene 和 boss 服务器处理消息的过程是。继承需要处理的消息的Hander 实现处理函数


比如 game.scene.handler 下面的那些类 使用@Component 声明成组件，被spring自动装配，
处理消息时注意线程，可以参考之前的代码

线程安全和数据一致性全部依赖同一用户的消息永远在一个固定线程内处理



## 客户端

### 开发调试
客户端使用layabox 1.6.1开发 使用as3 语言开发

使用layabox 打开 client 内的 laya-client 项目

主文件是GameMain.as3 ,
使用layabox 调试的时候修改 GameMain内的服务器地址 搜索 变量serverUrl

### node-client

使用 nodejs 的打包构建的相关东西
先安装nodejs 环境，
然后还需要 https://www.npmjs.com/package/imagemagick-native

然后进入目录执行 npm install
然后安装gulpjs

安装好环境后

gulp dist 打包客户端，压缩优化代码和文件到 node-cliet的dist目录
gulp webclient 打包客户端，输出到 server/project/distribution/src/static 下面
gulp cordova 打包客户端，输出cordova下面


## cordova

[cordova文档](./client/cordova/README.md)

安装好nodejs 环境
准备cordova 环境。
