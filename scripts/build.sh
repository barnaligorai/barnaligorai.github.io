#! /bin/bash

set -e

rm -rf ./quartz

git clone https://github.com/jackyzha0/quartz.git

cd quartz

# installing dependencies
npm ci

# copying the configurations

cp ../quartz.config.ts .
cp ../quartz.layout.ts .

# linking the content

rm -rf content
rm -fr public

ln -s ../content content

# building the site

npx quartz build -v --concurrency 4

# moving output public folder to the root directory

cp -r public ../public

cd ..
