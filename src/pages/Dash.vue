<template>
  <div class="q-pa-md row items-start q-gutter-md col-10">
    <div v-if="loading">
      <q-spinner-pie color="grey" size="xl" v-if="!error" />
      <div v-if="error">
        <q-btn
          v-if="!initialize.need"
          icon="refresh"
          class="q-ml-md"
          dense=""
          @click="init()"
        >
          重新读取</q-btn
        ><br />
        {{ error }}
        <template v-if="initialize.need">
          <q-btn
            icon="ballot"
            @click="projectInit()"
            :disable="initialize.processing"
            :loading="initialize.processing"
          >
            初始化项目</q-btn
          >
          <div v-html="initialize.msg"></div>
        </template>
      </div>
    </div>
    <template v-if="!loading && !error">
      <div class="col-12">
        <q-toolbar>
          <q-btn flat round dense icon="whatshot" />
          <q-toolbar-title>总览</q-toolbar-title>
        </q-toolbar>
      </div>
      <template v-if="features['entrance']">
        <q-toolbar class="bg-grey-3">
          <q-icon name="pages" size="md" />
          <q-toolbar-title class="text-subtitle1">
            入口页面
          </q-toolbar-title>
          <q-btn flat dense v-if="features['entrance'].length === 0">
            <q-icon name="link" size="xs" left="" /> 添加功能
          </q-btn>
        </q-toolbar>
        <q-card
          class="my-card"
          v-for="(item, index) in mergedFeatures['entrance']"
          :key="index"
          @click="goEdit(item)"
        >
          <q-card-section>
            <div class="text-h6">{{ item.feature_name }}</div>
          </q-card-section>

          <q-card-section>
            {{ item.feature_intro }}
          </q-card-section>
          <q-card-section>
            labels:
            <q-chip v-for="(label, i) in item.feature_labels" :key="i">{{
              label
            }}</q-chip>
          </q-card-section>
          <q-card-section>
            版本:
            <q-chip v-if="item.feature_version_name">
              {{ item.feature_version_name }}
            </q-chip>
            <div class="text-subtitle2" v-if="item.project_features_id">
              <q-icon color="green" name="check_circle_outline" /> 已安装
            </div>
            <q-chip
              v-for="(version, versionIndex) in item.feature_version"
              :key="versionIndex"
              >{{ version.feature_version_name }}</q-chip
            >
          </q-card-section>
          <q-separator />

          <q-card-actions align="right">
            <template v-if="item.project_features_id">
              <q-btn flat icon="edit"> 配置</q-btn>
              <q-btn flat icon="view_compact" @click="view(item.feature_id)">
                查看</q-btn
              >
            </template>
            <template v-if="!item.project_features_id"
              ><q-btn flat icon="link" @click="install(item.feature_id)">
                安装</q-btn
              ></template
            >
          </q-card-actions>
        </q-card>
      </template>
      <template>
        <q-toolbar class="bg-grey-3">
          <q-icon name="grain" size="md" />
          <q-toolbar-title class="text-subtitle1">
            功能
          </q-toolbar-title>
        </q-toolbar>
        <q-card
          class="my-card"
          v-for="(item, index) in mergedFeatures['feature']"
          :key="index"
          @click="goEdit(item)"
        >
          <q-card-section>
            <div class="text-h6">{{ item.feature_name }}</div>
          </q-card-section>

          <q-card-section>
            {{ item.feature_intro }}
          </q-card-section>
          <q-card-section>
            labels:
            <q-chip v-for="(label, i) in item.feature_labels" :key="i">{{
              label
            }}</q-chip>
          </q-card-section>
          <q-card-section>
            版本:
            <q-chip v-if="item.feature_version_name">
              {{ item.feature_version_name }}
            </q-chip>
            <q-chip
              v-for="(version, versionIndex) in item.feature_version"
              :key="versionIndex"
              >{{ version.feature_version_name }}</q-chip
            >
            <div class="text-subtitle2" v-if="item.project_features_id">
              <q-icon color="green" name="check_circle_outline" /> 已安装
            </div>
          </q-card-section>
          <q-separator />

          <q-card-actions align="right">
            <template v-if="item.project_features_id">
              <q-btn flat icon="edit"> 配置</q-btn>
              <q-btn flat icon="view_compact" @click="view(item.feature_id)">
                查看</q-btn
              >
            </template>
            <template v-if="!item.project_features_id"
              ><q-btn flat icon="link" @click="view(item.feature_id)">
                安装</q-btn
              ></template
            >
          </q-card-actions>
        </q-card>
      </template>
      <!-- <div class="fixed-bottom col-12">
        <q-footer class="transparent text-primary text-center">
          <q-btn color="grey-8" icon="save">保存当前选择</q-btn>
        </q-footer>
      </div> -->
    </template>
  </div>
</template>

<script>
export default {
  name: "Dash",
  created() {
    const projectId = parseInt(this.projectId);
    if (
      !projectId ||
      projectId != this.$store.state.currentProject.project_id
    ) {
      return this.$router.push("/");
    }
    this.init();
  },
  computed: {
    projectId: {
      get() {
        return this.$route.params.id;
      },
      set() {}
    }
  },
  watch: {
    projectId(val) {
      const projectId = parseInt(val);
      if (
        !projectId ||
        projectId != this.$store.state.currentProject.project_id
      ) {
        return this.$router.push("/");
      }
      this.loading = true;
      this.error = "";
      this.init();
    }
  },
  data() {
    return {
      loading: false,
      initialize: { processing: false, msg: "", need: false },
      error: "",
      mergedFeatures: {},
      features: {},
      projectFeatures: {}
    };
  },
  methods: {
    view(featureId) {
      this.$router.push("/package/" + featureId);
    },
    projectInit() {
      this.initialize.processing = true;
      this.initialize.msg = "";
      const self = this;
      new Promise(function(resolve) {
        self.$http
          .get("/v1/project/init", {
            params: { projectId: self.projectId },
            timeout: 300000
          })
          .then(function(resp) {
            self.initialize.msg = "初始化完成";
            setTimeout(function() {
              self.$router.push("/");
            }, 1000);
          })
          .catch(function(resp) {
            setTimeout(function() {
              if (resp.body && resp.body.error) {
                self.initialize.msg = resp.body.error;
              } else {
                self.initialize.msg = JSON.stringify(resp);
              }
              self.initialize.processing = false;
            }, 1000);
          });
      });
    },
    init() {
      this.loading = true;
      this.error = "";
      const self = this;
      self
        .getFeatures()
        .then(function() {
          return self.getProjectFeatures();
        })
        .then(function() {
          self.mergeFeatures();
          self.error = "";
          self.loading = false;
        })
        .catch(function(resp) {
          console.log("catch", resp);
          setTimeout(function() {
            if (resp.status === 406) {
              self.initialize.need = true;
            }
            if (!resp.body) {
              self.error = "接口请求失败";
            } else {
              self.error = resp.body.error;
            }
          }, 1000);
        });
    },
    mergeFeatures() {
      const mergedFeatures = this.projectFeatures;
      for (const i in this.features) {
        let tempType = i;
        if (i !== "entrance") tempType = "feature";
        if (!mergedFeatures[tempType]) {
          mergedFeatures[tempType] = {};
        }
        for (let t = 0; t < this.features[i].length; t++) {
          if (!mergedFeatures[tempType][this.features[i][t].feature_id]) {
            mergedFeatures[tempType][
              this.features[i][t].feature_id
            ] = this.features[i][t];
          }
        }
      }
      this.mergedFeatures = mergedFeatures;
      console.log("mergedFeatures", mergedFeatures);
    },
    getFeatures() {
      this.features = {};
      const self = this;
      return new Promise(function(resolve, reject) {
        self.$http
          .get("/v1/features")
          .then(function(resp) {
            if (resp.body) {
              for (let i = 0; i < resp.body.length; i++) {
                const r = resp.body[i];
                r.feature_labels = r.feature_labels.split(",");
                r.feature_types = r.feature_types.split(",");
                for (let t = 0; t < r.feature_types.length; t++) {
                  if (!self.features[r.feature_types[t]]) {
                    self.features[r.feature_types[t]] = [];
                  }
                  // for (let v = 0; v < r.feature_version.length; v++) {
                  //   r.feature_version[v].feature_version_config = JSON.parse(
                  //     r.feature_version[v].feature_version_config
                  //   );
                  //   r.feature_version[v].label =
                  //     r.feature_version[v].feature_version_name;
                  //   r.feature_version[v].value =
                  //     r.feature_version[v].feature_version_id;
                  // }
                  self.features[r.feature_types[t]].push(r);
                }
              }
            }
            resolve();
          })
          .catch(function(resp) {
            reject(resp);
          });
      });
    },
    getProjectFeatures() {
      this.projectFeatures = {};
      const self = this;
      return new Promise(function(resolve, reject) {
        self.$http
          .get("/v1/project/features", {
            params: { projectId: self.projectId }
          })
          .then(function(resp) {
            if (resp.body) {
              for (let i = 0; i < resp.body.length; i++) {
                const r = resp.body[i];
                r.feature_labels = r.feature_labels.split(",");
                r.feature_types = r.feature_types.split(",");
                const featureType =
                  r.project_features_type === "entrance"
                    ? "entrance"
                    : "feature";
                if (!self.projectFeatures[featureType]) {
                  self.projectFeatures[featureType] = {};
                }
                // r.project_features_config = JSON.parse(
                //   r.project_features_config
                // );
                self.projectFeatures[featureType][r.feature_id] = r;
              }
            }
            console.log("projectFeatures", self.projectFeatures);
            resolve();
          })
          .catch(function(resp) {
            reject(resp);
          });
      });
    },
    goEdit(item) {}
  }
};
</script>
<style lang="sass" scoped>
.my-card
  width: 220px
</style>
