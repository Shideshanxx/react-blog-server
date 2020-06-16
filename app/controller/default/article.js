'use strict';

const BaseController = require('../public/BaseController');

class ArticleController extends BaseController {

  // 根据id获取文章详情
  async getArticleInfo() {
    //先配置路由的动态传值，然后再接收值
    let id = this.ctx.query.id

    let sql = `
      SELECT
        a.*, 
        t.typeName AS typeName,
        u.userName AS userName,
        u.avatar AS avatar,
        u.id AS userId,
        count( al.id ) AS count
      FROM
        article a
      LEFT JOIN type t ON a.typeId = t.id
      LEFT JOIN user u ON a.userId = u.id
      LEFT JOIN articleLike al ON al.articleId = a.id AND al.STATUS = 1 
      WHERE a.id=${id}
    `
    const result = await this.app.mysql.query(sql)

    this.ctx.body = {
      code: 200,
      data: result
    }
  }
}

module.exports = ArticleController;
