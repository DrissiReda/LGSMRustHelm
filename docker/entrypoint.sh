#!/bin/bash

set -e

./rustserver start
tail -f log/console/rustserver-console.log
