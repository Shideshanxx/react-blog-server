"use strict";

const BaseController = require("./BaseController");

const qiniu = require("qiniu");

const accessKey = "m3tlpYv_SumLCH6WA9JcsO2EvFvEQD-v0PGjCDFS";
const secretKey = "DmWgRNlJQM578pmuk0d2CduYOtQeKgw3___TXPvU";
const bucket = "shideshanspace";

class QiniuController extends BaseController {
  //（获取七牛上传token）
  async getQiniuToken() {
    let mac = new qiniu.auth.digest.Mac(accessKey, secretKey);
    let options = {
      scope: bucket,
      expires: 3600 * 24,
    };
    let putPolicy = new qiniu.rs.PutPolicy(options);
    let uploadToken = putPolicy.uploadToken(mac);

    if (uploadToken) {
      this.ctx.body = {
        code: 200,
        data: {
          uploadToken,
        },
      };
    }
  }
}

module.exports = QiniuController;
