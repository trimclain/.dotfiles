#!/bin/bash

# Pull my project updates
~/.local/bin/pctl pull 2>&1 | tee -a /tmp/pctl.log & disown
