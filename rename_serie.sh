#!/bin/bash

# extension des fichiers à garder
extensions=("avi" "mov" "mpg" "mkv" "mp4" "mp3")

# change le séparateur
IFS=$'\n'

cd "$TR_TORRENT_DIR"
# Si c'est un dossier, on extrait les bon fichier et on supprimer le dossier
if [ -d "$TR_TORRENT_NAME" ]; then
    for extension in ${extensions[@]}; do
        # On récupere tous les nom de fichier séparé par un ";"
        files+=`find "$TR_TORRENT_NAME/" -name "*.$extension"`
    done

    for file in $files; do
        if [ -f "$file" ]; then
            # On supprime seulement le dossier si il y a les bon fichiers dans le dossier
            deleteDir=true
            mv $file .
        fi
    done
    # On récupère le nom du fichier sans le dossier
    files=${files//"$TR_TORRENT_NAME/"/}
    if [ $deleteDir ]; then
        rm -r "$TR_TORRENT_NAME"
    fi
else
    files="$TR_TORRENT_NAME"
fi
for fileName in $files; do
    if [ -f "$fileName" ]; then
        # retire tout ce qui ne sert à rien dans le nom de fichier
        newFile=${fileName//\[*\]/}
        newFile=${newFile//\.www/}
        newFile=${newFile//\.torrent9/}
        newFile=${newFile//\.cpasbien/}
        newFile=${newFile//\.ws/}
        newFile=${newFile//\.biz/}
        newFile=${newFile//\.cm/}
        newFile=${newFile//\.pw/}
        newFile=${newFile//\.io/}
        newFile=${newFile//\.info/}
        newFile=${newFile//\ /}
        mv "$fileName" "$newFile" 2> /dev/null

        # récupere le nom de la série
        firstPart=${newFile%%.*}
        partsName=${newFile#$firstPart.}
        partsName=${partsName//./' '}
        #On remet le séparateur pour les parties du nom de fichier
        IFS=$' '
        dirName=
        for part in $partsName; do
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
        mv "$newFile" "$dirName"
    fi
done

