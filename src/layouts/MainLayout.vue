<template>
  <q-layout class="bg-grey-1">
    <q-header elevated="" height-hint="61.59">
      <q-toolbar class="text-white bg-grey-8 q-py-sm q-px-md ">
        <q-btn
          round
          dense
          flat
          :ripple="false"
          icon="visibility"
          size="19px"
          color="white"
          class="q-mr-sm"
          no-caps
        />

        <q-select
          ref="search"
          dark
          dense
          standout
          use-input
          :value="currentProjectId"
          hide-selected
          class="GL__toolbar-select"
          color="black"
          :stack-label="true"
          label="搜索项目"
          :options="filteredOptions"
          @filter="filter"
          style="width: 300px"
        >
          <!-- <template v-slot:no-option>
            <q-item>
              <q-item-section>
                <div class="text-center">
                  <q-spinner-pie color="grey-5" size="24px" />
                </div>
              </q-item-section>
            </q-item>
          </template> -->

          <template v-slot:option="scope">
            <q-item
              v-bind="scope.itemProps"
              v-on="scope.itemEvents"
              class="GL__select-GL__menu-link"
              @click="projectSelect(scope.opt)"
            >
              <q-item-section side>
                <q-icon name="collections_bookmark" />
              </q-item-section>
              <q-item-section>
                <q-item-label v-html="scope.opt.label" />
              </q-item-section>
              <!-- <q-item-section side :class="{ 'default-type': !scope.opt.type }">
                <q-btn
                  outline
                  dense
                  no-caps
                  text-color="blue-grey-5"
                  size="12px"
                  class="bg-grey-1 q-px-sm"
                >
                  {{ scope.opt.type || "Jump to" }}
                  <q-icon name="subdirectory_arrow_left" size="14px" />
                </q-btn>
              </q-item-section> -->
            </q-item>
          </template>
        </q-select>

        <div class="q-pl-sm q-gutter-sm row items-center no-wrap">
          <q-btn unelevated="" to="/"
            ><q-icon name="home" size="xs"></q-icon>首页</q-btn
          >
        </div>
        <div
          class="q-pl-sm q-gutter-sm row items-center no-wrap"
          v-if="$store.state.currentProject.project_id > 0"
        >
          <q-btn v-if="$q.screen.gt.xs" dense flat>
            <div class="row items-center no-wrap text-cyan text-bold text-h5">
              {{ $store.state.currentProject.project_id }} |
              {{ $store.state.currentProject.project_name }}
              <!-- <q-icon
                name="arrow_drop_down"
                size="24px"
                style="margin-left: -2px"
              /> -->
            </div>
            <!-- <q-menu auto-close>
              <q-list style="min-width: 100px">
                <q-item
                  clickable
                  class=""
                  :to="`/project/${$store.state.currentProject.project_id}`"
                >
                  <q-item-section>总览</q-item-section>
                </q-item>
                <q-item
                  clickable
                  class=""
                  :to="
                    `/project/${$store.state.currentProject.project_id}/boot`
                  "
                >
                  <q-item-section>前置加载</q-item-section>
                </q-item>
              </q-list>
            </q-menu> -->
          </q-btn>
        </div>
      </q-toolbar>
    </q-header>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
export default {
  name: "Layout",
  data() {
    return {
      text: "",
      options: null,
      filteredOptions: []
    };
  },
  computed: {
    currentProjectId: {
      get() {
        return this.$store.state.currentProject.project_id;
      },
      set() {}
    }
  },
  watch: {
    currentProjectId(val) {
      console.log("watch currentProjectId", val);
    }
  },
  created() {
    console.log("mounted", this.currentProjectId);
    this.readProjects();
  },
  methods: {
    readProjects() {
      const self = this;
      return new Promise(function(resolve) {
        self.$http.get("/v1/projects").then(function(resp) {
          if (resp.body) {
            self.options = resp.body;
            const projects = {};
            for (let i = 0; i < resp.body.length; i++) {
              projects[resp.body[i].project_id] = resp.body[i];
            }
            self.$store.commit("updateProjects", projects);
          }
        });
      });
    },
    filter(val, update) {
      if (this.options === null) {
        // this.$refs.search.filter("");
        // update();
        // load data

        return;
      }

      if (val === "") {
        this.filteredOptions = [];
      }
      //   console.log("in val");
      //   update(() => {
      //     this.filteredOptions = this.options.map(op => {
      //       if (op.project_name) {
      //         return {
      //           label: op.project_id + ". " + op.project_name,
      //           value: op.project_id
      //         };
      //       }
      //     });
      //   });
      //   return;
      // }

      update(() => {
        if (!val) {
          return;
        }
        this.filteredOptions = [
          ...this.options
            .filter(op =>
              (op.project_id + op.project_name).includes(val.toLowerCase())
            )
            .map(op =>
              Object.assign({}, op, {
                label: op.project_id + ". " + op.project_name,
                value: op.project_id
              })
            )
        ];
      });
    },
    projectSelect(val) {
      this.$store.commit("updateCurrentProject", val);
      this.$router.push("/dash/" + val.project_id);
    }
  }
};
</script>

<style lang="sass">
.GL
  &__select-GL__menu-link
    .default-type
      visibility: hidden

    &:hover
      background: #0366d6
      color: white
      .q-item__section--side
        color: white
      .default-type
        visibility: visible

  &__toolbar-link
    a
      color: white
      text-decoration: none
      &:hover
        opacity: 0.7

  &__menu-link:hover
    background: #0366d6
    color: white

  &__menu-link-signed-in
  &__menu-link-status
    &:hover
      & > div
        background: white !important

  &__menu-link-status
    color: $blue-grey-6
    &:hover
      color: $light-blue-9
</style>
