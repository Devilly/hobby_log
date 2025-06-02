import fs from 'fs';
import path from 'path';

export class ImageFrameExport {
    #sessionFileStream;

    start({ exportDir: absExportDir }) {
        this.exportDir = absExportDir;
        if (!fs.existsSync(absExportDir)) {
            fs.mkdirSync(absExportDir, { recursive: true });
        }

        const sessionName = `session_${format(new Date(), 'yyyy-MM-dd_HH-mm-ss')}.img.jsonl`;
        const sessionFilePath = path.join(absExportDir, sessionName);
        this.#sessionFileStream = fs.createWriteStream(sessionFilePath);
    }

    write(imageBuffer) {
        if (this.#sessionFileStream) {
            const entry = imageBuffer.toString('base64');
            this.#sessionFileStream.write(entry + os.EOL);
        }
    }

    stop() {
        if (this.sessionFileStream) {
            this.sessionFileStream.end();
            this.sessionFileStream = null;
        }
    }
}
