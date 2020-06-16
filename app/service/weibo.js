const Service = require('egg').Service;

const client_id = 3392355539;
const client_secret = '你的微博client_secret';
const redirect_uri = `你的微博redirect_uri`;


class WeiboService extends Service {
    async getWeiboUserInfo(code) {
        const res = await this.ctx.curl(`https://api.weibo.com/oauth2/access_token`, {
            dataType: 'json',
            method: 'POST',
            data: {
                client_id,
                client_secret,
                redirect_uri,
                grant_type: 'authorization_code',
                code,
            }
        })

        return res.data
    }
}

module.exports = WeiboService;