import BluebirdPromise from "bluebird";
import VueResource from "vue-resource";
import Back from "../../components/Back.vue";
import VueUploadComponent from "vue-upload-component";
import VueNativeSock from "vue-native-websocket";
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

export default ({ Vue, store }) => {
  Vue.component("FileUpload", VueUploadComponent);
  Vue.use(VueResource);
  Vue.component("Back", Back);
  // Vue.http.options.emulateHTTP = true;
  Vue.http.options.timeout = 10000;

  Vue.use(VueNativeSock, "ws://gm.signp.cn:32625", {
    reconnection: true,
    store: store
  });
};
