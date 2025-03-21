#!/bin/bash

podman build -t example.com/aw/test:latest - <<EOF
FROM busybox:latest
CMD echo just a test
EOF