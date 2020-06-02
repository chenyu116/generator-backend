/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : PostgreSQL
 Source Server Version : 110007
 Source Host           : localhost:5432
 Source Catalog        : smartsign3
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 110007
 File Encoding         : 65001

 Date: 26/05/2020 18:16:42
*/


-- ----------------------------
-- Table structure for n_project_features
-- ----------------------------
DROP TABLE IF EXISTS "public"."n_project_features";
CREATE TABLE "public"."n_project_features" (
  "project_features_id" int4 NOT NULL DEFAULT nextval('n_project_features_project_features_id_seq'::regclass),
  "project_features_type" varchar(255) COLLATE "pg_catalog"."default",
  "feature_id" int4,
  "project_features_config" json,
  "project_id" int4,
  "feature_version_id" int4,
  "project_features_deploy_to" int4,
  "project_features_thumbnail" varchar(255) COLLATE "pg_catalog"."default",
  "project_features_sort_order" int2,
  "project_features_install_name" varchar(255) COLLATE "pg_catalog"."default",
  "project_features_route_path" varchar(255) COLLATE "pg_catalog"."default",
  "project_features_name" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."n_project_features" OWNER TO "postgres";

-- ----------------------------
-- Records of n_project_features
-- ----------------------------
BEGIN;
INSERT INTO "public"."n_project_features" VALUES (57, 'page', 10, '{"data":{"name":"","template":"Index.vue","values":[{"key":"icon","formType":"input","value":"help","name":"图标"},{"key":"title","formType":"input","value":"help","name":"顶部显示名称"},{"key":"routePath","formType":"input","value":"/help","name":"路由地址"},{"key":"iconImage","formType":"upload","value":"1e39b544-9f04-11ea-bcd4-002590262a96.png","name":"图片图标"}]},"dependencies":[],"components":[]}', 145, 10, 0, NULL, 0, 'help-1.0-page', '', 'help');
INSERT INTO "public"."n_project_features" VALUES (59, 'block', 8, '{"data":{"name":"","template":"Index.vue","values":[{"key":"title","formType":"input","value":"旅游天气","name":"标题"},{"key":"subtitle","formType":"input","value":"本地天气状况","name":"副标题"},{"key":"location","formType":"input","value":"zhuhai","name":"地区"}]},"dependencies":["indexedDB"],"components":[]}', 145, 8, 0, NULL, 0, 'weather-1.0-block-d3a8e7d5', '', 'weather');
INSERT INTO "public"."n_project_features" VALUES (58, 'background', 9, '{"data":{"name":"数据表创建","template":"index.js","values":[{"key":"mapPolygons","formType":"input","value":"{\"keyPath\":\"map_gid\"}","name":"mapPolygons"},{"key":"mapPolygonAddress","formType":"input","value":"{\"keyPath\":\"map_gid\"}","name":"mapPolygonAddress"},{"key":"events","formType":"input","value":"{\"keyPath\":\"map_gid\"}","name":"events"},{"key":"panorama","formType":"input","value":"{\"keyPath\":\"project_id\"}","name":"panorama"},{"key":"recommentRoutes","formType":"input","value":"{\"keyPath\":\"scenic_category_id\"}","name":"recommentRoutes"},{"key":"language","formType":"input","value":"{\"keyPath\":\"locale\"}","name":"language"},{"key":"banner","formType":"input","value":"{\"keyPath\":\"image_type\"}","name":"banner"},{"key":"articles","formType":"input","value":"{\"keyPath\":\"article_category_id\"}","name":"articles"},{"key":"article","formType":"input","value":"{\"keyPath\":\"article_id\"}","name":"article"},{"key":"mapCategory","formType":"input","value":"{\"keyPath\":\"map_polygon_category_id\"}","name":"mapCategory"},{"key":"mapCategoryPolygon","formType":"input","value":"{\"keyPath\":\"map_polygon_category_id\"}","name":"mapCategoryPolygon"}]},"dependencies":[],"components":[]}', 145, 9, 0, NULL, 0, 'indexedDB-1.0-background', '', 'indexedDB');
INSERT INTO "public"."n_project_features" VALUES (60, 'block', 11, '{"data":{"name":"","template":"Index.vue","values":[{"key":"title","formType":"input","value":"热门景点","name":"标题"},{"key":"subtitle","formType":"input","value":"火爆的景点","name":"副标题"},{"key":"imageType","formType":"input","value":"round","name":"图片分类"},{"key":"slidesPerView","formType":"input","value":3,"name":"图片预览数量"},{"key":"spaceBetween","formType":"input","value":40,"name":"图片间距"},{"key":"imageWidth","formType":"input","value":"120px","name":"图片宽度"},{"key":"imageHeight","formType":"input","value":"80px","name":"图片高度"}]},"dependencies":["indexedDB"],"components":[]}', 145, 11, 0, NULL, 0, 'imageSlide-1.0-block-7459570c', '', '首页热门景点');
INSERT INTO "public"."n_project_features" VALUES (48, 'page', 7, '{"data":{"name":"","template":"Index.vue","values":[{"key":"icon","formType":"input","value":"class","name":"图标"},{"key":"title","formType":"input","value":"details","name":"顶部显示名称"},{"key":"routePath","formType":"input","value":"/details/:id","name":"路由地址"},{"key":"iconImage","formType":"upload","value":"","name":"图标"}]},"dependencies":["indexedDB"],"components":[]}', 145, 7, 0, NULL, NULL, 'articleDetails-1.0-page-4f5a4952', '', '文章详情');
INSERT INTO "public"."n_project_features" VALUES (52, 'block', 6, '{"data":{"name":"","template":"Index.vue","values":[{"key":"title","formType":"input","value":"活动列表","name":"标题"},{"key":"subtitle","formType":"input","value":"活动列表","name":"副标题"},{"key":"articleCategoryId","formType":"input","value":"222","name":"文章分类编号"},{"key":"articleShowCount","formType":"input","value":3,"name":"文章显示数量"}]},"dependencies":["indexedDB"],"components":[{"name":"文章详情功能","template":"Index.vue","key":"articleDetails","limit":1,"accept":["page"],"values":[{"project_features_id":48,"project_features_config":{"data":{"name":"","template":"Index.vue","values":[{"key":"icon","formType":"input","value":"class","name":"图标"},{"key":"title","formType":"input","value":"details","name":"顶部显示名称"},{"key":"routePath","formType":"input","value":"/details/:id","name":"路由地址"},{"key":"iconImage","formType":"upload","value":"","name":"图标"}]},"dependencies":["indexedDB"],"components":[]}}]}]}', 145, 6, 0, NULL, 0, 'articleBlock-1.0-block-a4750b5c', '', '活动列表');
INSERT INTO "public"."n_project_features" VALUES (49, 'block', 6, '{"data":{"name":"","template":"Index.vue","values":[{"key":"title","formType":"input","value":"最新资讯","name":"标题"},{"key":"subtitle","formType":"input","value":"最新的实时热点消息","name":"副标题"},{"key":"articleCategoryId","formType":"input","value":"122","name":"文章分类编号"},{"key":"articleShowCount","formType":"input","value":3,"name":"文章显示数量"}]},"dependencies":["indexedDB"],"components":[{"name":"文章详情功能","template":"Index.vue","key":"articleDetails","limit":1,"accept":["page"],"values":[{"project_features_id":48,"project_features_config":{"data":{"name":"","template":"Index.vue","values":[{"key":"icon","formType":"input","value":"class","name":"图标"},{"key":"title","formType":"input","value":"details","name":"顶部显示名称"},{"key":"routePath","formType":"input","value":"/details/:id","name":"路由地址"},{"key":"iconImage","formType":"upload","value":"","name":"图标"}]},"dependencies":["indexedDB"],"components":[]}}]}]}', 145, 6, 0, NULL, 11, 'articleBlock-1.0-block-c482b54c', '', '首页最新资讯');
COMMIT;

-- ----------------------------
-- Table structure for n_feature
-- ----------------------------
DROP TABLE IF EXISTS "public"."n_feature";
CREATE TABLE "public"."n_feature" (
  "feature_id" int4 NOT NULL,
  "feature_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "feature_labels" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "feature_types" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "feature_intro" varchar(255) COLLATE "pg_catalog"."default",
  "feature_thumbnail" varchar(255) COLLATE "pg_catalog"."default",
  "feature_onboot" bool DEFAULT false,
  "feature_reuse" bool DEFAULT false
)
;
ALTER TABLE "public"."n_feature" OWNER TO "postgres";

-- ----------------------------
-- Records of n_feature
-- ----------------------------
BEGIN;
INSERT INTO "public"."n_feature" VALUES (3, 'i18n', 'i18n', 'language', '多语言支持', NULL, 't', 'f');
INSERT INTO "public"."n_feature" VALUES (4, 'wexin-jssdk', 'wexin-jssdk', 'background', '微信JSSDK支持，蓝牙，语音搜索依赖此功能', NULL, 't', 'f');
INSERT INTO "public"."n_feature" VALUES (1, 'websocketIO', 'websocket', 'background', '用于向前端发送消息或命令页面', NULL, 't', 'f');
INSERT INTO "public"."n_feature" VALUES (9, 'indexedDB', 'indexedDB', 'background', 'indexedDB数据库支持', NULL, 't', 'f');
INSERT INTO "public"."n_feature" VALUES (5, 'ibeacon', 'ibeacon', 'background', '蓝牙功能，需要依赖微信JSSDK，用于手机和智能设备交互', NULL, 't', 'f');
INSERT INTO "public"."n_feature" VALUES (8, 'weather', 'weather', 'block', '当天天气信息', NULL, 'f', 'f');
INSERT INTO "public"."n_feature" VALUES (6, 'articleBlock', 'article', 'block', '文章列表功能块', NULL, 'f', 't');
INSERT INTO "public"."n_feature" VALUES (2, 'yuexiuIndex', 'entrance', 'entrance', '越秀首页模板', NULL, 'f', 'f');
INSERT INTO "public"."n_feature" VALUES (7, 'articleDetails', 'articleDetails', 'page', '文章详情显示', NULL, 'f', 't');
INSERT INTO "public"."n_feature" VALUES (10, 'help', 'help', 'page', '帮助页', NULL, 'f', 'f');
INSERT INTO "public"."n_feature" VALUES (11, 'imageSlide', 'imageSlide', 'block', '横向图片滑动展示功能', NULL, 'f', 't');
COMMIT;

-- ----------------------------
-- Table structure for n_feature_version
-- ----------------------------
DROP TABLE IF EXISTS "public"."n_feature_version";
CREATE TABLE "public"."n_feature_version" (
  "feature_version_id" int4 NOT NULL DEFAULT nextval('n_feature_version_feature_version_id_seq'::regclass),
  "feature_version_config" json,
  "feature_version_name" varchar(255) COLLATE "pg_catalog"."default",
  "feature_version_create_at" int4,
  "feature_id" int4,
  "feature_version_intro" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."n_feature_version" OWNER TO "postgres";

-- ----------------------------
-- Records of n_feature_version
-- ----------------------------
BEGIN;
INSERT INTO "public"."n_feature_version" VALUES (3, '{"dependencies":["indexedDB"],"data":{},"components":[]}', '1.0', NULL, 3, NULL);
INSERT INTO "public"."n_feature_version" VALUES (1, '{"data":{"connection":"","actionPrefix":"","mutationPrefix":""}}', '1.0', NULL, 1, NULL);
INSERT INTO "public"."n_feature_version" VALUES (4, '{"data":{"connection":"","actionPrefix":"","mutationPrefix":""}}', '1.0', NULL, 4, NULL);
INSERT INTO "public"."n_feature_version" VALUES (5, '{"store":true,"dependencies":["wexin-jssdk"]}', '1.0', NULL, 5, NULL);
INSERT INTO "public"."n_feature_version" VALUES (7, '{"data":{"name":"","template":"Index.vue","values":[{"name":"图标","formType":"input","key":"icon","value":"class"},{"name":"顶部显示名称","formType":"input","key":"title","value":"details"},{"name":"路由地址","formType":"input","key":"routePath","value":"/details/:id"},{"name":"图标","formType":"upload","key":"iconImage","value":""}]},"components":[],"dependencies":["indexedDB"]}', '1.0', NULL, 7, NULL);
INSERT INTO "public"."n_feature_version" VALUES (6, '{"data":{"name":"","template":"Index.vue","values":[{"name":"标题","formType":"input","key":"title","value":""},{"name":"副标题","formType":"input","key":"subtitle","value":""},{"name":"文章分类编号","formType":"input","key":"articleCategoryId","value":""},{"name":"文章显示数量","formType":"input","key":"articleShowCount","value":3}]},"components":[{"name":"文章详情功能","accept":["page"],"template":"Index.vue","key":"articleDetails","values":[],"limit":1}],"dependencies":["indexedDB"]}', '1.0', NULL, 6, NULL);
INSERT INTO "public"."n_feature_version" VALUES (8, '{"data":{"name":"","template":"Index.vue","values":[{"name":"标题","formType":"input","key":"title","value":""},{"name":"副标题","formType":"input","key":"subtitle","value":""},{"name":"地区","formType":"input","key":"location","value":""}]},"components":[],"dependencies":["indexedDB"]}', '1.0', NULL, 8, NULL);
INSERT INTO "public"."n_feature_version" VALUES (2, '{"data":{"name":"","template":"Index.vue","values":[{"name":"首页背景图","formType":"upload","key":"homeBg","value":""}]},"components":[{"name":"首页功能按键","accept":["page"],"template":"Index.vue","key":"nav","values":[],"limit":8},{"name":"首页下方功能区","accept":["block"],"template":"Index.vue","key":"blocks","values":[],"limit":0},{"name":"多语言切换","accept":["language"],"template":"Index.vue","key":"language","values":[],"limit":1}],"dependencies":[]}', '1.0', NULL, 2, NULL);
INSERT INTO "public"."n_feature_version" VALUES (10, '{"data":{"name":"","template":"Index.vue","values":[{"name":"图标","formType":"input","key":"icon","value":"class"},{"name":"顶部显示名称","formType":"input","key":"title","value":"details"},{"name":"路由地址","formType":"input","key":"routePath","value":"/help"},{"name":"图片图标","formType":"upload","key":"iconImage","value":""}]},"components":[],"dependencies":[]}', '1.0', NULL, 10, NULL);
INSERT INTO "public"."n_feature_version" VALUES (11, '{"data":{"name":"","template":"Index.vue","values":[{"name":"标题","formType":"input","key":"title","value":""},{"name":"副标题","formType":"input","key":"subtitle","value":""},{"name":"图片分类","formType":"input","key":"imageType","value":""},{"name":"图片预览数量","formType":"input","key":"slidesPerView","value":3},{"name":"图片间距","formType":"input","key":"spaceBetween","value":40},{"name":"图片宽度","formType":"input","key":"imageWidth","value":"120px"},{"name":"图片高度","formType":"input","key":"imageHeight","value":"80px"}]},"components":[],"dependencies":["indexedDB"]}', '1.0', NULL, 11, NULL);
INSERT INTO "public"."n_feature_version" VALUES (9, '{"data":{"name":"数据表创建","template":"index.js","values":[{"name":"mapPolygons","formType":"input","key":"mapPolygons","value":"{\"keyPath\":\"map_gid\"}"},{"name":"mapPolygonAddress","formType":"input","key":"mapPolygonAddress","value":"{\"keyPath\":\"map_gid\"}"},{"name":"events","formType":"input","key":"events","value":"{\"keyPath\":\"map_gid\"}"},{"name":"panorama","formType":"input","key":"panorama","value":"{\"keyPath\":\"project_id\"}"},{"name":"recommentRoutes","formType":"input","key":"recommentRoutes","value":"{\"keyPath\":\"scenic_category_id\"}"},{"name":"language","formType":"input","key":"language","value":"{\"keyPath\":\"locale\"}"},{"name":"banner","formType":"input","key":"banner","value":"{\"keyPath\":\"image_type\"}"},{"name":"articles","formType":"input","key":"articles","value":"{\"keyPath\":\"article_category_id\"}"},{"name":"article","formType":"input","key":"article","value":"{\"keyPath\":\"article_id\"}"},{"name":"mapCategory","formType":"input","key":"mapCategory","value":"{\"keyPath\":\"map_polygon_category_id\"}"},{"name":"mapCategoryPolygon","formType":"input","key":"mapCategoryPolygon","value":"{\"keyPath\":\"map_polygon_category_id\"}"}]},"components":[],"dependencies":[]}', '1.0', NULL, 9, '创建indexedDB数据表
创建indexedDB数据表
创建indexedDB数据表
创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表创建indexedDB数据表');
COMMIT;

-- ----------------------------
-- Primary Key structure for table n_project_features
-- ----------------------------
ALTER TABLE "public"."n_project_features" ADD CONSTRAINT "n_project_features_pkey" PRIMARY KEY ("project_features_id");

-- ----------------------------
-- Primary Key structure for table n_feature
-- ----------------------------
ALTER TABLE "public"."n_feature" ADD CONSTRAINT "n_feature_pkey" PRIMARY KEY ("feature_id");

-- ----------------------------
-- Primary Key structure for table n_feature_version
-- ----------------------------
ALTER TABLE "public"."n_feature_version" ADD CONSTRAINT "n_feature_version_pkey" PRIMARY KEY ("feature_version_id");
