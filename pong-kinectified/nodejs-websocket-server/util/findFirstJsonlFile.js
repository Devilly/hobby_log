import fs from 'fs';
import path from 'path';

export function findFirstJsonlFile(directory) {
    const absDirectory = path.resolve(directory);
    if (!fs.existsSync(absDirectory)) {
        throw new Error('Export directory does not exist: ' + absDirectory);
    }
    const files = fs.readdirSync(absDirectory).filter(f => f.endsWith('.jsonl'));
    if (files.length > 0) {
        return path.join(absDirectory, files[0]);
    } else {
        throw new Error('No .jsonl files found in export directory');
    }
}
