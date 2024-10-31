#!/bin/bash

LOG_FILE='./runtime/log.txt'

source ./.venv/bin/activate
python writing-and-displaying.py "./runtime/metrics.db" "./runtime/graph.png"