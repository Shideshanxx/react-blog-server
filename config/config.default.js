/* eslint valid-jsdoc: "off" */

'use strict';

/**
 * @param {Egg.EggAppInfo} appInfo app info
 */
module.exports = appInfo => {
  /**
   * built-in config
   * @type {Egg.EggAppConfig}
   **/
  const config = exports = {};

  // use for cookie sign key, should change to your own and keep security
  config.keys = appInfo.name + '_1578275460678_7382';

  // add your middleware config here
  config.middleware = [];

  // add your user config here
  const userConfig = {
    // myAppName: 'egg',
  };

  // 解除文件上传大小限制
  config.bodyParser = {
    jsonLimit: '100mb',
    formLimit: '100mb',
  };

  // 配置上传
  config.multipart = {
    fileSize: '50mb',
    mode: 'stream',
    fileExtensions: ['.jpg', '.png', '.gif', '.jpeg'], // 扩展几种上传的文件格式
  };

  // egg-jwt token机制 设置密钥
  exports.jwt = {
    secret: "123456" //自己设置的值
  };

  //配置中间件，注意login需要和app/middleware下的login.js对应
  config.middleware = [
    'adminAuth'
  ];

  // 跨域设置
  config.security = {
    csrf: {
      enable: false, // 前后端分离，post请求不方便携带_csrf
      ignoreJSON: true
    },
    domainWhiteList: ['*']
  };

  config.cors = {
    origin: '*', //只允许这个域进行访问接口  ['*'] 是谁都可以访问
    credentials: true, //允许Cookie、session可以跨域
    allowMethods: 'GET,HEAD,PUT,POST,DELETE,PATCH,OPTIONS'
  };


  // 数据库连接配置
  config.mysql = {
    // database configuration
    client: {
      // host
      host: 'localhost',
      // port
      port: '3306',
      // username
      user: 'root',
      // password
      password: 'root',
      // database
      database: 'react_blog',
    },
    // load into app, default is open
    app: true,
    // load into agent, default is close
    agent: false,
  };


  return {
    ...config,
    ...userConfig,
  };
};