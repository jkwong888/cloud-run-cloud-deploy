import express, { Application, Request, Response } from 'express'

import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient();

const app: Application = express()

const port: number = 3001

app.get('/toto', (req: Request, res: Response) => {
    res.send('Hello toto')
})

app.listen(port, function () {
    console.log(`App is listening on port ${port} !`)
})

/**
 * Do stuff and exit the process
 * @param {NodeJS.SignalsListener} _signal
 */
function signalHandler(_signal: any) {
    // do some stuff here
    process.exit()
}

process.on('SIGINT', signalHandler)
process.on('SIGTERM', signalHandler)
process.on('SIGQUIT', signalHandler)