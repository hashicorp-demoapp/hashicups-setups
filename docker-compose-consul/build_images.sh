#!/usr/bin/env bash

 cd ${PWD}/images/
 for folder in *; do
     if [[ -d "$folder" && ! -L "$folder" && "$folder" ]]; then
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
