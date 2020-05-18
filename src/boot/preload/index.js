import BluebirdPromise from "bluebird";
import VueResource from "vue-resource";
import Back from "../../components/Back.vue";

BluebirdPromise.config({
  // Enable warnings
  warnings: false,
  // Enable long stack traces
  longStackTraces: false,
  // Enable cancellation
  cancellation: false,
  // Enable monitoring
  monitoring: false,
  // Enable async hooks
  asyncHooks: true
});
window.BP = BluebirdPromise;

export default ({ Vue }) => {
  Vue.use(VueResource);
  Vue.component("Back", Back);
  Vue.http.options.emulateHTTP = true;
  Vue.http.options.timeout = 10000;
};
