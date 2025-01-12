import express, { Application } from 'express';
import routes from './routes';
import bodyParser from 'body-parser';

const app: Application = express();

app.use(bodyParser.json({ limit: '50mb' }));
app.use(
  bodyParser.urlencoded({
    limit: '50mb',
    extended: true,
    parameterLimit: 50000,
  })
);
app.use('/api', routes);

export default app;
