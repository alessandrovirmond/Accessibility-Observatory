import app from './src/app';
import dotenv from 'dotenv';

dotenv.config();

const PORT = 3001;

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
