import asyncio
from time import time
import pandas as pd
from contextlib import suppress
from bleak import BleakScanner, BleakClient
import matplotlib.pyplot as plt

PYBRICKS_COMMAND_EVENT_CHAR_UUID = "c5f50002-8280-46da-89f4-6d8051e4aeef"
HUB_NAME = "Pybricks Hub"

last_update = time()

concatenated = ""
table = pd.DataFrame(columns=["interval", "error", "kp", "ki", "kd", "input"])

async def main():
    main_task = asyncio.current_task()

    def handle_disconnect(_):
        print("Hub was disconnected.")

        if(len(table.index) > 0):
            table.plot(subplots=True)
            plt.show()
        else:
            print("No data to render...")

        if not main_task.done():
            main_task.cancel()

    ready_event = asyncio.Event()

    def handle_rx(_, data: bytearray):
        if data[0] == 0x01:  # "write stdout" event (0x01)
            payload = data[1:]

            if payload == b"rdy":
                ready_event.set()
            else:
                global last_update
                global concatenated
                global table

                last_update = time()

                decoded = payload.decode()
                concatenated += decoded
                
                split = concatenated.split("#", 1)

                if(len(split) == 2):
                    interval, error, kp, ki, kd, input = map(lambda entry : float(entry), split[0].split(";"))
                    table.loc[len(table.index)] = [interval, error, kp, ki, kd, input]

                    concatenated = split[1]

    device = await BleakScanner.find_device_by_name(HUB_NAME)

    if device is None:
        print(f"could not find hub with name: {HUB_NAME}")
        return

    async with BleakClient(device, handle_disconnect) as client:
        await client.start_notify(PYBRICKS_COMMAND_EVENT_CHAR_UUID, handle_rx)

        async def send(data):
            await ready_event.wait()
            ready_event.clear()
            
            await client.write_gatt_char(
                PYBRICKS_COMMAND_EVENT_CHAR_UUID,
                b"\x06" + data,  # prepend "write stdin" command (0x06)
                response=True
            )

        print("Start the program on the hub now with the button.")

        await send(b"5.000")
        await send(b"0.010")
        await send(b"500.0")

        while(time() - last_update < 2):
            await asyncio.sleep(1)

if __name__ == "__main__":
    with suppress(asyncio.CancelledError):
        asyncio.run(main())

