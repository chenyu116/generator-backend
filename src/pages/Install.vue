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
        <!-- <q-img :src="item.project_content" height="260px">
          <div class="absolute-bottom">
            <div class="text-subtitle2">{{ item.project_name }}</div>
          </div>
        </q-img> -->
        <q-card-section class="text-h4">
          模板：{{ feature.feature_name }}
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
        <q-card-section
          class="select"
          v-if="!feature.feature_onboot && feature.feature_reuse"
        >
          安装名称:
          <q-input filled="" v-model="form.projectFeaturesName" dense="" />
        </q-card-section>
        <q-card-section class="select" v-if="form.type === 'page'">
          跳转路径:
          <q-input filled="" v-model="form.routePath" dense="" />
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
          <template
            v-if="config.dependencies && config.dependencies.length > 0"
          >
            <q-item-label class="bg-blue q-pa-xs text-white q-mt-md"
              >依赖检查
              (请先安装需要依赖的功能，以保证此功能能正常使用)</q-item-label
            >
            <q-chip
              class="row col-12 q-mt-md"
              v-for="(cf, i) in config.dependencies"
              :key="`dependencies-div-${i}`"
            >
              {{ cf }}
              <q-icon
                name="done"
                color="green"
                size="18px"
                v-if="installedLabels.indexOf(cf) >= 0"
              />
              <q-icon
                name="clear"
                color="red"
                size="18px"
                v-if="installedLabels.indexOf(cf) === -1"
              />
            </q-chip>
          </template>

          <template v-for="(cf, indexConfig) in config.data">
            <q-item-label
              class="bg-blue q-pa-xs text-white"
              :key="`data-name-${indexConfig}`"
              >{{ cf.name }}</q-item-label
            >
            <div
              class="row col-12 q-mt-md"
              :key="`data-add-${indexConfig}`"
              v-if="!cf.limit || cf.limit > 1"
            >
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
              :key="`data-div-${indexConfig}-${indexValue}`"
              v-for="(cfValue, indexValue) in cf.values"
            >
              <q-input
                disable=""
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
                v-if="!cfValue.type"
              />
              <file-upload
                style="width:15%"
                :ref="`${cfValue.key}`"
                v-model="uploadFiles[cfValue.key]"
                post-action="/v1/upload"
                v-if="cfValue.type === 'upload'"
                accept="image/*"
              >
                <q-btn flat="" icon="list">选择文件</q-btn>
              </file-upload>

              <!-- <q-input
                v-show="false"
                v-model="cfValue.value"
                :ref="`value-${cfValue.key + indexValue}`"
              /> -->
              <div
                class="text-caption"
                v-if="cfValue.type === 'upload' && uploadFiles[cfValue.key]"
              >
                {{ uploadFiles[cfValue.key][0].name }}
              </div>
              <q-btn
                v-if="cfValue.type === 'upload'"
                flat=""
                :disable="
                  !$refs[cfValue.key] ||
                    !$refs[cfValue.key][0] ||
                    $refs[cfValue.key][0].active
                "
                @click.prevent="$refs[cfValue.key][0].active = true"
                icon="cloud_upload"
                >上传文件</q-btn
              >
              <!-- <q-file
                style="width:65%"
                filled
                dense=""
                v-model="cfValue.value"
                label="上传图片"
                v-if="cfValue.type === 'upload'"
                accept="image/*"
              /> -->
              <q-btn
                v-if="!cf.limit || cf.limit > 1"
                class="q-ml-md"
                flat=""
                icon="delete"
                @click="delParam(indexConfig, indexValue)"
                >删除</q-btn
              >
            </div>
          </template>
          <template v-for="(cf, i) in config.features">
            <q-item-label
              class="bg-blue q-pa-xs text-white q-mt-md"
              :key="`features-name-${i}`"
              >{{ cf.name }}</q-item-label
            >
            <div class="row col-12 q-mt-md" :key="`features-div-${i}`">
              <q-select
                dense=""
                clearable=""
                v-if="cf.limit === 1"
                filled
                v-model="cf.values[0]"
                :options="cf.options"
                style="width: 400px"
              >
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-italic text-grey">
                      没有可用功能，请先安装
                    </q-item-section>
                  </q-item>
                </template>
              </q-select>

              <q-select
                dense=""
                clearable=""
                v-if="!cf.limit || cf.limit > 1"
                multiple=""
                filled
                v-model="cf.values"
                :options="cf.options"
                style="width: 400px"
              >
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-italic text-grey">
                      没有可用功能，请先安装
                    </q-item-section>
                  </q-item>
                </template>
              </q-select>

              <!-- <q-select
                filled
                v-model="multiple"
                multiple
                :options="options"
                label="Multiple"
                style="width: 250px"
              /> -->
              <!-- <q-input
                style="width:65%"
                filled=""
                dense=""
                v-model="cf.value"
              />
              <q-btn
                flat=""
                icon="delete"
                @click="delParam(indexConfig, indexValue)"
                >删除</q-btn
              > -->
            </div>
          </template>
        </q-card-section>
        <q-card-actions align="center">
          <q-btn color="green" icon="link" size="18px" @click="install()">
            安装</q-btn
          >
        </q-card-actions>
        <q-card-section :class="`text-red`">{{
          installStatus.message
        }}</q-card-section>
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
    for (let i = 0; i < this.$store.state.canUse.length; i++) {
      for (
        let f = 0;
        f < this.$store.state.canUse[i]["feature_labels"].length;
        f++
      ) {
        this.installedLabels.push(
          this.$store.state.canUse[i]["feature_labels"][f]
        );
      }
      // this.installedLabels = Object.assign(
      //   [],
      //   this.$store.state.canUse[i]["feature_labels"],
      //   this.installedLabels
      // );
    }
    this.canUse = this.$store.state.canUse;
    console.log("this.canUse", this.$store.state.canUse);
    console.log("this.installedLabels", this.installedLabels);
    this.getFeature();
  },
  watch: {
    uploadFiles: {
      deep: true,
      handler(val) {
        console.log("watch upload", val);
        console.dir(this);
        for (const f in val) {
          if (val[f][0].success && this.$refs["value-" + f]) {
            this.$refs["value-" + f][0].value = val[f][0].response.file;
          }
        }
      }
    },
    form: {
      deep: true,
      handler(val) {
        if (
          val.version &&
          val.version.feature_version_id !== this.config.feature_version_id
        ) {
        }
        if (
          val.version &&
          val.version.feature_version_intro &&
          val.version.feature_version_id !== this.config.feature_version_id
        ) {
          this.versionIntro = val.version.feature_version_intro.replace(
            /\n/g,
            "<br />"
          );
        }

        if (
          val.version &&
          val.version.feature_version_config &&
          val.version.feature_version_id !== this.config.feature_version_id
        ) {
          this.config = {
            feature_version_id: val.version.feature_version_id,
            data: [],
            features: [],
            dependencies: [],
            components: []
          };
          if (val.version.feature_version_config.data) {
            const baseConfigData = val.version.feature_version_config.data;
            const config = [];

            for (let i = 0; i < baseConfigData.length; i++) {
              const values = baseConfigData[i].values;
              config.push(baseConfigData[i]);
              for (let v = 0; v < values.length; v++) {
                let value = values[v].value;
                console.log("value", typeof value);
                if (typeof value === "object") {
                  value = JSON.stringify(values[v].value);
                }
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
          if (val.version.feature_version_config.features) {
            this.config.features = val.version.feature_version_config.features;
            for (let i = 0; i < this.config.features.length; i++) {
              console.log("this.config.features[i]", this.config.features[i]);
              this.config.features[i].options = [];
              for (let l = 0; l < this.canUse.length; l++) {
                if (
                  this.config.features[i].type.indexOf(
                    this.canUse[l].project_features_type
                  ) > -1
                ) {
                  const option = this.canUse[l];
                  option.label = option.project_features_name;
                  option.value = option.project_features_id;
                  this.config.features[i].options.push(option);
                }
              }
            }
          }
          if (val.version.feature_version_config.dependencies) {
            this.config.dependencies =
              val.version.feature_version_config.dependencies;
          }
        }
      }
    },
    config: {
      deep: true,
      handler(val) {
        console.log("watch config", val);
        console.dir(this);
      }
    }
  },
  data() {
    return {
      loading: true,
      featureId: 0,
      error: "",
      installedLabels: [],
      canUse: [],
      versionIntro: "",
      form: {
        projectFeaturesName: "",
        type: "",
        version: "",
        routePath: ""
      },
      add: {
        key: "",
        value: ""
      },
      uploadFiles: {},
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
        message: ""
      }
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
      form.featureOnBoot = this.feature.feature_onboot ? true : false;
      for (let i = 0; i < this.config.data.length; i++) {
        const d = this.config.data[i];
        for (let u = 0; u < d.values.length; u++) {
          if (
            d.values[u].type &&
            d.values[u].type === "upload" &&
            this.uploadFiles[d.values[u].key] &&
            this.uploadFiles[d.values[u].key].length > 0
          ) {
            console.log(
              "this.uploadFiles[d.values[u].key]",
              this.uploadFiles[d.values[u].key]
            );
            this.config.data[i].values[u].value = this.uploadFiles[
              d.values[u].key
            ][0].response.file;
          }
        }
      }
      for (let i = 0; i < this.config.features.length; i++) {
        const d = this.config.features[i];
        for (let u = 0; u < d.values.length; u++) {
          if (
            d.values[u].project_features_type &&
            d.values[u].project_features_type === "page"
          ) {
            d.values[u]["key"] = "projectFeaturesRoutePath";
            d.values[u]["type"] = d.values[u].project_features_type;
            d.values[u]["value"] = d.values[u].project_features_route_path;
          }
          console.log(
            "d.values[u].project_features_config",
            d.values[u].project_features_config
          );
          // d.values[u].project_features_config = JSON.parse(
          //   d.values[u].project_features_config
          // );
        }
      }
      form.version.feature_version_config = this.config;
      form.featureVersionConfigString = JSON.stringify(
        form.version.feature_version_config
      );
      console.log("form", form);
      // return;
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
                // if (
                //   self.feature.project_features_config &&
                //   self.feature.feature_version_id &&
                //   self.feature.feature_version_id ===
                //     self.feature.feature_version[i].feature_version_id
                // ) {
                //   self.form.version = self.feature.feature_version[i];
                //   self.form.version.feature_version_config = JSON.parse(
                //     self.feature.project_features_config
                //   );
                // }
              }
              self.form.type = self.feature.project_features_type;
              self.form.projectFeaturesName = self.feature.feature_name;
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
