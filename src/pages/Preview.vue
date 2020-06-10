<template>
  <div class="q-pa-md row items-start">
    <Back />
    <div class="col-12">
      <q-toolbar>
        <q-btn flat round dense icon="whatshot" />
        <q-toolbar-title>预览</q-toolbar-title>
        <q-space />
        <q-btn
          v-if="!previewing"
          icon="play_circle_outline"
          @click="preview()"
          color="blue"
          class="q-ml-xl"
          :disable="building || deploying"
        >
          预览</q-btn
        >
        <q-btn
          v-if="previewing"
          icon="not_interested"
          @click="cancelPreview()"
          color="blue"
          class="q-ml-xl"
          :disable="building || deploying"
        >
          关闭预览</q-btn
        >
      </q-toolbar>
      <div class="row">
        预览配置
        <q-input v-model="settings" filled type="input" style="width:100%;" />
        <!-- <editor
          v-model="settings"
          @init="editorInit"
          lang="json"
          theme="chrome"
          width="100%"
          height="60"
        ></editor> -->
        <div style="width:100%;height:600px">
          操作过程
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
  </div>
</template>

<script>
export default {
  components: {
    // editor: require("vue2-ace-editor")
  },
  beforeDestroy() {
    this.cancelPreview();
  },
  mounted() {
    if (!this.$store.state.currentProject.project_id) {
      return this.$router.push("/");
    }
  },
  data() {
    const self = this;
    return {
      deploying: false,
      building: false,
      previewing: false,
      initialize: { processing: false, msg: "", need: false },
      message: "",
      settings: JSON.stringify({
        map_point_id: 0,
        map_id: 0,
        id: 10006,
        name: "",
        point: "",
        map_name: "",
        map_gid: "",
        project_name: self.$store.state.currentProject.project_name,
        project_id: self.$store.state.currentProject.project_id,
        center: "0,0",
        slogon: self.$store.state.currentProject.project_content
      }),
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
    editorInit: function(editor) {
      require("brace/mode/json");
      require("brace/theme/chrome");
    },
    cancelPreview(projectId) {
      const self = this;
      this.message = "";
      this.previewing = false;
      return new Promise(function(resolve, reject) {
        self.$http
          .delete("/v1/preview/" + self.projectId)
          .then(function(resp) {
            self.$q.notify({
              message: "已关闭预览",
              type: "positive",
              position: "top",
              timeout: 3000
            });
          })
          .catch(function(resp) {
            if (resp.status === 404) {
              return;
            }
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
          });
      });
    },
    preview() {
      const self = this;
      this.message = "";
      this.previewing = true;
      return new Promise(function(resolve, reject) {
        self.$http
          .put("/v1/preview", {
            projectId: parseInt(self.projectId),
            settings: self.settings
          })
          .then(function(resp) {
            self.$q.notify({
              textColor: "black",
              message: "正在启动预览服务，启动成功后，请复制下面的地址进行预览",
              type: "info",
              position: "top",
              timeout: 5000
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
            self.previewing = false;
          });
      });
    }
  }
};
</script>
