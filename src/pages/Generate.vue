<template>
  <div class="q-pa-md row items-start q-gutter-md col-10">
    <Back />
    <div class="col-12">
      <q-toolbar>
        <q-btn flat round dense icon="whatshot" />
        <q-toolbar-title>编译 & 部署</q-toolbar-title>
        <q-space />
        <q-btn
          icon="ballot"
          @click="build()"
          :disable="building"
          :loading="building"
          color="indigo"
        >
          编译项目</q-btn
        >
        <q-btn
          icon="cloud_upload"
          @click="deploy()"
          :disable="building"
          :loading="building"
          color="blue"
          class="q-ml-xl"
        >
          部署项目</q-btn
        >
      </q-toolbar>
      <div class="q-pa-md" style="height:600px">
        <q-scroll-observer @scroll="scrollHandler" />
        <q-input
          ref="buildText"
          v-model="message"
          filled
          type="textarea"
          readonly=""
          :input-style="{ height: '600px' }"
        />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  mounted() {
    if (!this.$store.state.currentProject.project_id) {
      return this.$router.push("/");
    }
    this.projectId = this.$store.state.currentProject.project_id;
  },
  data() {
    const self = this;
    return {
      loading: false,
      building: false,
      initialize: { processing: false, msg: "", need: false },
      message: "",
      features: [],
      entrance: [],
      installed: [],
      canUse: [],
      projectId: null
    };
  },
  computed: {
    socketMsg() {
      return this.$store.state.socket.message;
    }
  },
  watch: {
    socketMsg(val) {
      if (val.data) {
        const buildText = this.$refs.buildText.$el.firstChild.firstChild
          .lastChild.lastChild;

        this.message += val.data + "\n";
        buildText.scrollTop = buildText.scrollHeight;
        // console.log(buildText.scrollTop, "height", buildText.scrollHeight);
      }
    }
  },
  methods: {
    scrollHandler(e) {
      console.log("e", e);
    },
    build() {
      const self = this;
      this.building = true;
      return new Promise(function(resolve, reject) {
        self.$http
          .put(
            "/v1/build",
            { projectId: parseInt(self.projectId) },
            { timeout: 300000 }
          )
          .then(function(resp) {
            self.$q.notify({
              message: "编译成功",
              type: "positive",
              position: "top",
              timeout: 3000
            });
          })
          .catch(function(resp) {
            let message = resp.statusText;
            if (resp.body && resp.body.error) {
              message = resp.body.error;
            }
            self.$q.notify({
              message: message,
              type: "negative",
              position: "top",
              multiLine: true,
              timeout: 0,
              actions: [
                {
                  label: "关闭",
                  color: "yellow",
                  handler: () => {
                    /* ... */
                  }
                }
              ]
            });
          })
          .finally(function() {
            self.building = false;
            const buildText = this.$refs.buildText.$el.firstChild.firstChild
              .lastChild.lastChild;
            buildText.scrollTop = buildText.scrollHeight;
          });
      });
    },
    getFeatures() {
      this.features = [];
      const self = this;
      return new Promise(function(resolve, reject) {
        self.$http
          .get("/v1/features")
          .then(function(resp) {
            if (resp.body) {
              for (let i = 0; i < resp.body.length; i++) {
                const r = resp.body[i];
                if (!r.feature_reuse) {
                  for (let v = 0; v < r.feature_version.length; v++) {
                    if (
                      self.installOnce.indexOf(
                        r.feature_id +
                          "-" +
                          r.feature_version[v].feature_version_name
                      ) > -1
                    ) {
                      r.feature_version.splice(v, 1);
                    }
                  }
                  if (r.feature_version.length === 0) {
                    continue;
                  }
                }

                r.feature_labels = r.feature_labels.split(",");
                r.feature_types = r.feature_types.split(",");
                self.features.push(r);
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
                if (r.feature_reuse === undefined) {
                  self.installOnce.push(
                    r.feature_id + "-" + r.feature_version_name
                  );
                }
                if (featureType === "entrance") {
                  self.entrance.push(r);
                } else {
                  if (r.feature_reuse || !r.project_features_deploy_to) {
                    self.canUse.push(r);
                  }
                  self.installed.push(r);
                }
              }
              self.$store.commit("updateCanUse", self.canUse);
            }

            resolve();
          })
          .catch(function(resp) {
            reject(resp);
          });
      });
    },
    goEdit(item) {
      this.$store.commit("updateEditFeature", item);
      this.$router.push("/edit");
    },
    deploy() {
      if (confirm("确定部署项目？")) {
      }
    }
  }
};
</script>
<style lang="sass" scoped>
.my-card
  width: 220px
</style>
