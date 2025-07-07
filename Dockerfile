FROM ghcr.io/project-osrm/osrm-backend:latest

# Set maintainer information
LABEL maintainer="gabrielrra.dev@gmail.com"
LABEL description="Production OSRM Routing Service for Ecomobility®"

# Create a non-root user for security
# RUN addgroup -S osrm && adduser -S osrm -G osrm
# RUN mkdir -p /data && chown -R osrm:osrm /data
# COPY --chown=osrm:osrm osrm_generated/*.osrm* /data/

COPY ./osrm_generated /data/

WORKDIR /data

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

CMD ["osrm-routed", "--algorithm", "mld", "--port", "5000", "--ip", "0.0.0.0", "/data/sudeste-latest.osrm"]
