#!/usr/bin/env bash

if [[ -n "$1" ]]; then
    cp -i resources/Homestead.json Homestead.json
else
    cp -i resources/Homestead.yaml Homestead.yaml
fi

cp -i resources/after.sh after.sh
cp -i resources/user-install.sh user-install.sh
cp -i resources/aliases aliases

echo "Homestead initialized!"
