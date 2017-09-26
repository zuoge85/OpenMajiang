
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(32) NOT NULL COMMENT '昵称',
  `open_id` VARCHAR(128) NOT NULL,
  `uuid` VARCHAR(64) NOT NULL COMMENT '用户唯一uuid',
  `avatar` VARCHAR(256) NULL COMMENT '用户头像地址',
  `sex` INT NOT NULL COMMENT '0:女生,1:男生,2:未知',
  `create_date` DATETIME NOT NULL,
  `update_date` DATETIME NOT NULL,
  `version` INT NOT NULL DEFAULT 0,
  `gold` INT NOT NULL DEFAULT 0,
  `history_gold` INT NOT NULL DEFAULT 0,
  `level` INT NOT NULL DEFAULT 0 COMMENT '用户代理级别',
  `mobile` VARCHAR(16) NULL ,
  `login_token` VARCHAR(64) NULL ,
  `ip` VARCHAR(32) NULL DEFAULT 0 COMMENT 'ip',
  `longitude` DOUBLE NOT NULL DEFAULT 0 COMMENT 'ip',
  `latitude` DOUBLE NOT NULL DEFAULT 0 COMMENT 'ip',
  `password` VARCHAR(128) NOT NULL COMMENT '密码',
  PRIMARY KEY (`id`),
  UNIQUE KEY `open_id` (`open_id`),
  UNIQUE KEY `uuid` (`uuid`),
  UNIQUE KEY `mobile` (`mobile`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT '用户';



DROP TABLE IF EXISTS `user_agent_token`;
CREATE TABLE `user_agent_token` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL COMMENT '用户id',
  `token` VARCHAR(64) NULL COMMENT '登录token',
  `create_time` BIGINT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT '用户代理平台登录token';


DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(32) NOT NULL COMMENT '用户名',
  `password` VARCHAR(64) NOT NULL COMMENT '密码',
  `token` VARCHAR(64) NULL COMMENT '登录token',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS `user_login_log`;
CREATE TABLE `user_login_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL COMMENT '用户id',
  `login_date` DATETIME NOT NULL,
  `logout_date` DATETIME NULL,
  `longitude` DOUBLE NULL COMMENT '经度',
  `latitude` DOUBLE NULL COMMENT '纬度',
  `ip` VARCHAR(64) NOT NULL COMMENT 'ip',
  `version` INT NOT NULL DEFAULT 0,
  `login_token` VARCHAR(64) NULL ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS `room_user`;
CREATE TABLE `room_user` (
  `user_id` INT NOT NULL COMMENT '用户id',
  `location_index` INT NOT NULL,
  `room_id` INT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NULL,
  `room_check_id` VARCHAR(10) NULL COMMENT '房间的check-id,进入id,可以重复,但是不允许同时活跃状态的id 相同',
  `version` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  KEY `user_id` (`user_id`),
  KEY `room_id` (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT '每一个玩家对应的房间';


DROP TABLE IF EXISTS `room`;
CREATE TABLE `room` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '牌局id',
  `create_user_id` INT NOT NULL COMMENT '创建用户id',
  `user_max` INT NOT NULL COMMENT '用户数',
  `uuid` VARCHAR(64) NOT NULL COMMENT '牌局uuid',
  `user0` INT NOT NULL COMMENT '用户0',
  `user1` INT NOT NULL COMMENT '用户1',
  `user2` INT NOT NULL COMMENT '用户2',
  `user3` INT NOT NULL COMMENT '用户3',

  `userName0` VARCHAR(32) NULL COMMENT '用户0',
  `userName1` VARCHAR(32) NULL COMMENT '用户1',
  `userName2` VARCHAR(32) NULL COMMENT '用户2',
  `userName3` VARCHAR(32) NULL COMMENT '用户3',

  `score0` INT NOT NULL COMMENT '积分0',
  `score1` INT NOT NULL COMMENT '积分1',
  `score2` INT NOT NULL COMMENT '积分2',
  `score3` INT NOT NULL COMMENT '积分3',
  `room_check_id` VARCHAR(10) NULL COMMENT '房间的check-id,进入id,可以重复,但是不允许同时活跃状态的id 相同',
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NULL,
  `start` BIT(1) NOT NULL,
  `end` BIT(1) NOT NULL COMMENT '正常结束',
  `version` INT NOT NULL DEFAULT 0,
  `scene_id` INT NOT NULL,
  `chapter_nums` INT NOT NULL,
  `config` TEXT NOT NULL COMMENT 'JSON:mj.data.Config;配置',
  PRIMARY KEY (`id`),
  KEY `room_check_id` (`room_check_id`),
  KEY `create_user_id$start` (`room_check_id`,`start`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT '游戏房间';


DROP TABLE IF EXISTS `user_link_room`;
CREATE TABLE `user_link_room` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '牌局id',
  `user_id` INT NOT NULL COMMENT '用户id',
  `room_id` INT NOT NULL COMMENT '房间id',
  `room_check_id` VARCHAR(10) NULL COMMENT '房间的check-id,进入id,可以重复,但是不允许同时活跃状态的id 相同',

  `user0` INT NOT NULL COMMENT '用户0',
  `user1` INT NOT NULL COMMENT '用户1',
  `user2` INT NOT NULL COMMENT '用户2',
  `user3` INT NOT NULL COMMENT '用户3',

  `userName0` VARCHAR(32) NULL COMMENT '用户0',
  `userName1` VARCHAR(32) NULL COMMENT '用户1',
  `userName2` VARCHAR(32) NULL COMMENT '用户2',
  `userName3` VARCHAR(32) NULL COMMENT '用户3',

  `score0` INT NOT NULL COMMENT '积分0',
  `score1` INT NOT NULL COMMENT '积分1',
  `score2` INT NOT NULL COMMENT '积分2',
  `score3` INT NOT NULL COMMENT '积分3',

  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NULL,

  `chapter_nums` INT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT '游戏房间';

DROP TABLE IF EXISTS `room_check_id_pool`;
CREATE TABLE `room_check_id_pool` (
  `id` VARCHAR(11) NOT NULL COMMENT '随机id',
  `state` INT NOT NULL COMMENT '0,未使用,1,在使用,2,缓存',
  PRIMARY KEY (`id`),
  KEY `id$use` (`id`, `state`),
  KEY `state` (`state`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT '游戏房间';





DROP TABLE IF EXISTS `room_result`;
CREATE TABLE `room_result` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'result id',
  `room_id` INT NOT NULL COMMENT '房间id',
  `room_check_id` VARCHAR(10) NULL COMMENT '房间的check-id,进入id,可以重复,但是不允许同时活跃状态的id 相同',
  `scene_id` INT NOT NULL,
  `create_date` DATETIME NOT NULL,
  `user0` INT NOT NULL COMMENT '用户0',
  `user1` INT NOT NULL COMMENT '用户1',
  `user2` INT NOT NULL COMMENT '用户2',
  `user3` INT NOT NULL COMMENT '用户3',

  `userName0` VARCHAR(32) NULL COMMENT '用户0',
  `userName1` VARCHAR(32) NULL COMMENT '用户1',
  `userName2` VARCHAR(32) NULL COMMENT '用户2',
  `userName3` VARCHAR(32) NULL COMMENT '用户3',

  `score0` INT NOT NULL COMMENT '积分0',
  `score1` INT NOT NULL COMMENT '积分1',
  `score2` INT NOT NULL COMMENT '积分2',
  `score3` INT NOT NULL COMMENT '积分3',

  `hu_pai` BIT(1) NOT NULL,
  `hu_pai_index` INT NOT NULL ,
  `zhuang_index` INT NOT NULL ,
  `is_zi_mo` BIT(1) NOT NULL,
  `hui_er` VARCHAR(32)  NULL COMMENT 'JSON:int[];会儿',
  `gang_shang_hua` BIT(1) NOT NULL,
  `last_pai` BIT(1) NOT NULL,
  `fang_pao_index` INT NOT NULL,
  `left` VARCHAR(512) NOT NULL COMMENT 'JSON:int[];剩余牌',
  `user_pai_infos` TEXT NOT NULL COMMENT 'JSON:mj.data.UserPaiInfo[];用户的牌信息',
  PRIMARY KEY (`id`),
  KEY `room_id` (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT '一局游戏结果';



DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(32) NOT NULL COMMENT '用户名',
  `password` VARCHAR(64) NOT NULL COMMENT '密码',
  `token` VARCHAR(64) NULL COMMENT '登录token',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

INSERT INTO `admin` (`name`, `password`) VALUES ('admin', 'jZ_fLAZWkFmFtroR00pIJnY-FuHd4mEOXW8hVVdFkd4');


DROP TABLE IF EXISTS `setting`;
CREATE TABLE `setting` (
  `id` INT NOT NULL COMMENT 'id 永远是1',
  `notice` MEDIUMTEXT NULL  COMMENT '广告（首页）',
  `radio` MEDIUMTEXT NULL COMMENT '广播（跑马灯）',
  `payInfo` MEDIUMTEXT NULL COMMENT '充值信息',
  `agreement` MEDIUMTEXT NULL  COMMENT '用户协议',
  `initGold` INT NOT NULL DEFAULT 0 COMMENT '用户默认房卡',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;




DROP TABLE IF EXISTS `user_agent_token`;
CREATE TABLE `user_agent_token` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL COMMENT '用户id',
  `token` VARCHAR(64) NULL COMMENT '登录token',
  `create_time` BIGINT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT '用户代理平台登录token';