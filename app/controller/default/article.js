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

  // 获取文章评论
  async getArticleComment() {
    let sql = `
          SELECT
          c.*,
          count( l.id ) AS likeNum,
          u.avatar AS avatar,
          u.userName AS userName 
        FROM
          COMMENT c
          LEFT JOIN USER u ON c.userId = u.Id
          LEFT JOIN commentlike l ON l.commentId = c.id 
          AND l.STATUS = 1 
        WHERE
          c.articleId = ${this.ctx.query.id}
        GROUP BY
          c.id
        ORDER BY createTime DESC
    `

    const result = await this.app.mysql.query(sql)

    this.ctx.body = {
      code: 200,
      data: result
    }
  }

  // 添加评论
  async setArticleComment() {
    let param = this.ctx.request.body
    let userInfo = await this.getTokenInfo()
    param.userId = userInfo.userId

    let callUser = null
    if (param.articleId) {
      callUser = await this.app.mysql.get('article', {
        id: param.articleId
      })
    } else {
      callUser = await this.app.mysql.get('comment',{
        id: param.commentId
      })
      param.articleId = callUser.articleId
    }

    if(param.commentId){
      param.pid = param.commentId
      delete param.commentId
    }

    const result = await this.app.mysql.insert('comment', param)
    const insertSuccess = result.affectedRows === 1

    if (insertSuccess) {
      // 带commentId就是回复 没带就是评论
      console.log(callUser)
      console.log(callUser.cover ? '1' : '2', callUser.pid)
      await this.setMsg({
        type: callUser.cover ? '1' : '2',
        userId: userInfo.userId,
        callUserId: callUser.userId,
        content: param.content,
        source: callUser.cover ?  callUser.cover : callUser.content,
        sourceId: callUser.cover ?  callUser.id : callUser.articleId,
      })

      this.ctx.body = {
        code: 200,
        msg: '评论成功!',
      }
    }
  }

  // 查询文章点赞状态
  async getLikeStatus () {
    let userInfo = await this.getTokenInfo()
    const result = await this.app.mysql.get('articleLike', {
      userId: userInfo.userId,
      articleId: this.ctx.query.id
    });

    let sql = `SELECT COUNT(id) as count FROM articleLike WHERE articleId = ${this.ctx.query.id} AND status = '1'`
    const countRes = await this.app.mysql.query(sql)

    this.ctx.body = {
      code: 200,
      data:{
        count: countRes[0].count,
        status: result ? result.status : '0'
      }
    }
  }

  // 文章点赞
  async articleClickLike() {
    let userInfo = await this.getTokenInfo()

    const queryIsHas = await this.app.mysql.get('articleLike', {
      userId: userInfo.userId,
      articleId: this.ctx.query.id
    });

    if(!queryIsHas){
      const result = await this.app.mysql.insert('articleLike', {
        userId: userInfo.userId,
        articleId: this.ctx.query.id,
      });

      if (result.affectedRows === 1) {
        this.ctx.body = {
          code: 200,
          msg: '谢谢老铁!',
        }
      }

    }else{
      const result = await this.app.mysql.update('articleLike', {
        id: queryIsHas.id,
        status: queryIsHas.status === '1' ? '0' : '1'
      });
      
      if (result.affectedRows === 1) {
        this.ctx.body = {
          code: 200,
          msg: '修改成功!',
        }
      }
    }
  }

  // 评论点赞
  async commentClickLike() {
    let param = this.ctx.request.body
    let userInfo = await this.getTokenInfo()

    const commentInfo = await this.app.mysql.get('comment',{
      id: param.commentId
    })

    const queryIsHas = await this.app.mysql.get('commentLike',{
      userId: userInfo.userId,
      articleId: commentInfo.articleId,
      commentId: param.commentId
    })


    if (!queryIsHas) {
      const result = await this.app.mysql.insert('commentlike', {
        commentId: param.commentId,
        userId: userInfo.userId,
        articleId: commentInfo.articleId
      })

      await this.setMsg({
        type: '4',
        userId: userInfo.userId,
        callUserId: commentInfo.userId,
        source: commentInfo.content,
        sourceId: commentInfo.articleId,
      })

      if (result.affectedRows === 1) {
        this.ctx.body = {
          code: 200,
          msg: '点赞成功!',
        }
      }

    } else {

      if (queryIsHas.status === '1') {
        const result = await this.app.mysql.update('commentlike', {
          id: queryIsHas.id,
          status: '0'
        })
        if (result.affectedRows === 1) {
          this.ctx.body = {
            code: 200,
            msg: '取消点赞成功!',
          }
        }
      } else {
        const result = await this.app.mysql.update('commentlike', {
          id: queryIsHas.id,
          status: '1'
        })
        if (result.affectedRows === 1) {
          this.ctx.body = {
            code: 200,
            msg: '点赞成功!',
          }
        }
      }
    }
  }
}

module.exports = ArticleController;
