import fs from 'fs';
import readline from 'readline';
import { sleep } from './util/sleep.js';
import { WebSocket } from 'ws';
import { findFirstJsonlFile } from './util/findFirstJsonlFile.js';
import config from 'config';

export class BodyFrameReplay {
    #readline = null;
    #wssBody = null;
    #intervalMs = null;

    async start(options) {
        let { file, intervalMs, loop, wssBody } = options;

        this.#intervalMs = intervalMs;
        this.#wssBody = wssBody;

        if (!file) {
            const exportDir = config.get('kinectSettings.bodyFrameSettings.exportSettings.directory');
            file = findFirstJsonlFile(exportDir);
        }
        
        this.#readline = readline.createInterface({
            input: fs.createReadStream(file),
            crlfDelay: Infinity
        });

        for await (const line of this.#readline) {
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
            
            process.exit(0);
        }
    }

    stop() {
        if (this.#readline) {
            this.#readline.close();
            this.#readline = null;
        }
    }
}
