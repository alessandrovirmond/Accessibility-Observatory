import express, { Router } from 'express';
import { DomainController } from '../controllers/domainController';
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

router.post('/domain', (req, res) => domainController.saveDomain(req, res));

export default router;
