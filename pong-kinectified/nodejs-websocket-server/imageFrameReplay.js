import fs from 'fs';
import readline from 'readline';

export class ImageFrameReplay {
    #readline = null;
    #wssColor = null;
    #intervalMs = null;

    async start(options) {
        const { file, intervalMs, loop, wssColor } = options;

        this.#intervalMs = intervalMs;
        this.#wssColor = wssColor;

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
