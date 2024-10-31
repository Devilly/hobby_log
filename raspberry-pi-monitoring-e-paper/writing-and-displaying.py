from datetime import datetime, timedelta, timezone
import sqlite3
import psutil
import sqlite3
import sys
import os
import matplotlib.pyplot as plt
import matplotlib.figure as fig
import matplotlib.dates as mdates
from PIL import Image

libdir = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'lib')
if os.path.exists(libdir):
    sys.path.append(libdir)

from waveshare_epd import epd2in13_V4

database = sys.argv[1]
image = sys.argv[2]

with sqlite3.connect(database) as connection:
    cursor = connection.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS percentages (
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP UNIQUE,
            cpu REAL,
            memory REAL
        );
    """)
    connection.commit()

    cursor.execute(f"INSERT INTO percentages (cpu, memory) VALUES ({psutil.cpu_percent()}, {psutil.virtual_memory().percent});")
    connection.commit()

    one_hour_ago = (datetime.now(timezone.utc) - timedelta(hours=1)).strftime('%Y-%m-%d %H:%M:%S')
    select_query = """
        SELECT * FROM percentages
        WHERE timestamp >= ?
    """

    cursor.execute(select_query, (one_hour_ago,))
    results = cursor.fetchall()

    timestamps = []
    cpu_usage = []
    memory_usage = []

    for row in results:
        timestamps.append(row[0])
        cpu_usage.append(row[1])
        memory_usage.append(row[2])

    timestamps = [datetime.strptime(timestamp, '%Y-%m-%d %H:%M:%S') for timestamp in timestamps]

    screen_dimensions = (122 / 255)
    plt.figure(figsize=fig.figaspect(screen_dimensions))

    plt.plot(timestamps, cpu_usage, label='CPU', linestyle='--', linewidth=6, marker='s')
    plt.plot(timestamps, memory_usage, label='Memory', linestyle='-', linewidth=6, marker='D')

    plt.ylim(0, 100)
    
    axes = plt.gca()
    axes.set_xticks([])

    plt.savefig(image)

    epd = epd2in13_V4.EPD()
    epd.init()
    epd.Clear(0xFF)

    image = Image.open(image)
    image = image.convert("L")
    image = image.resize((250, 122))

    epd.display(epd.getbuffer(image))

    epd.sleep()