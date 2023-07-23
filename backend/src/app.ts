import express, { Application, Request, Response } from 'express'

import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient();

const app: Application = express()

const port: number = Number(process.env.PORT || 3001);

app.get('/toto', (req: Request, res: Response) => {
    res.send('Hello toto');
});

app.get('/hello', (req: Request, res: Response) => {
    res.send('Hello toto');
});


app.listen(port, "0.0.0.0", function () {
    console.log(`App is listening on port ${port} !`)
});

/**
 * Do stuff and exit the process
 * @param {NodeJS.SignalsListener} _signal
 */
function signalHandler(_signal: any) {
    // do some stuff here
    process.exit();
}

process.on('SIGINT', signalHandler);
process.on('SIGTERM', signalHandler);
process.on('SIGQUIT', signalHandler);