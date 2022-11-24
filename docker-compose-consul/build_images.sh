#!/usr/bin/env bash

cd ${PWD}/images/"seed-container"
echo "------------------------------------"
echo "Building Docker image for certificate init"
docker build -t consul-certificate-init .
if [ $? != 0 ]; then
      echo "*****************************************************"
      echo "Error building Docker image for certificate-seed"
      echo "Exiting build process"
      echo "*****************************************************"
fi


echo "------------------------------------"
echo "Setting up certificate directory for Consul CA Certificates"
[ -d ../../certificates ] || mkdir ../../certificates && cd ../../certificates
echo "------------------------------------"
echo "Copying certificate seed to directory"
docker run -it --rm -v ${PWD}:/tmp consul-certificate-init "cp /certificates/* /tmp"
cd ../images/
echo "------------------------------------"

for folder in *; do
    if [[ -d "$folder" && ! -L "$folder" && "$folder" != "seed-container" ]]; then
        cd $folder
        if ls -l Dockerfile > /dev/null; then
            echo "------------------------------------"
            echo "Building Docker image for $folder"
            docker build -qt $folder .
            if [ $? != 0 ]; then
               echo "*****************************************************"
               echo "Error building Docker image for $folder"
               echo "Exiting build process"
               echo "*****************************************************"
               exit 1
            fi
            echo "Docker build complete for $folder"
            echo "------------------------------------"
           cd ..
        fi
    fi
done
echo ""
echo "*****************************************************"
echo "All docker images built successfully"
echo "*****************************************************"
