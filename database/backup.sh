#!/bin/bash
pg_dump -h localhost -U postgres boardgame > backup_$(date +%F).sql