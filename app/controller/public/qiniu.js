'use strict';

const BaseController = require('./BaseController');

const qiniu = require("qiniu");

const accessKey = "七牛云accessKey";
const secretKey = "七牛云secretKey";
const bucket = "七牛云静态资源的目录";

class QiniuController extends BaseController {
    //（获取七牛上传token）
    async getQiniuToken() {
        let mac = new qiniu.auth.digest.Mac(accessKey, secretKey);
        let options = {
            scope: bucket,
            expires: 3600 * 24
        };
        let putPolicy = new qiniu.rs.PutPolicy(options);
        let uploadToken = putPolicy.uploadToken(mac);

        if (uploadToken) {
            this.ctx.body = {
                code: 200,
                data: {
                    uploadToken
                }
            }
        }
    }

};

module.exports = QiniuController;