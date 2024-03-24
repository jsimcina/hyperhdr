#!/bin/bash

export HYPERHDR_CONFIG_PATH=/config

/usr/bin/hyperhdr -v --service -u $HYPERHDR_CONFIG_PATH

echo 'Running webUI on port 8090. Port 19444-19445 exposed for json, protobuffer server (hyperion-screen-cap).'