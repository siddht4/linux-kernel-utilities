#!/bin/bash

# Because of overriding the .git config for DEB packaging we need to manually delete .git folder prior to dpkg -r.
rm -rf /opt/linux-kernel-utilities/.git