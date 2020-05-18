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
        <q-card-actions align="center">
          <q-btn color="green" icon="link" size="18px" @click="install()">
            安装</q-btn
          ></q-card-actions
        >
      </q-card>
    </template>
  </div>
</template>

<script>
export default {
  name: "Project",
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
        console.log("watch", val);
        if (val.version && val.version.feature_version_intro) {
          this.versionIntro = val.version.feature_version_intro.replace(
            "\n",
            "<br />"
          );
        }
      }
    }
  },
  data() {
    return {
      loading: true,
      featureId: 0,
      error: "",
      versionIntro: "",
      form: {
        type: "",
        version: ""
      },
      feature: {}
    };
  },
  methods: {
    install() {
      if (!this.form.type) {
        alert("请选择类型");
        return;
      }
      if (!this.form.version) {
        alert("请选择版本");
        return;
      }
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
            console.log(resp);

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
              }
            }
            self.loading = false;
            self.error = "";
          })
          .catch(function(resp) {
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
