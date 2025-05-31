import Kinect2 from 'kinect2';
const kinect = new Kinect2();

import { createServer } from 'http';

import sharp from 'sharp';
import { WebSocketServer, WebSocket } from 'ws';

import config from 'config';

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

if (kinect.open()) {
    const inputWidth = config.get('kinectSettings.colorFrameSettings.inputSettings.width');
    const inputHeight = config.get('kinectSettings.colorFrameSettings.inputSettings.height');
    const inputChannels = config.get('kinectSettings.colorFrameSettings.inputSettings.channels');

    const outputQuality = config.get('kinectSettings.colorFrameSettings.outputSettings.jpegQuality');

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

        wssColor.clients.forEach(async function each(client) {
            if (client.readyState === WebSocket.OPEN) {
                client.send(outputBuffer);
            }
        });

        // HANDLE BODY DATA
        wssBody.clients.forEach(async function each(client) {
            if (client.readyState === WebSocket.OPEN) {
                client.send(JSON.stringify({
                    bodies: frame.body.bodies
                }));
            }
        });
    });

    kinect.openMultiSourceReader({
        frameTypes: Kinect2.FrameType.body | Kinect2.FrameType.color
    });
}
