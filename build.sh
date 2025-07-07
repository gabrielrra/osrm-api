ROOT_DIR=$(git rev-parse --show-toplevel)

PBF=sudeste-latest.osm.pbf
BASENAME=${PBF%.osm.pbf}

cd $ROOT_DIR/osrm_generated

wget https://download.geofabrik.de/south-america/brazil/sudeste-latest.osm.pbf

docker pull ghcr.io/project-osrm/osrm-backend:latest

docker run -t -v $PWD:/data ghcr.io/project-osrm/osrm-backend \
  osrm-extract -p /opt/car.lua /data/$PBF

docker run -t -v $PWD:/data ghcr.io/project-osrm/osrm-backend \
  osrm-partition /data/$BASENAME.osrm

docker run -t -v $PWD:/data ghcr.io/project-osrm/osrm-backend \
  osrm-customize /data/$BASENAME.osrm

# change owner of all files inside this directory to the current user
chown -R $(id -u):$(id -g) .

docker compose build --no-cache
