import BluebirdPromise from "bluebird";
import VueResource from "vue-resource";
import Back from "../../components/Back.vue";
import VueUploadComponent from "vue-upload-component";

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
  Vue.component("FileUpload", VueUploadComponent);
  Vue.use(VueResource);
  Vue.component("Back", Back);
  Vue.http.options.emulateHTTP = true;
  Vue.http.options.timeout = 10000;
};
