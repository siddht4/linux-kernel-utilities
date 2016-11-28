#!/bin/bash

# Overrides Github configuration when installing using DEB packaging.
cat << EOF > /opt/linux-kernel-utilities/.git/config
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
[remote "origin"]
	url = https://github.com/mtompkins/linux-kernel-utilities.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
	remote = origin
	merge = refs/heads/master
EOF