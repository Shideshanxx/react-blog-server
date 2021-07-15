create database egg_blog;

use egg_blog;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typeId` int(11) NOT NULL DEFAULT '0',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `introduce` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `viewCount` int(11) NOT NULL DEFAULT '0',
  `cover` varchar(255) CHARACTER SET utf8 DEFAULT '0',
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `userId` int(11) DEFAULT '0',
  `tags` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('1','0') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '是否公开， 0公开， 1隐藏',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';

-- ----------------------------
-- Records of article
-- ----------------------------
BEGIN;
INSERT INTO `article` VALUES (45, 1, 'react points', '> 1. 组件之间如何通讯？

+ 父子组件：props
+ <font color=red>自定义事件（eventBus的实现原理）（ue中`$on`，`$once`，`$off`，`$emit` 的实现原理是怎样的）</font>
+ redux
+ context

> 2. JSX本质是什么？

+ createElement
+ 执行返回vnode
 
> 3. Context是什么，如何使用？

+ 父组件向子孙组件传递信息
+ 用于一些简单的公共信息：主题色，语言等
+ 复杂的数据请用redux
 
> 4. shouldComponentUpdate用途？

+ 性能优化
+ 配合“不可变值”一起使用，否则会出错
+ 为何react不自己实现SCU：深度递归影响性能；SCU必须配合“不可变值”使用，对于部分不遵守规则的开发者会出现BUG
 
> 5. 请描述Redux的单项数据流？

![redux单向数据流](http://cdn.zjutshideshan.cn/redux%E5%8D%95%E5%90%91%E6%95%B0%E6%8D%AE%E6%B5%81.png)

`view` ——> `dispatch(action)` ——> `reducer`(获取newState) ——> 通知`watcher`更新视图;
中间件会劫持`dispatch`，封装一些自己的逻辑，返回新的`dispatch`，最终把`action`传到`reducer`。
 
> 6. setState 什么时候同步，什么时候异步，什么时候合并，什么时候不合并？在Hooks中setState是异步的吗？

> 7. 什么是纯函数？

+ 返回一个新值，没有副作用（不会“偷偷修改其他值”）


> 8. react有收集依赖吗？vuex的修改如何通知watcher修改视图？setState是否会判断state在不在watcher中？

> 9. React组件生命周期

+ class组件
+ hooks组件
+ 单组件生命周期
+ 父子组件的生命周期

> 10. React发起ajax请求应该在哪个生命周期？

componentDidMount

> 11. 列表渲染为何使用key？

+ key不能是index和random
+ diff算法通过tag和key来判断，是否为sameNode
+ key减少渲染次数，提高渲染性能

> 12. 函数组件和class组件的区别？

函数组件：
+ 纯函数，输入props，输出JSX
+ 没有实例，没有生命周期，没有state
+ 不能扩展其他方法

> 13. 什么是受控组件？什么是非受控组件？非受控组件的使用场景？

受控组件：
+ 表单的值，受state控制
+ 需要自行监听onChange，更新state

非受控组件：
+ 表单的修改与state无关，获取表单数据只能通过DOM操作
+ 使用场景：必须手动操作DOM，setState实现不了，比如上传文件、富文本编辑器等

> 14. 何时使用异步组件？如何使用异步组件？

+ 加载大组件
+ 路由懒加载
+ React.lazy、import 函数，也可配合Suspence标签使用

> 15. 多个组件的公共逻辑，如何抽离？

class组件中：
+ HOC
+ render props

函数组件中：
+ 自定义Hook

> 16. 在redux中如何进行异步请求？

+ 使用异步action
+ 使用中间件 redux-thunk

> 17. react-router 如何配置懒加载？

+ 熟悉react-router的配置
+ 异步组件的引入方式

> 18. PureComponent和Component的区别？

+ 实现了浅比较的 shouldCOmponentUpdate
+ 性能优化
+ 必须配合不可变值使用

> 19. React事件和DOM事件的区别？

+ 所有事件都挂载到root上
+ event不是原生的，模拟了所有原生事件的功能，通过event.nativeEvent获取原生事件
+ dispatchEvent机制

> 20. React性能优化

+ 渲染列表是使用key
+ 自定义事件、DOM事件、setTimeout、setInterval即使销毁
+ 合理使用异步组件
+ 减少函数 bind this的次数（推荐使用箭头函数定义事件）
+ 合理使用SCU、PureComponent和memo
+ 合理使用Immutable.js
+ useCallback、useMemo
+ webpack优化
+ 前端通用优化（比如图片懒加载）
+ 使用SSR

> 21. React和vue的区别？

相同点：
+ 都支持组件化
+ 都是数据驱动视图
+ 都是用vdom操作DOM

不同点：
+ React使用JSX拥抱JSX，vue使用模板（vue3也可以使用JSX）
+ React是**函数式编程**，修改数据都是通过setState手动修改；而vue是**声明式编程**，把data重新赋值，vue响应式监听进行重新渲染。
+ vue实现了响应式，react需要手动更新

> 22. React设计todolist（组件结构和redux state数据结构）

state数据结构设计：
+ 用数据描述所有内容
+ 数据要结构化，易于程序操作（遍历、查找）
+ 数据要可扩展，以便增加新的功能
````js
// 数组一定得有一个id
list: [
  {
    id: 1,
    title: "标题1",
    completed: false,
  },
  {
    id: 2,
    title: "标题2",
    completed: false,
  },
],
````

组件设计：
+ 从功能上拆分层次
+ 尽量让组件原子化，一个组件只做一个功能
+ 容器组件（只管理数据）& UI 组件（只显示视图）
````js
  TodoList
  ├─ index.js
  ├─ InputItem.js
  ├─ List.js
  ├─ ListItem.js
  └─ UI // 把两个表单继续拆分，实现双向数据绑定，只接收数据和触发事件。
    ├─ CheckBox.js
    └─ Input.js
````', '在练习中学习还是很靠谱的方法！！\n\n', 34, 'http://cdn.zjutshideshan.cn/blog/react1.jpg', '2021-03-01 13:26:42', 1, 'react,高阶', '0');
COMMIT;

-- ----------------------------
-- Table structure for articlelike
-- ----------------------------
DROP TABLE IF EXISTS `articlelike`;
CREATE TABLE `articlelike` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `articleId` int(11) NOT NULL,
  `status` enum('1','0') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1' COMMENT '1已点赞 0已取消',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of articlelike
-- ----------------------------
BEGIN;
INSERT INTO `articlelike` VALUES (8, 1, 23, '0', '2020-05-19 18:23:26');
INSERT INTO `articlelike` VALUES (9, 17, 23, '1', '2020-05-20 12:01:22');
INSERT INTO `articlelike` VALUES (10, 16, 23, '1', '2020-05-21 10:35:03');
INSERT INTO `articlelike` VALUES (11, 1, 24, '1', '2020-05-22 20:14:50');
INSERT INTO `articlelike` VALUES (12, 1, 25, '1', '2020-05-22 23:49:25');
INSERT INTO `articlelike` VALUES (13, 4, 25, '0', '2020-06-04 10:48:18');
INSERT INTO `articlelike` VALUES (14, 1, 26, '1', '2020-06-04 20:18:27');
INSERT INTO `articlelike` VALUES (15, 18, 26, '1', '2020-06-06 16:13:24');
INSERT INTO `articlelike` VALUES (16, 1, 27, '1', '2020-06-07 10:10:11');
INSERT INTO `articlelike` VALUES (17, 18, 28, '1', '2020-06-09 17:34:25');
INSERT INTO `articlelike` VALUES (18, 21, 27, '0', '2020-06-23 00:26:31');
INSERT INTO `articlelike` VALUES (19, 22, 28, '0', '2020-07-14 12:49:46');
INSERT INTO `articlelike` VALUES (20, 1, 28, '0', '2020-07-14 13:39:56');
INSERT INTO `articlelike` VALUES (21, 18, 17, '1', '2020-07-16 08:59:11');
INSERT INTO `articlelike` VALUES (22, 1, 17, '1', '2020-07-25 11:08:51');
INSERT INTO `articlelike` VALUES (23, 18, 30, '1', '2020-08-01 16:36:06');
INSERT INTO `articlelike` VALUES (24, 17, 29, '1', '2020-12-01 11:36:47');
INSERT INTO `articlelike` VALUES (25, 2, 30, '0', '2020-12-02 14:45:27');
INSERT INTO `articlelike` VALUES (26, 24, 24, '0', '2020-12-10 09:52:50');
INSERT INTO `articlelike` VALUES (27, 24, 30, '1', '2020-12-10 09:57:13');
INSERT INTO `articlelike` VALUES (28, 2, 34, '1', '2020-12-28 11:27:31');
INSERT INTO `articlelike` VALUES (29, 18, 34, '1', '2020-12-29 09:43:43');
INSERT INTO `articlelike` VALUES (30, 18, 32, '1', '2020-12-29 09:45:27');
INSERT INTO `articlelike` VALUES (31, 1, 34, '0', '2021-01-04 01:04:36');
INSERT INTO `articlelike` VALUES (32, 1, 37, '1', '2021-02-09 23:15:49');
INSERT INTO `articlelike` VALUES (33, 3, 37, '0', '2021-02-25 12:08:48');
INSERT INTO `articlelike` VALUES (34, 3, 42, '1', '2021-02-25 12:09:31');
INSERT INTO `articlelike` VALUES (35, 1, 44, '1', '2021-02-25 17:41:00');
INSERT INTO `articlelike` VALUES (36, 1, 47, '1', '2021-03-01 23:03:27');
INSERT INTO `articlelike` VALUES (37, 1, 45, '1', '2021-03-01 23:06:46');
INSERT INTO `articlelike` VALUES (38, 2, 42, '1', '2021-03-02 09:57:06');
COMMIT;

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) CHARACTER SET utf8 NOT NULL,
  `link` varchar(255) CHARACTER SET utf8 NOT NULL,
  `status` enum('0','1') CHARACTER SET utf8 NOT NULL DEFAULT '1' COMMENT '1, 正常 2，下架',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int(11) NOT NULL DEFAULT '0',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` enum('3','2','1','4','5','7','8','6') CHARACTER SET utf8 DEFAULT '1' COMMENT '1轮播，2推荐，3广告，4首页时图，5列表页时图，6详情页时图，7搜索时图 8消息时图',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='轮播大图 封面';

-- ----------------------------
-- Records of banner
-- ----------------------------
BEGIN;
INSERT INTO `banner` VALUES (1, 'http://cdn.zjutshideshan.cn/blog_image/advert1.jpg', '', '1', '右下角广告', 1, '2021-01-12 00:20:09', '3');
INSERT INTO `banner` VALUES (2, 'http://cdn.zjutshideshan.cn/blog_image/cover3.jpg', '无', '1', '封面', 1, '2021-02-22 22:55:41', '4');
INSERT INTO `banner` VALUES (3, 'http://cdn.zjutshideshan.cn/a920fab0-e48b-11eb-8d1a-93aa0ede4233', '', '1', '信息中心封面', 1, '2021-01-12 00:20:09', '5');
INSERT INTO `banner` VALUES (4, 'http://cdn.zjutshideshan.cn/a920fab0-e48b-11eb-8d1a-93aa0ede4233', '无', '1', '搜索页封面', 1, '2021-02-22 22:55:41', '7');
COMMIT;

-- ----------------------------
-- Table structure for clicklike
-- ----------------------------
DROP TABLE IF EXISTS `clicklike`;
CREATE TABLE `clicklike` (
  `id` int(11) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `articleId` int(11) DEFAULT NULL,
  `status` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '1' COMMENT '1已点赞 0已取消',
  `createTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `content` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '评论内容',
  `userId` int(11) DEFAULT NULL COMMENT '用户id',
  `pid` int(11) DEFAULT NULL COMMENT '回复id',
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `articleId` int(11) DEFAULT NULL COMMENT '文章id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=172 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of comment
-- ----------------------------
BEGIN;
INSERT INTO `comment` VALUES (126, '6', 16, NULL, '2020-05-19 18:30:46', 18);
INSERT INTO `comment` VALUES (127, '1', 16, 126, '2020-05-19 18:30:51', 18);
INSERT INTO `comment` VALUES (128, '各位，评论功能上线了喂！', 1, NULL, '2020-05-19 23:52:47', 23);
INSERT INTO `comment` VALUES (129, '大佬大佬，排队膜拜', 17, NULL, '2020-05-20 12:01:35', 23);
INSERT INTO `comment` VALUES (130, '哈哈', 1, 129, '2020-05-20 12:12:01', 23);
INSERT INTO `comment` VALUES (131, '这篇文章写的含而不露，隐而不诲，意味深长。(5毛一条)', 18, NULL, '2020-05-22 22:52:58', 24);
INSERT INTO `comment` VALUES (132, '支付宝已转，注意查收！', 1, 131, '2020-05-22 23:37:49', 24);
INSERT INTO `comment` VALUES (133, '太长不看', 1, NULL, '2020-05-22 23:38:40', 25);
INSERT INTO `comment` VALUES (134, '长是我的错？？？', 18, 133, '2020-05-22 23:44:21', 25);
INSERT INTO `comment` VALUES (135, '牛逼', 1, NULL, '2020-05-23 22:19:00', 8);
INSERT INTO `comment` VALUES (136, '我怀疑你在开车！', 1, 134, '2020-05-24 18:33:06', 25);
INSERT INTO `comment` VALUES (137, '6月，减肥计划已在路上！', 1, NULL, '2020-06-02 21:22:42', 21);
INSERT INTO `comment` VALUES (138, '切格瓦拉警告', 18, NULL, '2020-06-06 16:35:33', 23);
INSERT INTO `comment` VALUES (139, '你车没了！', 1, 138, '2020-06-06 20:10:05', 23);
INSERT INTO `comment` VALUES (140, '路还很长，加油吧。', 1, NULL, '2020-06-06 21:21:19', 26);
INSERT INTO `comment` VALUES (141, '可以可以，加油小伙子！', 1, NULL, '2020-06-07 10:10:35', 27);
INSERT INTO `comment` VALUES (142, '我提bug了，快点改好', 18, 141, '2020-06-07 11:02:27', 27);
INSERT INTO `comment` VALUES (143, '你提的是功能！要排期！', 1, 142, '2020-06-07 11:55:44', 27);
INSERT INTO `comment` VALUES (144, '不愧是你（手动狗头）', 18, 143, '2020-06-07 13:56:48', 27);
INSERT INTO `comment` VALUES (167, '😜', 1, NULL, '2021-02-22 21:37:27', 4);
INSERT INTO `comment` VALUES (168, '此处应该有掌声👏👏👏', 1, NULL, '2021-03-01 23:04:48', 47);
INSERT INTO `comment` VALUES (169, '加油👍', 1, NULL, '2021-03-01 23:06:43', 45);
INSERT INTO `comment` VALUES (147, '拷走', 18, NULL, '2020-06-09 17:35:19', 28);
INSERT INTO `comment` VALUES (148, '我TM', 1, 147, '2020-06-09 18:53:19', 28);
INSERT INTO `comment` VALUES (149, '? 改好啦靓仔！', 1, 146, '2020-07-08 16:29:14', 27);
INSERT INTO `comment` VALUES (150, '7月，考证已在路上！?', 1, NULL, '2020-07-08 20:42:07', 21);
INSERT INTO `comment` VALUES (170, '加油', 2, NULL, '2021-03-02 09:56:36', 42);
INSERT INTO `comment` VALUES (171, '👌', 1, 170, '2021-03-10 12:27:02', 42);
INSERT INTO `comment` VALUES (152, '此处应有掌声！???', 1, NULL, '2020-07-25 18:20:20', 29);
INSERT INTO `comment` VALUES (153, '吹喇叭我只服陆?', 18, NULL, '2020-08-01 16:36:38', 30);
INSERT INTO `comment` VALUES (154, '看来得加个删评论功能！?', 1, 153, '2020-08-01 16:57:38', 30);
INSERT INTO `comment` VALUES (155, '8月，技术栈已切换回vue了。typeScript也很简单，书写习惯问题，后面慢慢适应。?', 1, NULL, '2020-08-10 20:56:19', 21);
INSERT INTO `comment` VALUES (156, '愿你在平凡的日子里，熠熠生辉', 1, NULL, '2020-12-10 20:19:39', 32);
INSERT INTO `comment` VALUES (157, '愿你在平凡的日子里，熠熠生辉。', 2, 156, '2020-12-11 14:02:15', 32);
INSERT INTO `comment` VALUES (158, '建议改为夜话火炉山', 18, NULL, '2020-12-29 09:44:55', 33);
INSERT INTO `comment` VALUES (159, '2020 最后一天。flag 完成度大概 50%吧，python和flutter没学，减肥是控制住了。钱没存到，女朋友也还没有找到😪，乐器倒学了。自考本科已经报名了，驾照实在没兴趣。视频素材安详躺在硬盘中说希望不要打扰它。。。', 1, NULL, '2020-12-31 18:26:34', 21);
INSERT INTO `comment` VALUES (160, '2021 请继续加油！💪', 1, NULL, '2020-12-31 18:27:25', 21);
COMMIT;

-- ----------------------------
-- Table structure for commentlike
-- ----------------------------
DROP TABLE IF EXISTS `commentlike`;
CREATE TABLE `commentlike` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `commentId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '1' COMMENT '状态 0 取消， 1点赞',
  `articleId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of commentlike
-- ----------------------------
BEGIN;
INSERT INTO `commentlike` VALUES (44, 129, 18, '2020-06-06 16:37:31', '1', 23);
INSERT INTO `commentlike` VALUES (45, 158, 1, '2020-12-31 18:28:51', '1', 33);
INSERT INTO `commentlike` VALUES (46, 160, 2, '2021-01-06 14:24:50', '1', 21);
INSERT INTO `commentlike` VALUES (47, 159, 2, '2021-01-06 14:25:05', '1', 21);
INSERT INTO `commentlike` VALUES (48, 131, NULL, '2021-02-18 14:57:28', '1', 24);
INSERT INTO `commentlike` VALUES (49, 132, NULL, '2021-02-18 18:48:18', '1', 24);
COMMIT;

-- ----------------------------
-- Table structure for contact
-- ----------------------------
DROP TABLE IF EXISTS `contact`;
CREATE TABLE `contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('wx','qq','github','weibo','bilibili') NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `userId` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of contact
-- ----------------------------
BEGIN;
INSERT INTO `contact` VALUES (1, 'weibo', 'https://weibo.com/3916762379/profile?topnav=1&wvr=6', NULL, 1);
INSERT INTO `contact` VALUES (2, 'bilibili', 'https://space.bilibili.com/6489557?https://space.bilibili.com/19522654', NULL, 1);
INSERT INTO `contact` VALUES (3, 'github', 'https://github.com/Shideshanxx', NULL, 1);
INSERT INTO `contact` VALUES (4, 'qq', NULL, 'http://cdn.zjutshideshan.cn/blog_image/myqqCode.png', 1);
INSERT INTO `contact` VALUES (5, 'wx', NULL, 'http://cdn.zjutshideshan.cn/blog_image/myWxCode.jpg', 1);
COMMIT;

-- ----------------------------
-- Table structure for fans
-- ----------------------------
DROP TABLE IF EXISTS `fans`;
CREATE TABLE `fans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `fansId` int(11) DEFAULT NULL,
  `status` enum('1','0') COLLATE utf8_unicode_ci DEFAULT '0' COMMENT '0 关注 1取消关注 默认0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of fans
-- ----------------------------
BEGIN;
INSERT INTO `fans` VALUES (18, 2, '2020-05-20 12:03:53', 16, '0');
INSERT INTO `fans` VALUES (19, 2, '2020-05-24 20:35:34', 17, '0');
INSERT INTO `fans` VALUES (20, 17, '2020-05-20 12:10:51', 1, '0');
INSERT INTO `fans` VALUES (21, 1, '2020-05-20 14:02:08', 16, '0');
INSERT INTO `fans` VALUES (22, 18, '2020-05-23 15:07:46', 1, '0');
INSERT INTO `fans` VALUES (23, 4, '2020-05-25 00:00:03', 1, '0');
INSERT INTO `fans` VALUES (24, 20, '2020-06-07 12:59:34', 1, '0');
INSERT INTO `fans` VALUES (25, 1, '2020-07-14 12:47:51', 22, '1');
INSERT INTO `fans` VALUES (26, 3, '2020-07-18 20:32:24', 1, '0');
INSERT INTO `fans` VALUES (27, 3, '2020-12-29 09:48:40', 18, '0');
INSERT INTO `fans` VALUES (28, 2, '2020-12-30 18:44:57', 1, '0');
INSERT INTO `fans` VALUES (29, 3, '2021-02-14 15:23:49', NULL, '0');
COMMIT;

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of feedback
-- ----------------------------
BEGIN;
INSERT INTO `feedback` VALUES (15, '希望能与大佬们互相交流一下', '本人博客 http://www.jsfan.net/\n联系方式无法添加', 'QQ: 907985037', '2020-04-15 12:57:25');
INSERT INTO `feedback` VALUES (16, '你好', '你好, 我刚开始搭建博客, 现在egg服务在云服务器启动成功了, 内网能拿到数据，但是外网访问不了接口,  请问还需要弄什么操作', 'wx 13694997133', '2020-06-02 17:26:44');
INSERT INTO `feedback` VALUES (17, '为什么mdEditor我发的表情包在文章看不到了呀', '发文章可以考拿到，网站内看不到。', 'id:我任由我不由天', '2020-06-07 09:37:15');
INSERT INTO `feedback` VALUES (18, '评论部分，如果太长感觉很丑', '感觉可以搞一个点击查看更多的功能', NULL, '2020-06-07 13:58:31');
INSERT INTO `feedback` VALUES (19, '分享文章，其实可以增加分享wx朋友圈', '添加需求', '不给', '2020-07-24 16:25:32');
COMMIT;

-- ----------------------------
-- Table structure for msg
-- ----------------------------
DROP TABLE IF EXISTS `msg`;
CREATE TABLE `msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('4','3','2','5','6','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '1' COMMENT '1评论 2回复评论  3点赞文章 4点赞评论 5粉丝关注 6系统通知',
  `userId` int(11) NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '内容，收藏评论点赞的文章或者评论位置',
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('1','2','0') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT '0 未读 1已读 2删除',
  `callUserId` int(11) DEFAULT NULL,
  `source` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '出处  即文章封面或者评论内容',
  `sourceId` int(11) NOT NULL COMMENT '出处id 即文章id或者用户id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of msg
-- ----------------------------
BEGIN;
INSERT INTO `msg` VALUES (66, '1', 16, '6', '2020-05-19 18:38:50', '1', 1, 'http://cdn.lululuting.com/80b8e290-78b7-11ea-b66e-790e90ecd402', 18);
INSERT INTO `msg` VALUES (67, '1', 17, '大佬大佬，排队膜拜', '2020-05-20 12:10:54', '1', 1, 'http://cdn.lululuting.com/2b30d8e0-8579-11ea-b971-0906423746e5', 23);
INSERT INTO `msg` VALUES (68, '5', 16, NULL, '2020-05-20 16:31:21', '1', 2, NULL, 16);
INSERT INTO `msg` VALUES (69, '5', 17, NULL, '2020-05-20 16:31:21', '1', 2, NULL, 17);
INSERT INTO `msg` VALUES (70, '5', 1, NULL, '2020-05-20 12:11:56', '1', 17, NULL, 1);
INSERT INTO `msg` VALUES (71, '2', 1, '哈哈', '2020-05-20 12:12:55', '1', 17, '大佬大佬，排队膜拜', 23);
INSERT INTO `msg` VALUES (72, '5', 16, NULL, '2020-05-20 14:02:29', '1', 1, NULL, 16);
INSERT INTO `msg` VALUES (73, '1', 18, '这篇文章写的含而不露，隐而不诲，意味深长。(5毛一条)', '2020-05-22 23:33:42', '1', 1, 'http://cdn.lululuting.com/6dec2510-9a5d-11ea-b61d-a3be4770de24', 24);
INSERT INTO `msg` VALUES (74, '2', 1, '支付宝已转，注意查收！', '2020-05-22 23:43:02', '1', 18, '这篇文章写的含而不露，隐而不诲，意味深长。(5毛一条)', 24);
INSERT INTO `msg` VALUES (75, '1', 1, '太长不看', '2020-05-22 23:43:02', '1', 18, 'http://cdn.lululuting.com/d35b7dd0-9c40-11ea-b505-0775c997dd0f', 25);
INSERT INTO `msg` VALUES (76, '2', 18, '长是我的错？？？', '2020-05-22 23:45:43', '1', 1, '太长不看', 25);
INSERT INTO `msg` VALUES (77, '5', 1, NULL, '2020-06-06 16:13:57', '1', 18, NULL, 1);
INSERT INTO `msg` VALUES (78, '1', 1, '牛逼', '2020-07-16 09:56:27', '1', 2, 'http://cdn.lululuting.com/2561ad70-6532-11ea-9ef1-793305692a11', 8);
INSERT INTO `msg` VALUES (79, '2', 1, '我怀疑你在开车！', '2020-06-06 16:13:57', '1', 18, '长是我的错？？？', 25);
INSERT INTO `msg` VALUES (80, '5', 1, NULL, '2020-06-04 10:23:35', '1', 4, NULL, 1);
INSERT INTO `msg` VALUES (81, '1', 18, '切格瓦拉警告', '2020-06-06 20:08:51', '1', 1, 'http://cdn.lululuting.com/2b30d8e0-8579-11ea-b971-0906423746e5', 23);
INSERT INTO `msg` VALUES (82, '4', 18, NULL, '2020-12-01 11:27:25', '1', 17, '大佬大佬，排队膜拜', 23);
INSERT INTO `msg` VALUES (83, '2', 1, '你车没了！', '2020-06-06 23:52:31', '1', 18, '切格瓦拉警告', 23);
INSERT INTO `msg` VALUES (84, '1', 1, '路还很长，加油吧。', '2020-06-06 21:21:19', '0', 4, 'http://cdn.lululuting.com/19d2da90-a643-11ea-b3d0-6f6a2f29457d', 26);
INSERT INTO `msg` VALUES (85, '1', 1, '可以可以，加油小伙子！', '2020-06-07 11:01:11', '1', 18, 'http://cdn.lululuting.com/02271730-a814-11ea-97ed-37030e0db785', 27);
INSERT INTO `msg` VALUES (86, '2', 18, '我提bug了，快点改好', '2020-06-07 11:54:19', '1', 1, '可以可以，加油小伙子！', 27);
INSERT INTO `msg` VALUES (87, '2', 1, '你提的是功能！要排期！', '2020-06-07 13:55:56', '1', 18, '我提bug了，快点改好', 27);
INSERT INTO `msg` VALUES (88, '5', 1, NULL, '2020-06-07 23:15:02', '1', 20, NULL, 1);
INSERT INTO `msg` VALUES (89, '2', 18, '不愧是你（手动狗头）', '2020-06-07 17:59:03', '1', 1, '你提的是功能！要排期！', 27);
INSERT INTO `msg` VALUES (90, '2', 1, '评论展示表情是吧，安排上了。', '2020-06-07 18:26:38', '1', 18, '不愧是你（手动狗头）', 27);
INSERT INTO `msg` VALUES (91, '2', 18, '是发布的文章没表情，不是评论展示', '2020-06-07 18:52:05', '1', 1, '评论展示表情是吧，安排上了。', 27);
INSERT INTO `msg` VALUES (92, '1', 18, '拷走', '2020-06-09 18:41:01', '1', 1, 'http://cdn.lululuting.com/4b2f4c90-a945-11ea-9a01-65ae145b5aef', 28);
INSERT INTO `msg` VALUES (93, '2', 1, '我TM', '2020-06-09 20:28:25', '1', 18, '拷走', 28);
INSERT INTO `msg` VALUES (94, '2', 1, '? 改好啦靓仔！', '2020-07-10 16:56:15', '1', 18, '是发布的文章没表情，不是评论展示', 27);
INSERT INTO `msg` VALUES (95, '5', 22, NULL, '2020-07-14 13:38:19', '1', 1, NULL, 22);
INSERT INTO `msg` VALUES (96, '3', 22, NULL, '2020-07-14 13:38:19', '1', 1, 'http://cdn.lululuting.com/4b2f4c90-a945-11ea-9a01-65ae145b5aef', 28);
INSERT INTO `msg` VALUES (97, '3', 18, NULL, '2020-07-16 09:54:07', '1', 1, 'http://cdn.lululuting.com/b44cf7d0-74e4-11ea-9e0d-5d31f8d3722b', 17);
INSERT INTO `msg` VALUES (98, '1', 18, '发现一个问题，就是登录后，页面不是看文章的地址二十重定向到了固定页面。bug+1', '2020-07-16 09:54:07', '1', 1, 'http://cdn.lululuting.com/b44cf7d0-74e4-11ea-9e0d-5d31f8d3722b', 17);
INSERT INTO `msg` VALUES (99, '5', 1, NULL, '2020-12-09 22:47:02', '1', 3, NULL, 1);
INSERT INTO `msg` VALUES (100, '1', 1, '此处应有掌声！???', '2020-07-27 13:59:52', '1', 18, 'http://cdn.lululuting.com/351e39a0-ce45-11ea-b619-9b113aa9a739', 29);
INSERT INTO `msg` VALUES (101, '3', 18, NULL, '2020-08-01 16:56:17', '1', 1, 'http://cdn.lululuting.com/890d8a20-d156-11ea-9234-d110872d5c43', 30);
INSERT INTO `msg` VALUES (102, '1', 18, '吹喇叭我只服陆?', '2020-08-01 16:56:17', '1', 1, 'http://cdn.lululuting.com/890d8a20-d156-11ea-9234-d110872d5c43', 30);
INSERT INTO `msg` VALUES (103, '2', 1, '看来得加个删评论功能！?', '2020-08-01 17:01:30', '1', 18, '吹喇叭我只服陆?', 30);
INSERT INTO `msg` VALUES (104, '3', 17, NULL, '2020-12-01 19:29:18', '1', 18, 'http://cdn.lululuting.com/f827d3a0-d39c-11ea-b8ad-2d017a18d328', 29);
INSERT INTO `msg` VALUES (105, '3', 2, NULL, '2020-12-10 20:19:46', '1', 1, 'http://cdn.lululuting.com/890d8a20-d156-11ea-9234-d110872d5c43', 30);
INSERT INTO `msg` VALUES (106, '3', 24, NULL, '2020-12-10 20:19:46', '1', 1, 'http://cdn.lululuting.com/6dec2510-9a5d-11ea-b61d-a3be4770de24', 24);
INSERT INTO `msg` VALUES (107, '3', 24, NULL, '2020-12-10 20:19:46', '1', 1, 'http://cdn.lululuting.com/890d8a20-d156-11ea-9234-d110872d5c43', 30);
INSERT INTO `msg` VALUES (108, '1', 1, '愿你在平凡的日子里，熠熠生辉', '2020-12-11 09:18:22', '1', 2, 'http://cdn.lululuting.com/b2705780-3ac4-11eb-9e1e-6f628b0bd260', 32);
INSERT INTO `msg` VALUES (109, '2', 2, '愿你在平凡的日子里，熠熠生辉。', '2020-12-11 17:22:14', '1', 1, '愿你在平凡的日子里，熠熠生辉', 32);
INSERT INTO `msg` VALUES (110, '3', 2, NULL, '2020-12-28 11:50:48', '1', 1, 'http://cdn.lululuting.com/bc37e200-484e-11eb-8094-85b54b98a463', 34);
INSERT INTO `msg` VALUES (111, '3', 18, NULL, '2020-12-29 22:08:08', '1', 1, 'http://cdn.lululuting.com/bc37e200-484e-11eb-8094-85b54b98a463', 34);
INSERT INTO `msg` VALUES (112, '1', 18, '建议改为夜话火炉山', '2020-12-29 22:08:08', '1', 1, 'http://cdn.lululuting.com/52ab5f20-4848-11eb-975c-f5cc15c04cdb', 33);
INSERT INTO `msg` VALUES (113, '3', 18, NULL, '2021-01-03 11:29:52', '1', 2, 'http://cdn.lululuting.com/b2705780-3ac4-11eb-9e1e-6f628b0bd260', 32);
INSERT INTO `msg` VALUES (114, '5', 18, NULL, '2021-02-09 18:33:22', '1', 3, NULL, 18);
INSERT INTO `msg` VALUES (115, '5', 1, NULL, '2021-01-03 11:29:52', '1', 2, NULL, 1);
INSERT INTO `msg` VALUES (116, '4', 1, NULL, '2020-12-31 18:28:51', '0', 18, '建议改为夜话火炉山', 33);
INSERT INTO `msg` VALUES (117, '4', 2, NULL, '2021-01-07 14:51:40', '1', 1, '2021 请继续加油！💪', 21);
INSERT INTO `msg` VALUES (118, '4', 2, NULL, '2021-01-07 14:51:40', '1', 1, '2020 最后一天。flag 完成度大概 50%吧，python和flutter没学，减肥是控制住了。钱没存到，女朋友也还没有找到😪，乐器倒学了。自考本科已经报名了，驾照实在没兴趣。视频素材安详躺在硬盘中说希望不要打扰它。。。', 21);
INSERT INTO `msg` VALUES (119, '3', 1, NULL, '2021-02-25 15:33:07', '1', 3, 'http://cdn.lululuting.com/1eadd330-6ae7-11eb-aee2-2fb170e17949', 37);
INSERT INTO `msg` VALUES (120, '3', 3, NULL, '2021-02-25 17:41:04', '1', 1, 'http://cdn.lululuting.com/b0dae450-74b5-11eb-b709-09d1afa8cb14', 42);
INSERT INTO `msg` VALUES (121, '3', 1, NULL, '2021-03-01 15:40:39', '1', 3, 'http://cdn.lululuting.com/5ecd49e0-773b-11eb-a301-a582216ffde8', 44);
INSERT INTO `msg` VALUES (122, '3', 1, NULL, '2021-03-01 23:03:27', '0', 3, 'http://cdn.lululuting.com/39bc6ba0-7a64-11eb-b141-ef2931a997ca', 47);
INSERT INTO `msg` VALUES (123, '1', 1, '此处应该有掌声👏👏👏', '2021-03-01 23:04:48', '0', 3, 'http://cdn.lululuting.com/39bc6ba0-7a64-11eb-b141-ef2931a997ca', 47);
INSERT INTO `msg` VALUES (124, '1', 1, '加油👍', '2021-03-01 23:06:43', '0', 3, 'http://cdn.lululuting.com/a4b1b700-7a4e-11eb-b705-a73cbb7bebb1', 45);
INSERT INTO `msg` VALUES (125, '3', 1, NULL, '2021-03-01 23:06:46', '0', 3, 'http://cdn.lululuting.com/a4b1b700-7a4e-11eb-b705-a73cbb7bebb1', 45);
INSERT INTO `msg` VALUES (126, '1', 2, '加油', '2021-03-02 10:27:46', '1', 1, 'http://cdn.lululuting.com/b0dae450-74b5-11eb-b709-09d1afa8cb14', 42);
INSERT INTO `msg` VALUES (127, '3', 2, NULL, '2021-03-02 10:27:46', '1', 1, 'http://cdn.lululuting.com/b0dae450-74b5-11eb-b709-09d1afa8cb14', 42);
INSERT INTO `msg` VALUES (128, '2', 1, '👌', '2021-03-10 12:27:02', '0', 2, '加油', 42);
COMMIT;

-- ----------------------------
-- Table structure for type
-- ----------------------------
DROP TABLE IF EXISTS `type`;
CREATE TABLE `type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typeName` varchar(255) NOT NULL DEFAULT '',
  `orderNum` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='类型表';

-- ----------------------------
-- Records of type
-- ----------------------------
BEGIN;
INSERT INTO `type` VALUES (1, '技术', 0);
INSERT INTO `type` VALUES (2, '摄影', 1);
INSERT INTO `type` VALUES (3, '生活', 2);
COMMIT;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'key',
  `userName` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'admin' COMMENT '昵称',
  `password` varchar(255) CHARACTER SET utf8 DEFAULT '$10$ouyBweiOSOd7ifjhLYA7s.IFL4LtppcybkD0yn/Pup0rX9OAvkU62' COMMENT '密码',
  `avatar` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT 'https://gw.alipayobjects.com/zos/antfincdn/XAosXuNZyF/BiazfanxmamNRoxxVxka.png' COMMENT '头像',
  `autograph` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '个性签名',
  `post` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '无业游民' COMMENT '职业',
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '地址',
  `tags` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签',
  `mobile` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `wxReward` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '微信赞赏码',
  `zfbReward` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '支付宝赞赏码',
  `cover` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT 'http://cdn.lululuting.com/ebe15f00-6531-11ea-9ef1-793305692a81' COMMENT '用户中心封面',
  `wbUid` varchar(11) CHARACTER SET utf8 DEFAULT NULL COMMENT '微博用户唯一uid',
  `auth` enum('1','2','0') CHARACTER SET utf8 DEFAULT '0' COMMENT '0普通用户 1 普通博主 2 超级管理员',
  `songsId` int(11) NOT NULL DEFAULT '705619441' COMMENT '网易云歌单id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ----------------------------
-- Records of user (shideshan666)
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES (1, 'Asunarail', '$2a$10$EKKqGVuwjjrM4AQteDhwGueLq4BszJXlz7TAiQcPD0F1/KBfoWqku', 'http://cdn.zjutshideshan.cn/blog_image/avatar.jpg', '这个人很蠢，他什么也不知道', 'coder', '浙江杭州', '美食,运动,coding', NULL, 'http://cdn.zjutshideshan.cn/blog_image/wxReceivingCode.jpg', 'http://cdn.zjutshideshan.cn/blog_image/zfbReceivingCode.jpg', 'http://cdn.zjutshideshan.cn/blog_image/cover3.jpg', '', '2', 705619441);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

