<template>
  <div class="q-pa-md row items-start q-gutter-md">
    <template v-if="loading">
      <q-spinner-pie color="cyan" size="xl" v-if="!error" />
      <div v-if="error">
        {{ error }}
        <q-btn
          icon="refresh"
          class="q-ml-md"
          dense=""
          @click="getProjectFeatured()"
        >
          重新读取</q-btn
        >
      </div>
    </template>
    <template v-if="!loading && !error">
      <q-card
        class="my-card"
        v-for="(item, index) in projectFeatured"
        :key="index"
        @click="goEdit(item)"
      >
        <q-img :src="item.project_content" height="260px">
          <div class="absolute-bottom">
            <div class="text-subtitle2">{{ item.project_name }}</div>
          </div>
        </q-img>

        <q-card-actions>
          功能数量：{{ item.project_features.length }}
        </q-card-actions>
      </q-card>
    </template>
  </div>
</template>

<script>
export default {
  name: "Index",
  created() {
    this.getProjectFeatured();
  },
  data() {
    return {
      loading: true,
      error: "",
      projectFeatured: []
    };
  },
  methods: {
    getProjectFeatured() {
      this.loading = true;
      this.error = "";
      const self = this;
      return new Promise(function(resolve) {
        self.$http
          .get("/v1/project/featured")
          .then(function(resp) {
            if (resp.body) {
              // for (let i = 0; i < 15; i++) {
              //   self.projectFeatured.push(resp.body[0]);
              // }
              self.projectFeatured = resp.body;
            }
            this.loading = false;
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
    },
    goEdit(item) {
      console.log(item);
      this.$router.push("/project");
    }
  }
};
</script>
<style lang="sass" scoped>
.my-card
  width: 200px
</style>
