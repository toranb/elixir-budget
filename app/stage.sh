#!/bin/bash

cd ui && yarn build
cd ..

cd priv
cp -r ../ui/build/static .
cd static

cp ../../ui/build/asset-manifest.json .
cd ..
cd ..
