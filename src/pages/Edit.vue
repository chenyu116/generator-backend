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
        <q-card-section v-model="form.projectFeaturesName" class="text-h4">
          功能编辑：{{ form.projectFeaturesName }}
        </q-card-section>
        <q-card-section class="text-subtitle1">
          模板说明：{{ feature.feature_intro }}
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
                v-if="installedLabels.indexOf(cf) > -1"
              />
              <q-icon
                name="clear"
                color="red"
                size="18px"
                v-if="installedLabels.indexOf(cf) === -1"
              />
            </q-chip>
          </template>
          <q-item-label class="bg-blue q-pa-xs text-white">{{
            config.data.name || "相关参数"
          }}</q-item-label>
          <div v-if="form.version" class="row col-12 q-mt-md">
            <q-input
              filled=""
              dense=""
              style="width:20%"
              v-model="add.key"
            /><span class="text-h5">:</span>
            <q-input style="width:65%" filled="" dense="" v-model="add.value" />
            <q-btn flat="" icon="add" @click="addData()" class="q-ml-md"
              >添加</q-btn
            >
          </div>
          <template v-for="(cf, indexConfig) in config.data.values">
            <div class="row col-12 q-mt-md" :key="`data-div-${indexConfig}`">
              <q-input
                :label="cf.name"
                disable=""
                filled=""
                dense=""
                style="width:20%"
                v-model="cf.key"
              /><span class="text-h5">:</span>
              <q-input
                style="width:65%"
                filled=""
                dense=""
                disable=""
                value="fromComponents"
                v-if="cf.formType === 'fromComponents'"
              />
              <q-input
                style="width:65%"
                filled=""
                dense=""
                v-model="cf.value"
                v-if="cf.formType === 'input'"
              />
              <file-upload
                style="width:15%"
                :ref="`${cf.key}`"
                v-model="uploadFiles[cf.key]"
                post-action="/v1/upload"
                v-if="cf.formType === 'upload'"
                accept="image/*"
              >
                <q-btn flat="" icon="list">选择文件</q-btn>
              </file-upload>
              <div
                v-if="
                  cf.formType === 'upload' && !uploadFiles[cf.key] && cf.value
                "
                class="text-caption"
              >
                {{ cf.value }}
              </div>
              <div
                class="text-caption"
                v-if="cf.formType === 'upload' && uploadFiles[cf.key]"
              >
                {{ uploadFiles[cf.key][0].name }}
              </div>
              <q-btn
                v-if="cf.formType === 'upload'"
                flat=""
                @click.prevent="$refs[cf.key][0].active = true"
                icon="cloud_upload"
                >上传文件</q-btn
              >
              <q-btn
                flat=""
                icon="delete"
                class="q-ml-md"
                @click="delData(indexConfig)"
                >删除</q-btn
              >
            </div>
          </template>
          <template v-for="(cf, i) in config.components">
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
              />-->
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
  watch: {
    uploadFiles: {
      deep: true,
      handler(val) {
        console.log("watch uploadFiles", val);
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
          if (val.version.feature_version_intro) {
            this.versionIntro = val.version.feature_version_intro.replace(
              /\n/g,
              "<br />"
            );
          }
          const projectFeaturesConfig = JSON.parse(
            this.$store.state.editFeature.project_features_config
          );
          if (val.version.feature_version_config) {
            this.config = val.version.feature_version_config;
            if (Array.isArray(this.config.data.values)) {
              for (let i = 0; i < this.config.data.values.length; i++) {
                const v = this.config.data.values[i];
                for (
                  let p = 0;
                  p < projectFeaturesConfig.data.values.length;
                  p++
                ) {
                  const vp = projectFeaturesConfig.data.values[p];
                  if (v.key === vp.key) {
                    switch (v.formType) {
                      case "input":
                        v.value = vp.value;
                        break;
                      case "upload":
                        v.oldValue = vp.value;
                        v.value = vp.value;
                        break;
                    }
                    break;
                  }
                }
              }
            }
            // this.config = {
            //   feature_version_id: val.version.feature_version_id,
            //   data: [],
            //   dependencies: [],
            //   components: []
            // };
            // if (val.version.feature_version_config.data) {
            //   this.config.data = val.version.feature_version_config.data;
            // }
            console.log("this.config.components", this.config.components);
            console.log("projectFeaturesConfig", projectFeaturesConfig);
            if (this.config.components) {
              for (let i = 0; i < this.config.components.length; i++) {
                const d = this.config.components[i];
                d.options = [];
                for (let l = 0; l < this.canUse.length; l++) {
                  if (
                    d.accept.indexOf(this.canUse[l].project_features_type) > -1
                  ) {
                    const option = this.canUse[l];
                    option.label = option.project_features_name;
                    option.value = option.project_features_id;
                    d.options.push(option);
                  }
                }
                for (
                  let p = 0;
                  p < projectFeaturesConfig.components.length;
                  p++
                ) {
                  const vp = projectFeaturesConfig.components[p];
                  if (d.key === vp.key) {
                    for (let l = 0; l < d.options.length; l++) {
                      for (let sl = 0; sl < vp.values.length; sl++) {
                        if (
                          d.options[l].project_features_id ===
                          vp.values[sl].project_features_id
                        ) {
                          d.values.push(d.options[l]);
                        }
                      }
                    }
                    break;
                  }
                }
              }
            }
            // if (val.version.feature_version_config.dependencies) {
            //   this.config.dependencies =
            //     val.version.feature_version_config.dependencies;
            // }
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
        version: ""
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
  beforeDestroy() {
    this.$store.commit("updateEditFeature", null);
  },
  mounted() {
    if (
      !this.$store.state.currentProject.project_id ||
      !this.$store.state.editFeature
    ) {
      return this.$router.push("/");
    }
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
    }
    this.canUse = this.$store.state.canUse;
    console.log("this.canUse", this.$store.state.canUse);
    console.log("this.$store.state.editFeature", this.$store.state.editFeature);
    this.featureId = this.$store.state.editFeature.feature_id;
    // const config = JSON.parse(this.feature.project_features_config);
    // for (let i = 0; i < config.data.values.length; i++) {
    //   const v = config.data.values[i];
    //   if (v.formType === "upload") {
    //     this.uploadFiles[v.key] = [{ name: v.value }];
    //   }
    // }
    // this.config = config;
    // console.log("edit this.config", this.config);
    this.getFeature();
  },
  methods: {
    stringObject(obj) {
      return JSON.stringify(obj);
    },
    addData() {
      console.log("this.config.data", this.config.data);
      if (this.add.key && this.add.value) {
        this.add.key = this.add.key.trim();
        for (let i = 0; i < this.config.data.values.length; i++) {
          const d = this.config.data.values[i];
          if (d.key === this.add.key) {
            alert("变量名已存在");
            return;
          }
        }
        const add = Object.assign(
          { formType: "input", name: this.add.key },
          this.add
        );
        this.config.data.values.push(add);
        this.add = { key: "", value: "" };
      }
    },
    delData(valueIndex) {
      if (!confirm("确定删除此配置？")) return;
      if (this.config.data.values[valueIndex]) {
        this.config.data.values.splice(valueIndex, 1);
      }
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
      // form.featureName = this.feature.feature_name;
      // form.featureOnBoot = this.feature.feature_onboot ? true : false;
      // update upload file
      for (let i = 0; i < this.config.components.length; i++) {
        const d = this.config.components[i];
        for (let u = 0; u < d.values.length; u++) {
          if (typeof d.values[u].project_features_config === "string") {
            d.values[u].project_features_config = JSON.parse(
              d.values[u].project_features_config
            );
          }
        }
      }
      if (this.config.data.values) {
        for (let i = 0; i < this.config.data.values.length; i++) {
          const d = this.config.data.values[i];
          if (d.formType === "upload" && this.uploadFiles[d.key]) {
            d.value = this.uploadFiles[d.key][0].response.file;
            if (!d.value && d.oldValue) {
              d.value = d.oldValue;
            }
          }
          if (d.oldValue) {
            delete d.oldValue;
          }
          if (
            d.formType === "fromComponents" &&
            Array.isArray(this.config.components) &&
            this.config.components.length > 0
          ) {
            console.log("this.config.components", this.config.components);
            for (let u = 0; u < this.config.components.length; u++) {
              const c = this.config.components[u];

              if (c.key === d.key) {
                for (let cv = 0; cv < c.values.length; cv++) {
                  console.log(
                    "c.values[cv].project_features_config.data",
                    c.values[cv]
                  );
                  const cvf = c.values[cv].project_features_config.data.values;
                  console.log("cvf", cvf);
                  for (let cvv = 0; cvv < cvf.length; cvv++) {
                    if (cvf[cvv].key == d.key) {
                      let path = cvf[cvv].value;
                      for (
                        let nd = 0;
                        nd < this.config.data.values.length;
                        nd++
                      ) {
                        const ndv = this.config.data.values[nd];
                        path = path.replace(":" + ndv.key, ndv.value);
                      }
                      d.value = path;
                      break;
                    }
                  }
                }
                break;
              }
            }
          }
          // for (let u = 0; u < d.values.length; u++) {
          //   if (
          //     d.values[u].type &&
          //     d.values[u].type === "upload" &&
          //     this.uploadFiles[d.values[u].key] &&
          //     this.uploadFiles[d.values[u].key].length > 0
          //   ) {
          //     console.log(
          //       "this.uploadFiles[d.values[u].key]",
          //       this.uploadFiles[d.values[u].key]
          //     );
          //     this.config.data[i].values[u].value = this.uploadFiles[
          //       d.values[u].key
          //     ][0].response.file;
          //   }
          // }
        }
      }

      form.version.feature_version_config = this.config;
      console.log("form", form);
      return;
      new Promise(function(resolve) {
        self.$http
          .post("/v1/install", form)
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
      return new Promise(function(resolve, reject) {
        self.$http
          .get("/v1/feature", {
            params: { featureId: self.featureId }
          })
          .then(function(resp) {
            if (resp.body) {
              self.feature = resp.body;
              // if (!self.feature.feature_reuse) {
              //   self.$router.push(
              //     "/dash/" + self.$store.state.currentProject.project_id
              //   );
              //   return;
              // }
              self.feature.feature_types = self.feature.feature_types.split(
                ","
              );
              self.feature.feature_labels = self.feature.feature_labels.split(
                ","
              );
              let selectVersion = {};
              for (let i = 0; i < self.feature.feature_version.length; i++) {
                self.feature.feature_version[
                  i
                ].feature_version_config = JSON.parse(
                  self.feature.feature_version[i].feature_version_config
                );
                self.feature.feature_version[
                  i
                ].feature_version_config.feature_version_id =
                  self.feature.feature_version[i].feature_version_id;
                self.feature.feature_version[i].label =
                  self.feature.feature_version[i].feature_version_name;
                self.feature.feature_version[i].value =
                  self.feature.feature_version[i].feature_version_id;
                if (
                  self.$store.state.editFeature.feature_version_id ===
                  self.feature.feature_version[i].feature_version_id
                ) {
                  selectVersion = self.feature.feature_version[i];
                }
              }
              self.form.type =
                self.$store.state.editFeature.project_features_type;
              self.form.projectFeaturesName =
                self.$store.state.editFeature.project_features_name;

              self.form.version = selectVersion;
            }

            self.loading = false;
            self.error = "";
            console.log("self.feature", self.feature);
            resolve();
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
