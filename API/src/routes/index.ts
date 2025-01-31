import express, { Router } from 'express';
import cors from 'cors'; // Importa o middleware CORS
import { DomainController } from '../controllers/appController';
import { createPool } from 'mysql2/promise';

const router: Router = express.Router();

const dbPool = createPool({
  host: 'localhost',
  user: 'observatorio',
  password: 'observatorio',
  database: 'observatorio',
  //user: 'root',
  //password: '',
  port: 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});



router.use(
  cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);

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

  router.get('/domains/:state', async (req, res) => {
    const { state } = req.params;

    if (state === 'all') {
     
      domainController.getAllDomains(req, res);
    }else {
      domainController.getDomainByState(req, res);
    }
  });

  router.get('/graph/:state', async (req, res) => {
    const { state } = req.params;

    if (state === 'all') {
      domainController.getTop10Domains(req, res);
    }else {
      domainController.getTop10DomainsByState(req, res);
    }
  });

  router.get('/state', (req, res) =>
    domainController.getStates(req, res)
  );

  router.get('/date', (req, res) =>
    domainController.getDate(req, res)
  );

 

export default router;