#!/bin/bash

sudo tailscale up --authkey=${tailscale_auth_key}
sudo tailscale set --ssh
