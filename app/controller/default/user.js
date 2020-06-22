'use strict';

const BaseController = require('../public/BaseController');

const bcryptjs = require('bcryptjs');

class UserController extends BaseController {
    // 登录
    async login() {
        let mobile = this.ctx.request.body.mobile;
        let password = this.ctx.request.body.password;

        const res = await this.app.mysql.get('user', {
            mobile: mobile
        })
        if (res && password === res.password) {
        // if (res && bcryptjs.compareSync(password, res.password)) {
            //登录成功,进行toke
            /*
             * sign({根据什么生成token})
             * app.config.jwt.secret 配置的密钥
             * {expiresIn:'24h'} 过期时间
             */
            let token = this.app.jwt.sign({
                userId: res.id,
                userName: res.userName,
                mobile: res.mobile,
                password: res.password,
                auth: res.auth
            }, "123456", {
                expiresIn: '24h'
            })

            // 数据整改和 删除 password 不暴漏出去
            res.userId = res.id
            delete res.id
            delete res.password

            // 查文章  粉丝 赞
            let tSql = `
                SELECT
                (SELECT count(*) FROM fans as f WHERE f.userId = u.id) as fNum,
                (SELECT count(*) FROM article as a WHERE a.userId = u.id) as aNum,
                (SELECT
                count(ac.id) AS count
            FROM
                articleLike AS ac
            LEFT JOIN article a ON a.id = ac.articleId
            LEFT JOIN user u ON u.id = a.userId
            WHERE u.id = ${res.userId} AND ac.status = '1' ) as cNum
                FROM
                user u
                WHERE u.id = ${res.userId}
            `

            // SELECT
            // 	count(ac.id) AS count
            // FROM
            // 	articleLike AS ac
            // LEFT JOIN article a ON a.id = ac.articleId
            // LEFT JOIN user u ON u.id = a.userId
            // WHERE u.id = 2 AND ac.status = '1' 

            const tRes = await this.app.mysql.query(tSql)
            this.ctx.body = {
                'code': 200,
                'msg': '登录成功',
                data: {
                    ...res,
                    ...tRes[0],
                    'token': token
                }
            }
        } else {
            this.ctx.body = {
                'code': 500,
                'msg': '账号或密码错误'
            }
        }
    }

    // 获取用户详细信息
    async getUserInfo() {
        let id = this.ctx.query.id
        let userInfo = null;
        if (this.ctx.request.header.authorization && this.ctx.request.header.authorization !== 'null') {
            userInfo = await this.getTokenInfo()
        }

        const sql = `SElECT 
            u.id AS userId,
            u.userName AS userName,
            u.mobile AS mobile,
            u.avatar AS avatar,
            u.post AS post,
            u.autograph AS autograph,
            u.address AS address,
            u.tags AS tags,
            u.wxReward AS wxReward,
            u.zfbReward AS zfbReward,
            u.auth AS auth,
            ${userInfo ? `f.status AS status,` : ''}
            u.cover AS cover
            FROM 
            user u
            ${userInfo ? `LEFT JOIN fans f ON f.userId = ${id} AND f.fansId = ${userInfo.userId}` : ''}
            WHERE u.id = '${id}'`;

        const sql1 = `SElECT 
            *
            FROM contact WHERE userId = '${id}'`;

        const res = await this.app.mysql.query(sql)
        const res1 = await this.app.mysql.query(sql1)

        // 循环组装数据
        for (let i = 0; i < res.length; i++) {
            // 格式化tags
            res[i].tags = res[i].tags ? res[i].tags.split(',') : []
        }

        if (res.length > 0) {
            this.ctx.body = {
                code: 200,
                data: {
                    ...res[0],
                    contact: res1
                }
            }
        } else {
            this.ctx.body = {
                code: 500,
                msg: '没有该用户'
            }
        }
    }

    // 设置用户信息
    async updateUserInfo() {
        let tmp = this.ctx.request.body
        let userInfo = await this.getTokenInfo()

        tmp.id = userInfo.userId
        const result = await this.app.mysql.update('user', tmp)

        if (result.affectedRows === 1) {
            this.ctx.body = {
                code: 200,
                msg: '操作成功!',
            }
        }
    }

    // 添加或修改联系方式
    async addEditContact() {
        let tmpArticle = this.ctx.request.body
        let userInfo = await this.getTokenInfo()
        tmpArticle.userId = userInfo.userId

        let result;
        if (tmpArticle.id) {
            result = await this.app.mysql.update('contact', tmpArticle)
        } else {
            result = await this.app.mysql.insert('contact', tmpArticle)
        }

        const insertSuccess = result.affectedRows === 1

        if (insertSuccess) {
            this.ctx.body = {
                code: 200,
                msg: '操作成功!',
            }
        }
    }

    //删除联系方式
    async delContact() {
        let id = this.ctx.request.body.id
        let userInfo = await this.getTokenInfo()
        const res = await this.app.mysql.delete('contact', {
            id,
            userId: userInfo.userId
        })
        if (res.affectedRows === 1) {
            this.ctx.body = {
                code: 200,
                msg: '删除成功！'
            }
        }
    }

    //添加或修改赞赏码
    async addEditReward() {
        let tmp = this.ctx.request.body
        let userInfo = await this.getTokenInfo()
        tmp.id = userInfo.userId
        let result = await this.app.mysql.update('user', tmp)
        if (result.affectedRows === 1) {
            this.ctx.body = {
                code: 200,
                msg: '操作成功!',
            }
        }
    }

    // 用户修改密码
    async updatePassword() {
        let oldPassword = this.ctx.request.body.oldPassword
        let password = this.ctx.request.body.newPassword
        let userInfo = await this.getTokenInfo()

        const res = await this.app.mysql.get('user', {
            id: userInfo.userId
        })

        if (res && bcryptjs.compareSync(oldPassword, res.password)) {
            this.ctx.body = {
                code: 500,
                msg: '旧密码不正确!',
            }
        } else {
            const result = await this.app.mysql.update('user', {
                id: userInfo.userId,
                password: bcryptjs.hashSync(password, 10),
            })

            if (result.affectedRows === 1) {
                this.ctx.body = {
                    code: 200,
                    msg: '修改成功!',
                }
            }
        }
    }

    // 绑定手机号
    async updateMobile() {
        let mobile = this.ctx.request.body.mobile
        let userInfo = await this.getTokenInfo()

        const isHas = await this.app.mysql.get('user', {
            mobile: mobile
        })

        if (isHas) {
            this.ctx.body = {
                code: 500,
                msg: '该手机号已有绑定，请换一个试试!',
            }
            return
        }

        const result = await this.app.mysql.update('user', {
            id: userInfo.userId,
            mobile: mobile,
        })

        if (result.affectedRows === 1) {
            this.ctx.body = {
                code: 200,
                msg: '绑定成功, 请重新登录!',
            }
        }

    }

    // 第三方微博登录
    async getWeiboUserInfo() {
        let code = this.ctx.query.code;
        let resData = null;
        const res1 = await this.service.weibo.getWeiboUserInfo(code);

        // xbuid查询数据库有没有绑定微博 方法
        async function getUserInfo(_this, uid) {
            let userInfo = null
            const sql = `SElECT 
                user.id AS userId,
                user.userName AS userName,
                user.mobile AS mobile,
                user.avatar AS avatar,
                user.post AS post,
                user.autograph AS autograph,
                user.address AS address,
                user.tags AS tags,
                user.wxReward AS wxReward,
                user.zfbReward AS zfbReward,
                user.auth AS auth,
                user.cover AS cover
                FROM user WHERE wbUid = '${uid}'`;

            const res = await _this.app.mysql.query(sql)

            // 如果表了以有微博uid 直接返回 生成token登录 并返回该用户信息
            if (res.length) {
                userInfo = res[0]
            }
            return userInfo
        }

        // return toke
        /*
         * sign({根据什么生成token})
         * app.config.jwt.secret 配置的密钥
         * {expiresIn:'24h'} 过期时间
         */
        const returnToken = (userInfo) => {
            let token = this.app.jwt.sign({
                userId: userInfo.userId,
                userName: userInfo.userName,
                mobile: userInfo.mobile || 10086,
                password: userInfo.password,
            }, "123456", {
                expiresIn: '24h'
            })
            return token
        }

        if (res1 && res1.uid) {
            resData = await getUserInfo(this, res1.uid)
            // 没有uid，则查询微博用户信息，绑上，然后生成token登录 再返回该用户信息
            if (!resData) {
                const res3 = await this.ctx.curl(`https://api.weibo.com/2/users/show.json`, {
                    method: 'get',
                    data: {
                        access_token: res1.access_token,
                        uid: res1.uid
                    }
                })

                const info = JSON.parse(res3.data) // 这里根据实际返回的数据进行格式化处理，最后返回一个对象
                const tmp = {
                    wbUid: info.id,
                    userName: info.name,
                    avatar: info.profile_image_url,
                    autograph: info.description,
                }
                const createUserRes = await this.app.mysql.insert('user', tmp)

                resData = {
                    userId: createUserRes.insertId,
                    ...tmp
                }
            }
        }

        resData.token = returnToken(resData)

        // 查文章  粉丝 赞
        let tSql = `
            SELECT
                (SELECT count(*) FROM fans as f WHERE f.userId = u.id) as fNum,
                (SELECT count(*) FROM article as a WHERE a.userId = u.id) as aNum,
                        (SELECT
                    count(ac.id) AS count
                FROM
                    articleLike AS ac
                LEFT JOIN article a ON a.id = ac.articleId
                LEFT JOIN user u ON u.id = a.userId
                WHERE u.id = ${resData.userId} AND ac.status = '1' ) as cNum
            FROM
                user u
            WHERE u.id = ${resData.userId}
        `
        const tRes = await this.app.mysql.query(tSql)
        resData = {
            ...resData,
            ...tRes[0]
        }
        this.ctx.body = {
            code: 200,
            data: resData
        }
    }

    // 关注/取消关注
    async setFollow() {
        let userInfo = await this.getTokenInfo()

        const queryIsHas = await this.app.mysql.get('fans', {
            fansId: userInfo.userId,
            userId: this.ctx.query.id
        })

        if (!queryIsHas) {
            const result = await this.app.mysql.insert('fans', {
                fansId: userInfo.userId,
                userId: this.ctx.query.id
            })

            await this.setMsg({
                type: '5',
                userId: userInfo.userId,
                callUserId: this.ctx.query.id,
                source: null,
                sourceId: userInfo.userId
            })

            if (result.affectedRows === 1) {
                this.ctx.body = {
                    code: 200,
                    msg: '关注成功!',
                    status: true,
                }
            }

        } else {
            if (queryIsHas.status === '0') {
                const result = await this.app.mysql.update('fans', {
                    id: queryIsHas.id,
                    status: '1'
                })
                if (result.affectedRows === 1) {
                    this.ctx.body = {
                        code: 200,
                        msg: '取消关注成功!',
                        status: false,
                    }
                }
            } else {
                const result = await this.app.mysql.update('fans', {
                    id: queryIsHas.id,
                    status: '0'
                })
                if (result.affectedRows === 1) {
                    this.ctx.body = {
                        code: 200,
                        msg: '关注成功!',
                        status: true,
                    }
                }
            }
        }
    }

    // 轮询消息
    async getMsg() {
        let userInfo = await this.getTokenInfo()
        let sql = `
            SElECT 
            m.*,
            u.userName AS userName,
            u.avatar AS avatar
            FROM 
            msg m
            LEFT JOIN user u ON m.userId = u.id
            WHERE m.callUserId = '${userInfo.userId}' AND m.status = '0' AND m.userId != ${userInfo.userId}
            ORDER BY createTime DESC
        `;

        const res = await this.app.mysql.query(sql)

        if (res.length) {
            this.ctx.body = {
                code: 200,
                data: res
            }
        } else {
            this.ctx.body = {
                code: 200,
                data: []
            }
        }
    }

    // 轮询消息列表 不存入redux 本质跟前面接口一个吊样，只是多了一个参数，已读状态在此接口修改
    async getMsgList() {
        let userInfo = await this.getTokenInfo()
        let type = this.ctx.query.type // type 12,34,5,6 没看错 就是4个 或不传

        // 格式化
        const typeSwitch = (key) => {
            key.toString()
            switch (key) {
                case '12':
                    return "(m.type = '1' or m.type = '2') AND"
                case '34':
                    return "(m.type = '3' or m.type = '4') AND"
                case '5':
                    return "m.type = '5' AND"
                case '6':
                    return "m.type = '6' AND"
            }
        }

        let sql = `
            SElECT 
            m.*,
            u.userName AS userName,
            u.avatar AS avatar
            FROM 
            msg m
            LEFT JOIN user u ON m.userId = u.id
            WHERE ${type ? typeSwitch(type) : ''} m.callUserId = '${userInfo.userId}' AND m.userId != ${userInfo.userId}
            ORDER BY createTime DESC
        `;

        const res = await this.app.mysql.query(sql)

        if (res.length) {
            // 循环获取id
            let arr = [];
            res.forEach(element => {
                if (element.status == 0) {
                    arr.push(element.id)
                }
            })

            if (arr.length) {
                let sql1 = `
          UPDATE msg 
              SET status = 1
          WHERE id IN (${arr.join()})
          `
                // 更新状态为已读
                await this.app.mysql.query(sql1)
            }

            this.ctx.body = {
                code: 200,
                data: res
            }
        } else {
            this.ctx.body = {
                code: 200,
                data: []
            }
        }
    }
}

module.exports = UserController;
