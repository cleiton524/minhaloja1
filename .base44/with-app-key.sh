#!/bin/sh
# Laravel needs APP_KEY as "base64:<32 bytes>" or a raw 32-char string.
# The platform-generated development placeholder is neither, so derive a stable
# valid key from it. A properly formatted APP_KEY is passed through unchanged.
set -e
case "$APP_KEY" in
  base64:*) ;;
  *)
    if [ "${#APP_KEY}" -ne 32 ]; then
      APP_KEY="base64:$(php -r 'echo base64_encode(hash("sha256", getenv("APP_KEY"), true));')"
      export APP_KEY
    fi
    ;;
esac
exec "$@"
