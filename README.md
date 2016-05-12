# Docker Image for Vertica

Vertica Community Edition cluster. MC. Kafka integration scheduler. SLOW starting.

Based on https://github.com/bluelabsio/docker-vertica

Warning: This is very experimental. The level of testing has consisted of "Start server, run some sql, shutdown server, restart server, run some sql". What it does manage to do is get a vertica process up and running in a docker container. For the purposes of testing applications with fig and such, this might be sufficient, but don't let it anywhere near production.
