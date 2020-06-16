module.exports = app => {
  const { router, controller, jwt } = app

  // 中间件 （路由守卫校验token）
  let adminAuth = app.middleware.adminAuth()

  router.get('/default/getArticleList', controller.default.home.getArticleList)

  router.get('/default/getArticleInfo', controller.default.article.getArticleInfo)
}