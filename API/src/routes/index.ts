import express, { Router } from 'express';
import { DomainController } from '../controllers/appController';
import { createPool } from 'mysql2/promise';

const router: Router = express.Router();

const dbPool = createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'observatorio',
  port: 3308,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});
const domainController = new DomainController(dbPool);

router.post('/domains', (req, res) => domainController.saveDomain(req, res));
router.get('/domains', (req, res) => domainController.getAllDomains(req, res));
router.get('/domains/:id/subdomains', (req, res) =>
  domainController.getSubdomainByDomainId(req, res)
);
router.get('/subdomains/:id/violations', (req, res) =>
  domainController.getViolationsBySubdomainId(req, res)
);
router.get('/violations/:id/elements', (req, res) =>
  domainController.getElementsByViolationId(req, res)
);

export default router;
