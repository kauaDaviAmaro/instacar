import express from 'express';
import fs from 'fs';
import path from 'path';

const router = express.Router();

const routesPath = __dirname;

fs.readdirSync(routesPath).forEach((file) => {
  if (file === 'index.routes.ts' || file === 'index.routes.js') return;

  const isRouteFile = file.endsWith('.routes.ts') || file.endsWith('.routes.js');
  if (!isRouteFile) return;

  const routeModule = require(path.join(routesPath, file));
  const routeExport = routeModule.default ?? routeModule;
  if (!routeExport) return;

  const routeName = file.replace(/\.routes\.(ts|js)$/i, '');
  const routePathMount = `/${routeName}`;
  router.use(routePathMount, routeExport);
});

export default router;