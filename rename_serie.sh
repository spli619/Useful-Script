#!/bin/bash

TR_TORRENT_NAME="prison break"
TR_TORRENT_DIR="/home/brian/test"

# extension des fichiers à garder
extension=("avi" "mov" "mpg" "mkv" "mp4" "mp3")

cd "$TR_TORRENT_DIR"
# Si c'est un dossier, on extrait les bon fichier et on supprimer le dossier
if [ -d "$TR_TORRENT_NAME" ]; then
    for i in ${!extension[@]}; do
        # On récupere tous les nom de fichier séparé par un ";"
        file+=`find "$TR_TORRENT_NAME/" -name "*.${extension[i]}" -printf "%p;"`
    done
    i=1
    while [ -f "`echo $file | cut -d \; -f $i`" ]; do
        # On supprime seulement le dossier si il y a les bon fichiers dans le dossier
        deleteDir=true
        mv "`echo $file | cut -d \; -f $i`" .
        i=$((i+1))
    done
    file=`basename "$file"`
    if [ $deleteDir ]; then
        rm -r "$TR_TORRENT_NAME"
    fi
else
    file="$TR_TORRENT_NAME"
fi
i=1
while [ -f "`echo $file | cut -d \; -f $i`" ]; do
    fileName=`echo $file | cut -d \; -f $i`
    # retire tout ce qui ne sert à rien dans le fichier
    newFile=$(echo $fileName | sed 's/\[.*\]//g')
    newFile=$(echo $newFile | sed 's/\.www//g')
    newFile=$(echo $newFile | sed 's/\.torrent9//g')
    newFile=$(echo $newFile | sed 's/\.cpasbien//g')
    newFile=$(echo $newFile | sed 's/\.ws//g')
    newFile=$(echo $newFile | sed 's/\.biz//g')
    newFile=$(echo $newFile | sed 's/\.cm//g')
    newFile=$(echo $newFile | sed 's/\.pw//g')
    newFile=$(echo $newFile | sed 's/\.io//g')
    newFile=$(echo $newFile | sed 's/\.info//g')
    mv "$fileName" "$newFile" 2> /dev/null
    fileName=$newFile

    firstPart=${fileName%%.*}
    filePart=${fileName#$firstPart.}
    filePart=${filePart//./ }
    dirName=
    # récupere le nom de la série
    for part in $filePart; do
        if [[ "$part" =~ ^S[0-9]{1,2}E[0-9]{1,2}|(0?[1-9]|[1-9][0-9]){2}$ ]]; then
            break
        else
            dirName+="$part "
        fi
    done
    # retire le dernier espace et remet la première partie
    dirName="$firstPart $dirName"
    dirName=${dirName::-1}
    if ! [ -d "$dirName" ]; then
        mkdir "$dirName"
    fi
    mv "$fileName" "$dirName"
    i=$((i+1))
done

