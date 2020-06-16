'use strict';

//配置mysql
exports.mysql = {
  enable: true,
  package: 'egg-mysql'
}

exports.cors = {
  enable: true,
  package: 'egg-cors'
}

// egg-jwt token机制
exports.jwt = {
  enable: true,
  package: "egg-jwt"
};