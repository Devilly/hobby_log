import { readFile, writeFile } from 'fs/promises';

const encodedImage = await readFile('base64.txt', 'utf8');
const buffer = Buffer.from(encodedImage, 'base64')

await writeFile('file_from_base64.jpg', buffer);