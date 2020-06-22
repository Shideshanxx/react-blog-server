module.exports = app => {
  const { router, controller, jwt } = app

  // 中间件 （路由守卫校验token）
  let adminAuth = app.middleware.adminAuth()

  router.get('/default/getArticleList', controller.default.home.getArticleList)
  router.get('/default/getTypeList', controller.default.home.getTypeList)
  router.get('/default/readingVolume', controller.default.home.readingVolume)
  router.get('/default/getRewardCode', controller.default.home.getRewardCode)
  router.post('/default/feedback', controller.default.home.feedback)
  router.get('/default/getSearchList', controller.default.home.getSearchList)
  router.get('/default/getUserArticleList', controller.default.home.getUserArticleList)
  router.get('/default/getUserArticleTotal', controller.default.home.getUserArticleTotal)

  router.post('/default/login', controller.default.user.login)
  router.get('/default/getWeiboUserInfo', controller.default.user.getWeiboUserInfo)
  router.get('/default/getMsg', jwt, controller.default.user.getMsg)
  router.get('/default/getMsgList', jwt, controller.default.user.getMsgList)
  router.get('/default/setFollow', jwt, controller.default.user.setFollow)
  router.get('/default/getUserInfo', controller.default.user.getUserInfo)
  router.post('/default/updateUserInfo', jwt, controller.default.user.updateUserInfo)
  router.post('/default/updatePassword', jwt, controller.default.user.updatePassword)
  router.post('/default/updateMobile', jwt, controller.default.user.updateMobile)
  router.post('/default/addEditContact',jwt, controller.default.user.addEditContact)
  router.post('/default/delContact', jwt, controller.default.user.delContact)
  router.post('/default/addEditReward', jwt, controller.default.user.addEditReward)

  router.get('/default/getArticleInfo', controller.default.article.getArticleInfo)
  router.get('/default/getArticleComment', controller.default.article.getArticleComment)
  router.post('/default/setArticleComment', jwt, controller.default.article.setArticleComment)
  router.post('/default/commentClickLike', jwt, controller.default.article.commentClickLike)
  router.get('/default/articleClickLike', jwt, controller.default.article.articleClickLike) 
  router.get('/default/getLikeStatus', jwt, controller.default.article.getLikeStatus)

  // 七牛云token
  router.get('/default/getQiniuToken',jwt, controller.public.qiniu.getQiniuToken)
}