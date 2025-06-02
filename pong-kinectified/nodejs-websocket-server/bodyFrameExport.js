import fs from 'fs';
import path from 'path';
import os from 'os';
import { format } from 'date-fns';

export class BodyFrameExport {
    #sessionFileStream = null;

    start({ exportDir }) {
        const absExportDir = path.resolve(exportDir);
        if (!fs.existsSync(absExportDir)) {
            fs.mkdirSync(absExportDir, { recursive: true });
        }
        const sessionName = `session_${format(new Date(), 'yyyy-MM-dd_HH-mm-ss')}.jsonl`;
        const sessionFilePath = path.join(absExportDir, sessionName);
        this.#sessionFileStream = fs.createWriteStream(sessionFilePath);
    }

    write(json) {
        if (this.#sessionFileStream) {
            this.#sessionFileStream.write(json + os.EOL);
        }
    }

    stop() {
        if (this.#sessionFileStream) {
            this.#sessionFileStream.end();
            this.#sessionFileStream = null;
        }
    }
}
