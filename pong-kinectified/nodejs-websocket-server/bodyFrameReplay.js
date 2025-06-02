import fs from 'fs';
import readline from 'readline';
import { sleep } from './sleep.js';
import { WebSocket } from 'ws';

export class BodyFrameReplay {
    readline = null;
    #wssBody = null;
    #intervalMs = null;

    async start(options) {
        const { file, intervalMs, loop, wssBody } = options;

        this.#intervalMs = intervalMs;
        this.#wssBody = wssBody;
        
        this.readline = readline.createInterface({
            input: fs.createReadStream(file),
            crlfDelay: Infinity
        });

        for await (const line of this.readline) {
            this.#wssBody.clients.forEach(client => {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(line);
                }
            });
            await sleep(this.#intervalMs);
        }

        if(loop) {
            this.start(options);
        } else {
            this.stop();
        }
    }

    stop() {
        if (this.readline) {
            this.readline.close();
            this.readline = null;
        }
    }
}
