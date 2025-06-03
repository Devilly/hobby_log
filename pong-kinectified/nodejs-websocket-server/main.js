let Kinect2 = null;
let kinect = null;

if (process.platform === 'win32') {
    Kinect2 = (await import('kinect2')).default;
    kinect = new Kinect2();
}

import config from 'config';

import { createServer } from 'http';
import sharp from 'sharp';
import { WebSocketServer, WebSocket } from 'ws';

import { BodyFrameExport } from './bodyFrameExport.js';
import { BodyFrameReplay } from './bodyFrameReplay.js';
import { ImageFrameExport } from './imageFrameExport.js';
import { ImageFrameReplay } from './imageFrameReplay.js';

const server = createServer();

function createWebSocketServer() {
    const wssServer = new WebSocketServer({ noServer: true });

    wssServer.on('connection', function connection(ws) {
        console.log('Connected!');
        ws.on('error', console.error);
    });

    wssServer.on('error', function (error) {
        console.log(error);
    });

    return wssServer;
}

const wssColor = createWebSocketServer(server);
const wssBody = createWebSocketServer(server);

server.on('upgrade', function (request, socket, head) {
    const { pathname: path } = new URL(request.url, 'wss://stubby.url');

    if (path === '/color') {
        wssColor.handleUpgrade(request, socket, head, function done(ws) {
            wssColor.emit('connection', ws, request);
        });
    } else if (path === '/body') {
        wssBody.handleUpgrade(request, socket, head, function done(ws) {
            wssBody.emit('connection', ws, request);
        });
    } else {
        console.log(`Destroy socket for request path: ${path}`)
        socket.destroy();
    }
});

const serverPort = config.get('serverSettings.port');
server.listen(serverPort, () => {
    console.log(`Server is listening on port ${serverPort}`);
});

let bodyFrameExport = null;
let bodyFrameReplay = null;
let imageFrameExport = null;
let imageFrameReplay = null;
const bodyReplayConfig = config.get('serverSettings.replay.body');
const imageReplayConfig = config.get('serverSettings.replay.color');

if (bodyReplayConfig.enabled) {
    bodyFrameReplay = new BodyFrameReplay();
    bodyFrameReplay.start({
        file: bodyReplayConfig.file,
        intervalMs: bodyReplayConfig.intervalMs,
        loop: bodyReplayConfig.loop,
        wssBody
    });
}

if (imageReplayConfig.enabled) {
    imageFrameReplay = new ImageFrameReplay();
    imageFrameReplay.start({
        file: imageReplayConfig.file,
        intervalMs: imageReplayConfig.intervalMs,
        loop: imageReplayConfig.loop,
        wssColor
    });
}

if (config.get('kinectSettings.enabled') && kinect?.open()) {
    const inputWidth = config.get('kinectSettings.colorFrameSettings.inputSettings.width');
    const inputHeight = config.get('kinectSettings.colorFrameSettings.inputSettings.height');
    const inputChannels = config.get('kinectSettings.colorFrameSettings.inputSettings.channels');

    const outputQuality = config.get('kinectSettings.colorFrameSettings.outputSettings.jpegQuality');

    const bodyExportEnabled = config.get('kinectSettings.bodyFrameSettings.exportSettings.enabled');
    const bodyExportDirectory = config.get('kinectSettings.bodyFrameSettings.exportSettings.directory');
    const imageExportEnabled = config.get('kinectSettings.colorFrameSettings.exportSettings.enabled');
    const imageExportDirectory = config.get('kinectSettings.colorFrameSettings.exportSettings.directory');

    if (bodyExportEnabled) {
        bodyFrameExport = new BodyFrameExport();
        bodyFrameExport.start({
            exportDir: bodyExportDirectory
        });
    }

    if (imageExportEnabled) {
        imageFrameExport = new ImageFrameExport();
        imageFrameExport.start({
            exportDir: imageExportDirectory
        });
    }

    kinect.on('multiSourceFrame', async frame => {
        // HANDLE COLOR DATA
        const inputBuffer = Uint8Array.from(frame.color.buffer);
        const sharpImage = sharp(inputBuffer, {
            raw: {
                width: inputWidth,
                height: inputHeight,
                channels: inputChannels
            }
        });

        // As it seems we can not cross the 65535 byte threshold (data is just not getting to my code in Godot),
        // we are lowering the quality of the image so that the number of bytes used is reduced to below the threshold.

        // Reference: https://github.com/godotengine/godot/issues/22496
        const outputBuffer = await sharpImage.jpeg({
            quality: outputQuality
        }).toBuffer();

        console.log(`JPEG buffer size: ${outputBuffer.byteLength} bytes`);

        if (imageFrameExport) {
            imageFrameExport.write(outputBuffer);
        }

        if (!imageReplayConfig.enabled) {
            wssColor.clients.forEach(async function each(client) {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(outputBuffer);
                }
            });
        }

        // HANDLE BODY DATA
        const bodiesJson = JSON.stringify({
            bodies: frame.body.bodies
        });

        if (bodyFrameExport) {
            bodyFrameExport.write(bodiesJson);
        }

        if (!bodyReplayConfig.enabled) {
            wssBody.clients.forEach(async function each(client) {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(bodiesJson);
                }
            });
        }
    });

    kinect.openMultiSourceReader({
        frameTypes: Kinect2.FrameType.body | Kinect2.FrameType.color
    });
}

function shutdown() {
    console.log('Shutting down...');
    if (bodyFrameReplay) {
        bodyFrameReplay.stop();
        console.log('BodyFrameReplay stopped');
    }
    if (bodyFrameExport) {
        bodyFrameExport.stop();
        console.log('BodyFrameExport stopped');
    }
    if (imageFrameReplay) {
        imageFrameReplay.stop();
        console.log('ImageFrameReplay stopped');
    }
    if (imageFrameExport) {
        imageFrameExport.stop();
        console.log('ImageFrameExport stopped');
    }
    if (kinect) {
        kinect.close();
        console.log('Kinect closed');
    }
    console.log('Shut down...');
    process.exit(0);
}

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
