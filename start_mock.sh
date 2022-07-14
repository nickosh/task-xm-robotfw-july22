#!/bin/sh

uvicorn mocksrv.main:mock --host $MOCK_IP --port $MOCK_PORT --log-config mocksrv/logger.ini
