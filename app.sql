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
  `createTime` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `userId` int(11) DEFAULT '0',
  `tags` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('1','0') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '是否公开， 0公开， 1隐藏',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';

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
INSERT INTO `banner` VALUES (1, 'http://cdn.zjutshideshan.cn/blog_image/advert1.jpg', '', '1', '广告', 1, '2021-01-12 00:20:09', '3');
INSERT INTO `banner` VALUES (2, 'http://cdn.zjutshideshan.cn/blog_image/cover3.jpg', '无', '1', '封面', 1, '2021-02-22 22:55:41', '4');
INSERT INTO `banner` VALUES (3, 'http://cdn.zjutshideshan.cn/a920fab0-e48b-11eb-8d1a-93aa0ede4233', '', '1', '信息中心', 1, '2021-01-12 00:20:09', '5');
INSERT INTO `banner` VALUES (4, 'http://cdn.zjutshideshan.cn/a920fab0-e48b-11eb-8d1a-93aa0ede4233', '无', '1', '搜索页', 1, '2021-02-22 22:55:41', '7');
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
