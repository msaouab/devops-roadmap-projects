# Basic Dockerfile (roadmap.sh project 10)
# Prints "Hello, Captain!" and exits.
#
#   docker build -t hello-captain .
#   docker run --rm hello-captain                 -> Hello, Captain!
#
# Stretch goal - choose the name at build time:
#   docker build --build-arg NAME=Mohammed -t hello-mohammed .
#   docker run --rm hello-mohammed                -> Hello, Mohammed!

FROM alpine:latest

# Build-time argument with a default...
ARG NAME=Captain
# ...copied into an environment variable so it still exists when the container runs
ENV NAME=${NAME}

# The single instruction that does the work (sh expands $NAME at run time)
CMD ["sh", "-c", "echo \"Hello, ${NAME}!\""]
