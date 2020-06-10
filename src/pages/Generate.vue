<template>
  <div class="q-pa-md row items-start q-gutter-md col-10">
    <Back />
    <div class="col-12">
      <q-toolbar>
        <q-btn flat round dense icon="whatshot" />
        <q-toolbar-title>生成 & 部署</q-toolbar-title>
        <q-space />
        <q-btn
          icon="ballot"
          @click="build()"
          :disable="building || deploying"
          :loading="building"
          color="indigo"
        >
          生成项目</q-btn
        >
        <q-btn
          icon="cloud_upload"
          @click="deploy()"
          :disable="building || deploying"
          :loading="deploying"
          color="blue"
          class="q-ml-xl"
        >
          部署项目</q-btn
        >
      </q-toolbar>
      <div style="height:600px">
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
import { copyToClipboard } from "quasar";
export default {
  beforeDestroy() {
    if (typeof this.dismiss === "function") {
      this.dismiss();
    }
  },
  mounted() {
    if (!this.$store.state.currentProject.project_id) {
      return this.$router.push("/");
    }
  },
  data() {
    const self = this;
    return {
      dismiss: null,
      deploying: false,
      building: false,
      message: "",
      projectId: self.$store.state.currentProject.project_id
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
        if (val.data === "clear") {
          this.message = "";
          return;
        }
        const buildText = this.$refs.buildText.$el.firstChild.firstChild
          .lastChild.lastChild;

        this.message += val.data + "\n";
        buildText.scrollTop = buildText.scrollHeight;
        // console.log(buildText.scrollTop, "height", buildText.scrollHeight);
      }
    }
  },
  methods: {
    build() {
      const self = this;
      this.building = true;
      this.message = "";
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
            self.dismiss = self.$q.notify({
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
    deploy() {
      if (confirm("确定部署项目？")) {
        this.deploying = true;
        const self = this;
        this.deploying = true;
        this.message = "";
        return new Promise(function(resolve, reject) {
          self.$http
            .put(
              "/v1/deploy",
              { projectId: parseInt(self.projectId) },
              { timeout: 3000000 }
            )
            .then(function(resp) {
              self.dismiss = self.$q.notify({
                message:
                  "资源部署成功，为避免安全问题，请复制输入框中内容，在后台手动更新项目移动端主题",
                type: "info",
                multiLine: true,
                textColor: "black",
                position: "top",
                timeout: 0,
                actions: [
                  {
                    label: "复制",
                    color: "red",
                    handler: () => {
                      console.log("copy", self.message);
                      copyToClipboard(self.message)
                        .then(() => {
                          self.$q.notify({
                            message: "已复制",
                            type: "info",
                            textColor: "black",
                            position: "top",
                            timeout: 3000
                          });
                          // success!
                        })
                        .catch(() => {
                          self.$q.notify({
                            message: "复制失败，请手动复制",
                            type: "negative",
                            textColor: "black",
                            position: "top",
                            timeout: 3000
                          });
                        });
                    }
                  },
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
            .catch(function(resp) {
              let message = resp.statusText;
              if (resp.body && resp.body.error) {
                message = resp.body.error;
              }
              self.dismiss = self.$q.notify({
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
              self.deploying = false;
            });
        });
      }
    }
  }
};
</script>
