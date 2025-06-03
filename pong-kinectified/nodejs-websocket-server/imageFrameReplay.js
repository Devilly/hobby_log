import fs from 'fs';
import readline from 'readline';
import { sleep } from './util/sleep.js';
import { WebSocket } from 'ws';
import config from 'config';
import { findFirstJsonlFile } from './util/findFirstJsonlFile.js';

export class ImageFrameReplay {
    #readline = null;
    #wssColor = null;
    #intervalMs = null;

    async start(options) {
        let { file, intervalMs, loop, wssColor } = options;

        this.#intervalMs = intervalMs;
        this.#wssColor = wssColor;

        if (!file) {
            const exportDir = config.get('kinectSettings.colorFrameSettings.exportSettings.directory');
            file = findFirstJsonlFile(exportDir);
        }

        this.#readline = readline.createInterface({
            input: fs.createReadStream(file),
            crlfDelay: Infinity
        });

        for await (const line of this.#readline) {
            this.#wssColor.clients.forEach(client => {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(Buffer.from(line, 'base64'));
                }
            });
            await sleep(this.#intervalMs);
        }

        if (loop) {
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
