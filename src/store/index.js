import Vue from "vue";
import Vuex from "vuex";

// import example from './module-example'

Vue.use(Vuex);

/*
 * If not building with SSR mode, you can
 * directly export the Store instantiation;
 *
 * The function below can be async too; either use
 * async/await or return a Promise which resolves
 * with the Store instance.
 */

// export default function (/* { ssrContext } */) {
//   const Store = new Vuex.Store({
//     modules: {
//       // example
//     },

//     // enable strict mode (adds overhead!)
//     // for dev mode only
//     strict: process.env.DEV
//   })

//   return Store
// }
export default new Vuex.Store({
  state: {
    projects: {},
    currentProject: {},
    canUse: []
  },
  mutations: {
    updateProjects(state, value) {
      state.projects = value;
    },
    updateCurrentProject(state, value) {
      state.currentProject = value;
      console.log("updateCurrentProject", state.currentProject);
    },
    updateCanUse(state, value) {
      state.canUse = value;
      console.log("canUse", state.canUse);
    }
  },
  actions: {},
  modules: {}
});
