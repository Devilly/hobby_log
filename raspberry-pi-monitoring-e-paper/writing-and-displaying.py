from datetime import datetime, timedelta, timezone
import sqlite3
import psutil
import sqlite3
import sys
import matplotlib.pyplot as plt
import matplotlib.figure as fig
import matplotlib.dates as mdates

database = sys.argv[1]

with sqlite3.connect(database, autocommit=True) as connection:
    cursor = connection.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS percentages (
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP UNIQUE,
            cpu REAL,
            memory REAL
        );
    """)

    cursor.execute(f"INSERT INTO percentages (cpu, memory) VALUES ({psutil.cpu_percent()}, {psutil.virtual_memory().percent});")

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

    plt.plot(timestamps, cpu_usage, label='CPU', linestyle='-', marker='s')
    plt.plot(timestamps, memory_usage, label='Memory', linestyle='--', marker='D')

    plt.title('Usage')

    plt.xlabel('Time')
    plt.xticks(rotation=45)
    ax = plt.gca()
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M'))
    ax.xaxis.set_minor_locator(mdates.MinuteLocator(interval=5))

    plt.ylabel('Percentage')
    plt.ylim(0, 100)
    
    plt.legend()
    plt.tight_layout()

    plt.show()