import MainLayout from "layouts/MainLayout.vue";
import Index from "pages/Index.vue";
import Dash from "pages/Dash.vue";
import Install from "pages/Install.vue";
import Edit from "pages/Edit.vue";
import Generate from "pages/Generate.vue";
import Error404 from "pages/Error404.vue";
const routes = [
  {
    path: "/",
    component: MainLayout,
    children: [
      { path: "/", component: Index },
      { path: "/dash/:id", component: Dash },
      {
        path: "/install/:featureId",
        component: Install
      },
      {
        path: "/edit",
        component: Edit
      },
      {
        path: "/generate",
        component: Generate
      }
    ]
  }
];

// Always leave this as last one
if (process.env.MODE !== "ssr") {
  routes.push({
    path: "*",
    component: Error404
  });
}

export default routes;
