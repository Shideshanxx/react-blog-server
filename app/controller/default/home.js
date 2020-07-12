'use strict';

const Controller = require('egg').Controller;

class HomeController extends Controller {

  // 根据 id（0,1） 筛选列表 （最新最热）
  async getArticleList() {
    let id = this.ctx.query.id
    let page = this.ctx.query.page
    let limit = this.ctx.query.limit

    let sql = `
      SELECT
        a.id AS id,
        a.typeId AS typeId,
        a.title AS title,
        a.introduce AS introduce,
        a.viewCount AS viewCount,
        a.createTime AS createTime,
        a.userId AS userId,
        a.tags AS tags,
        t.typeName AS typeName,
        u.userName AS userName,
        a.cover AS cover,
        COUNT(al.id) AS likeCount
      FROM
        article a
      LEFT JOIN type t ON a.typeId = t.Id
      LEFT JOIN user u ON a.userId = u.Id
      LEFT JOIN articlelike al ON al.articleId = a.Id AND al.status = '1'
      GROUP BY a.id
      ORDER BY ${id == 0 ? 'createTime' : 'viewCount'} DESC
      LIMIT ${(page - 1) * limit},${limit}
    `

    const result = await this.app.mysql.query(sql)

    this.ctx.body = {
      data: result
    }
  }

  // 根据类别ID（null,1 2 3， 全部 技术 摄影 生活）获得文章列表 
  // 排序 0时间 1热门
  async getTypeList() {
    let type = this.ctx.query.type
    let page = this.ctx.query.page
    let limit = this.ctx.query.limit
    let sort = this.ctx.query.sort

    let sql = `
        SELECT 
        a.id AS id,
        a.typeId AS typeId,
        a.title AS title,
        a.introduce AS introduce,
        a.viewCount AS viewCount,
        a.createTime AS createTime,
        a.userId AS userId,
        a.tags AS tags,
        a.cover AS cover,
        t.typeName as typeName,
        u.userName AS userName,
        COUNT(al.id) AS likeCount
      FROM article a
        LEFT JOIN type t ON a.typeId = t.Id
        LEFT JOIN user u ON a.userId = u.Id
        LEFT JOIN articlelike al ON al.articleId = a.Id AND al.status = '1'
        ${type && 'WHERE typeId=' + type}
        GROUP BY a.id
        ORDER BY ${sort == 0 ? 'createTime' : 'viewCount'}  DESC
        LIMIT ${(page - 1) * limit},${limit}
      `
    const result = await this.app.mysql.query(sql)
    this.ctx.body = {
      code: 200,
      data: result
    }
  }

  // 阅读量
  async readingVolume() {
    let tmp = this.ctx.query

    let sql = `
      SELECT 
        article.viewCount AS viewCount
      FROM article 
      WHERE article.id=${tmp.id}
      `
    const result = await this.app.mysql.query(sql);
    tmp.viewCount = result[0].viewCount + 1

    const result1 = await this.app.mysql.update('article', tmp)
    const insertSuccess = result1.affectedRows === 1

    if (insertSuccess) {
      this.ctx.body = {
        code: 200,
        msg: '操作成功!',
      }
    }
  }

  // 赞赏码
  async getRewardCode() {
    //先配置路由的动态传值，然后再接收值
    let id = this.ctx.query.id

    let sql = `
      SELECT
      user.wxReward AS wxReward,
      user.zfbReward AS zfbReward
      FROM
        user
      WHERE id=${id}
    `
    const result = await this.app.mysql.query(sql)

    this.ctx.body = {
      code: 200,
      data: result
    }
  }

  // 反馈
  async feedback() {
    let tmp = this.ctx.request.body

    if (!tmp.title || !tmp.description) {
      this.ctx.body = {
        code: 500,
        msg: '参数错误!',
      }
      return
    }

    const result = await this.app.mysql.insert('feedback', tmp)
    const insertSuccess = result.affectedRows === 1

    if (insertSuccess) {
      this.ctx.body = {
        code: 200,
        msg: '操作成功!',
      }
    }
  }

  // 搜索列表 文章 
  async getSearchList() {
    let type = this.ctx.query.type
    let searchVal = this.ctx.query.searchVal
    let page = this.ctx.query.page
    let limit = this.ctx.query.limit
    let sort = this.ctx.query.sort

    let sql = ''

    if (~~type == 0) {
      sql = `
      SELECT 
        article.*,
        type.typeName as typeName,
        user.userName AS userName
      FROM article 
        LEFT JOIN type ON article.typeId = type.Id
        LEFT JOIN user ON article.userId = user.Id
        WHERE article.title 
        LIKE '%${searchVal}%' 
        ORDER BY ${~~sort == 0 ? 'createTime' : 'viewCount'}  DESC
        LIMIT ${(page - 1) * limit},${limit}
      `
    } else {
      sql = `
      SELECT
        user.id AS id,
        user.userName AS userName,
        user.tags AS tags,
        user.avatar AS avatar,
        user.post AS post,
        user.address AS address,
        user.autograph AS autograph
      FROM
        user
      WHERE user.userName  
      LIKE '%${searchVal}%'
      `
    }

    const result = await this.app.mysql.query(sql)

    this.ctx.body = {
      code: 200,
      data: result
    }
  }

  // 文章总数 
  async getUserArticleTotal() {
    let id = this.ctx.query.id
    let sql1 = `SELECT COUNT(id) as total FROM article WHERE typeId = 1 AND article.userId = ${id}`
    let sql2 = `SELECT COUNT(id) as total FROM article WHERE typeId = 2 AND article.userId = ${id}`
    let sql3 = `SELECT COUNT(id) as total FROM article WHERE typeId = 3 AND article.userId = ${id}`

    const total1 = await this.app.mysql.query(sql1)
    const total2 = await this.app.mysql.query(sql2)
    const total3 = await this.app.mysql.query(sql3)

    this.ctx.body = {
      code: 200,
      data: {
        js: total1[0].total,
        sy: total2[0].total,
        shh: total3[0].total,
      }
    }
  }

  // 当前用户发表的文章列表 type（1,2,3） page limit 
  async getUserArticleList() {
    let type = this.ctx.query.type
    let id = this.ctx.query.id
    let page = this.ctx.query.page
    let limit = this.ctx.query.limit
    let sort = this.ctx.query.sort

    let sql = `
      SELECT
        article.*,
        type.id AS typeId,
        user.userName AS userName,
        COUNT(al.id) AS likeCount
      FROM
        article
        LEFT JOIN type ON article.typeId = type.Id
        LEFT JOIN user ON article.userId = user.Id
        LEFT JOIN articlelike al ON al.articleId = article.Id AND al.status = '1'
      WHERE article.userId = ${id}
        ${type && "AND article.typeId = " + type}
      GROUP BY article.id
      ORDER BY ${~~sort == 0 ? 'createTime' : 'viewCount'}  DESC
      LIMIT ${(page - 1) * limit},${limit}
    `
    const result = await this.app.mysql.query(sql)

    this.ctx.body = {
      code: 200,
      data: result
    }
  }
}

module.exports = HomeController;
