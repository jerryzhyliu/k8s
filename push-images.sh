#!/bin/sh
# push all the images from output of 'docker images' to logged in repository. e.g richardx
# as prerequisite, should login docker first, test

REPONAME="richardx"

tmp=`docker images | grep -v "^REPOSITORY" | awk -F" " '{ print $1":"$2}'`

for i in $tmp
do
    newImage=`echo $i | awk -F"/" '{ print $NF }'`
    newImage="${REPONAME}/${newImage}"

    docker search ${newImage}  >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Images of $i is already loaded..."
    else
        docker tag $i ${newImage}
        docker push ${newImage}

        docker search ${newImage}  >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            docker rmi ${newImage}
            echo "Succeed to push ${newImage}..."
        else
            echo "Failed to push ${newImage}..."
        fi
    fi
done

