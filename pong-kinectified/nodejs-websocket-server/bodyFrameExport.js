import fs from 'fs';
import path from 'path';
import os from 'os';
import { format } from 'date-fns';

export class BodyFrameExport {
    #sessionFileStream = null;
    #sessionFilePath = null;

    start(exportDir = './body_exports') {
        const absExportDir = path.resolve(exportDir);
        if (!fs.existsSync(absExportDir)) {
            fs.mkdirSync(absExportDir, { recursive: true });
        }
        const sessionName = `session_${format(new Date(), 'yyyy-MM-dd_HH-mm-ss')}.jsonl`;
        this.#sessionFilePath = path.join(absExportDir, sessionName);
        this.#sessionFileStream = fs.createWriteStream(this.#sessionFilePath);
    }

    write(json) {
        if (this.#sessionFileStream) {
            this.#sessionFileStream.write(json + os.EOL);
        }
    }

    close() {
        if (this.#sessionFileStream) {
            this.#sessionFileStream.end();
            this.#sessionFileStream = null;
            this.#sessionFilePath = null;
        }
    }
}
