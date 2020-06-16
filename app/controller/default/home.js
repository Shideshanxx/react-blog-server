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
      LEFT JOIN USER u ON a.userId = u.Id
      LEFT JOIN articlelike al ON al.articleId = a.Id AND al.status = '1'
      GROUP BY a.id
      ORDER BY ${id==0? 'createTime':'viewCount'} DESC
      LIMIT ${(page-1)* limit},${limit}
    `

    const result = await this.app.mysql.query(sql)

    this.ctx.body = {
      data: result
    }
  }

}

module.exports = HomeController;
