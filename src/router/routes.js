const routes = [
  {
    path: "/",
    component: () => import("layouts/MainLayout.vue"),
    children: [
      { path: "/", component: () => import("pages/Index.vue") },
      { path: "/dash/:id", component: () => import("pages/Dash.vue") },
      {
        path: "/package/:featureId",
        component: () => import("pages/Package.vue")
      }
    ]
  }
];

// Always leave this as last one
if (process.env.MODE !== "ssr") {
  routes.push({
    path: "*",
    component: () => import("pages/Error404.vue")
  });
}

export default routes;
