<template>
  <q-layout class="bg-grey-1">
    <q-header elevated class="text-white" height-hint="61.59">
      <q-toolbar class="q-py-sm q-px-md">
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
          fill-input
          hide-selected
          class="GL__toolbar-select"
          color="black"
          :stack-label="false"
          label="搜索项目"
          :options="filteredOptions"
          @filter="filter"
          @input-value="setModel"
          :value="currentProjectId"
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
              @click="projectSelect(scope.opt.value)"
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
          <q-btn
            v-if="$q.screen.gt.xs"
            dense
            flat
            round
            size="sm"
            icon="notifications"
          />
          <q-btn v-if="$q.screen.gt.xs" dense flat>
            <div class="row items-center no-wrap">
              <q-icon name="add" size="20px" />
              <q-icon
                name="arrow_drop_down"
                size="16px"
                style="margin-left: -2px"
              />
            </div>
            <q-menu auto-close>
              <q-list dense style="min-width: 100px">
                <q-item clickable class="GL__menu-link">
                  <q-item-section>New repository</q-item-section>
                </q-item>
                <q-item clickable class="GL__menu-link">
                  <q-item-section>Import repository</q-item-section>
                </q-item>
                <q-item clickable class="GL__menu-link">
                  <q-item-section>New gist</q-item-section>
                </q-item>
                <q-item clickable class="GL__menu-link">
                  <q-item-section>New organization</q-item-section>
                </q-item>
                <q-separator />
                <q-item-label header>This repository</q-item-label>
                <q-item clickable class="GL__menu-link">
                  <q-item-section>New issue</q-item-section>
                </q-item>
              </q-list>
            </q-menu>
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
const stringOptions = [
  "quasarframework/quasar",
  "quasarframework/quasar-awesome"
];

export default {
  name: "MyLayout",

  data() {
    return {
      currentProjectId: 0,
      text: "",
      options: null,
      filteredOptions: []
    };
  },
  watch: {
    currentProjectId(val) {
      console.log("watch currentProjectId", val);
    }
  },
  mounted() {
    console.dir(BP);
    this.readProjects();
  },
  methods: {
    readProjects() {
      const self = this;
      return new Promise(function(resolve) {
        self.$http
          .get("/v1/projects", {
            params: {}
          })
          .then(function(resp) {
            console.log(resp);
            if (resp.body) {
              self.options = resp.body;
            }
          });
      });
    },
    filter(val, update) {
      if (this.options === null) {
        // this.options = stringOptions;
        this.$refs.search.filter("");
        update();
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
            .map(op => ({
              label: op.project_id + ". " + op.project_name,
              value: op.project_id
            }))
        ];
      });
    },
    setModel(val) {
      console.log("setModel", val);
      this.currentProjectId = val;
    },
    projectSelect(val) {
      console.log("projectSelect", val);
    }
  },

  created() {}
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

  &__toolbar-select.q-field--focused
    width: 450px !important
    .q-field__append
      display: none
</style>
