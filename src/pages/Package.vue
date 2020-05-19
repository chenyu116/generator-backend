<template>
  <div class="q-pa-md row items-start q-gutter-md">
    <Back />
    <div class="text-center" v-if="loading">
      <q-spinner-pie color="grey" size="xl" v-if="!error" />
      <div v-if="error">
        <q-btn icon="refresh" class="q-ml-md" dense="" @click="getFeature()">
          重新读取</q-btn
        ><br />
        {{ error }}
      </div>
    </div>
    <template v-if="!loading && !error">
      <q-card class="my-card">
        <q-tabs
          v-model="tab"
          class="text-grey"
          active-color="primary"
          indicator-color="primary"
          narrow-indicator
        >
          <q-tab name="info" label="信息" />
          <q-tab name="files" label="文件" />
        </q-tabs>

        <q-separator />

        <q-tab-panels v-model="tab">
          <q-tab-panel name="info">
            <!-- <q-img :src="item.project_content" height="260px">
          <div class="absolute-bottom">
            <div class="text-subtitle2">{{ item.project_name }}</div>
          </div>
        </q-img> -->
            <q-card-section class="text-h3">
              {{ feature.feature_name }}
            </q-card-section>
            <q-card-section class="text-subtitle1">
              {{ feature.feature_intro }}
            </q-card-section>
            <q-card-section class="">
              labels:
              <q-chip v-for="(label, i) in feature.feature_labels" :key="i">{{
                label
              }}</q-chip>
            </q-card-section>
            <q-card-section class="select">
              类型选择:
              <q-select
                filled=""
                :options="feature.feature_types"
                v-model="form.type"
                dense=""
              />
            </q-card-section>
            <q-card-section class="select">
              版本选择:
              <q-select
                filled=""
                :options="feature.feature_version"
                v-model="form.version"
                dense=""
              />
            </q-card-section>
            <q-card-section class="">
              版本说明:
              <div class="" v-html="versionIntro"></div>
            </q-card-section>
            <q-card-section class="">
              配置:

              <template v-for="(cf, indexConfig) in config.data">
                <q-item-label
                  class="bg-blue q-pa-xs text-white"
                  :key="`name-${indexConfig}`"
                  >{{ cf.name }}</q-item-label
                >
                <div class="row col-12 q-mt-md" :key="`add-${indexConfig}`">
                  <q-input
                    filled=""
                    dense=""
                    style="width:20%"
                    v-model="add.key"
                  /><span class="text-h5">:</span>
                  <q-input
                    style="width:65%"
                    filled=""
                    dense=""
                    v-model="add.value"
                  />
                  <q-btn flat="" icon="add" @click="addParam(indexConfig)"
                    >添加</q-btn
                  >
                </div>
                <div
                  class="row col-12 q-mt-md"
                  :key="`div-${indexValue}`"
                  v-for="(cfValue, indexValue) in cf.values"
                >
                  <q-input
                    filled=""
                    dense=""
                    style="width:20%"
                    v-model="cfValue.key"
                  /><span class="text-h5">:</span>
                  <q-input
                    style="width:65%"
                    filled=""
                    dense=""
                    v-model="cfValue.value"
                  />
                  <q-btn
                    flat=""
                    icon="delete"
                    @click="delParam(indexConfig, indexValue)"
                    >删除</q-btn
                  >
                </div>
              </template>
            </q-card-section>
            <q-card-actions align="center">
              <q-btn
                color="green"
                icon="link"
                size="18px"
                @click="install()"
                v-if="!feature.project_features_id"
              >
                安装</q-btn
              >
            </q-card-actions>
            <q-card-section :class="`text-red`">{{
              installStatus.message
            }}</q-card-section>
          </q-tab-panel>

          <q-tab-panel name="files">
            <q-splitter v-model="splitterModel" style="height: 400px">
              <template v-slot:before>
                <div class="q-pa-md">
                  <q-tree
                    :nodes="simple"
                    node-key="label"
                    selected-color="primary"
                    :selected.sync="selected"
                    default-expand-all
                  />
                </div>
              </template>

              <template v-slot:after>
                <q-tab-panels
                  v-model="selected"
                  transition-prev="jump-up"
                  transition-next="jump-up"
                >
                  <q-tab-panel name="default"></q-tab-panel>
                  <q-tab-panel name="Food">
                    <textarea
                      style="width:100%;height: 600px"
                      v-model="currentFile.code"
                    ></textarea>
                  </q-tab-panel>
                </q-tab-panels>
              </template>
            </q-splitter>
          </q-tab-panel>
        </q-tab-panels>
      </q-card>
    </template>
  </div>
</template>

<script>
export default {
  name: "Package",
  created() {
    if (
      !this.$store.state.currentProject.project_id ||
      !this.$route.params.featureId ||
      this.$route.params.featureId <= 0
    ) {
      return this.$router.push("/");
    }
    // const projectId = parseInt(this.$route.params.id);
    // console.log(project_id, this.$store.state.currentProject.project_id);
    // if (
    //   !projectId ||
    //   projectId != this.$store.state.currentProject.project_id
    // ) {
    //   return this.$router.push("/");
    // }
    // this.getProjectFeatured();
    this.featureId = this.$route.params.featureId;
    this.getFeature();
  },
  watch: {
    form: {
      deep: true,
      handler(val) {
        console.log("watch form", val);
        if (val.version && val.version.feature_version_intro) {
          this.versionIntro = val.version.feature_version_intro.replace(
            /\n/g,
            "<br />"
          );
        }
        if (
          val.version &&
          val.version.feature_version_config &&
          val.version.feature_version_config.data &&
          val.version.feature_version_id !== this.config.feature_version_id
        ) {
          this.config = {
            feature_version_id: val.version.feature_version_id,
            data: []
          };
          const baseConfig = val.version.feature_version_config.data;
          const config = [];

          for (let i = 0; i < baseConfig.length; i++) {
            const values = baseConfig[i].values;
            config.push(baseConfig[i]);
            for (let v = 0; v < values.length; v++) {
              const value = JSON.stringify(baseConfig[i].values[v].value);
              console.log("value", value);
              config[i].values[v].value = value;
              // const value = JSON.stringify(
              //   values[v].value
              //   //   config[i].values[v].value
              // );
              // config[i].values[v].value = JSON.stringify(value);
              //   values[v].value
              // );
            }
          }
          console.log("config", config);
          this.config.data = config;
        }
      }
    },
    config: {
      deep: true,
      handler(val) {
        console.log("watch config", val);
      }
    }
  },
  data() {
    return {
      loading: true,
      featureId: 0,
      error: "",
      tab: "info",
      versionIntro: "",
      form: {
        type: "",
        version: ""
      },
      add: {
        key: "",
        value: ""
      },
      config: {
        feature_version_id: 0,
        data: []
      },
      currentFile: {
        file: "",
        code: ""
      },
      feature: {},
      installStatus: {
        status: "",
        message: ""
      },
      splitterModel: 50,
      selected: "default",
      simple: [
        {
          label: "default",
          children: [
            {
              label: "Food",
              icon: "restaurant_menu"
            },
            {
              label: "Room service",
              icon: "room_service"
            },
            {
              label: "Room view",
              icon: "photo"
            }
          ]
        }
      ]
    };
  },
  methods: {
    stringObject(obj) {
      return JSON.stringify(obj);
    },
    delParam(index, valueIndex) {
      if (!confirm("确定删除此配置？")) return;
      if (
        this.config.data[index] &&
        this.config.data[index].values[valueIndex]
      ) {
        this.config.data[index].values.splice(valueIndex, 1);
      }
    },
    addParam(index) {
      for (const i in this.add) {
        if (this.add[i].trim() === "") {
          alert("请填写 " + i);
          return;
        }
      }
      this.config.data[index].values.push(this.add);
      this.add = { key: "", value: "" };
    },
    install() {
      if (!this.form.type) {
        alert("请选择类型");
        return;
      }
      if (!this.form.version) {
        alert("请选择版本");
        return;
      }
      const form = Object.assign({}, this.form);
      const self = this;
      form.featureId = parseInt(self.featureId);
      form.projectId = parseInt(self.$store.state.currentProject.project_id);
      form.featureName = this.feature.feature_name;
      form.featureOnBoot = this.feature.feature_onboot;
      form.version.feature_version_config.data = this.config.data;
      // form.version.feature_version_config = JSON.stringify(
      //   form.version.feature_version_config
      // );
      console.log(form);
      new Promise(function(resolve) {
        self.$http
          .post("/v1/install", form, { emulateJSON: false })
          .then(function(resp) {
            console.log(resp);
            // if (resp.body) {
            //   self.feature = resp.body;
            //   self.feature.feature_types = self.feature.feature_types.split(
            //     ","
            //   );
            //   self.feature.feature_labels = self.feature.feature_labels.split(
            //     ","
            //   );
            //   for (let i = 0; i < self.feature.feature_version.length; i++) {
            //     self.feature.feature_version[
            //       i
            //     ].feature_version_config = JSON.parse(
            //       self.feature.feature_version[i].feature_version_config
            //     );
            //     self.feature.feature_version[i].label =
            //       self.feature.feature_version[i].feature_version_name;
            //     self.feature.feature_version[i].value =
            //       self.feature.feature_version[i].feature_version_id;
            //   }
            // }
            // self.loading = false;
            // self.error = "";
          })
          .catch(function(resp) {
            console.log("catch", resp);
            // setTimeout(function() {
            //   if (!resp.body) {
            //     self.error = "接口请求失败";
            //   } else {
            //     self.error = resp.body.error;
            //   }
            // }, 1000);
          });
      });
    },
    getFeature() {
      this.loading = true;
      this.error = "";
      const self = this;
      return new Promise(function(resolve) {
        self.$http
          .get("/v1/feature", {
            params: { featureId: self.featureId }
          })
          .then(function(resp) {
            if (resp.body) {
              self.feature = resp.body;
              self.feature.feature_types = self.feature.feature_types.split(
                ","
              );
              self.feature.feature_labels = self.feature.feature_labels.split(
                ","
              );
              for (let i = 0; i < self.feature.feature_version.length; i++) {
                self.feature.feature_version[
                  i
                ].feature_version_config = JSON.parse(
                  self.feature.feature_version[i].feature_version_config
                );
                self.feature.feature_version[i].label =
                  self.feature.feature_version[i].feature_version_name;
                self.feature.feature_version[i].value =
                  self.feature.feature_version[i].feature_version_id;
                if (
                  self.feature.project_features_id ===
                  self.feature.feature_version[i].feature_version_id
                ) {
                  self.form.version = self.feature.feature_version[i];
                }
              }
              self.form.type = self.feature.project_features_type;
            }
            self.loading = false;
            self.error = "";
          })
          .catch(function(resp) {
            console.log("catch", resp);
            setTimeout(function() {
              if (!resp.body) {
                self.error = "接口请求失败";
              } else {
                self.error = resp.body.error;
              }
            }, 1000);
          });
      });
    }
  }
};
</script>
<style lang="sass" scoped>
.my-card
  width: 100%

.select
  width: 360px
</style>
