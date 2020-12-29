const Service = require('egg').Service;

class QiniuService extends Service {
  async getToken() {
    const { config } = this;
　　// config.url是接口的公共地址，推荐在app/config/config.default.js配置
    const re = await this.ctx.curl(`${config.url}/token`);
    const res = JSON.parse(re.data);
    return res.result;
  }
}

module.exports = QiniuService;