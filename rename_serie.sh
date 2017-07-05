#!/bin/bash

# extension des fichiers à garder
extensions='.*\.\(avi\|mov\|mpg\|mkv\|mp4\|mp3\)'

# change le séparateur
IFS=$'\n'

cd "$TR_TORRENT_DIR"
# Si c'est un dossier, on extrait les bon fichiers et on supprimer le dossier
if [ -d "$TR_TORRENT_NAME" ]; then
    # Récupère tous les fichiers qui ont la bonne extension
    files=(`find "$TR_TORRENT_NAME/" -iregex $extensions`)
    if [ $files ]; then
        for file in ${files[@]}; do
            mv $file .
        done
        rm -r "$TR_TORRENT_NAME"
    fi

    # On récupère le nom des fichiers sans le dossier
    files=(${files[@]##*/})

else
    files="$TR_TORRENT_NAME"
fi
for fileName in ${files[@]}; do
    if [ -f "$fileName" ]; then
        # retire tout ce qui ne sert à rien dans le nom de fichier
        newFile=`echo $fileName | sed 's/\.\w*-\w*//ig'`
        newFile=${newFile//\[*\]}
        newFile=${newFile//\.www/}
        newFile=${newFile//\.torrent9}
        newFile=${newFile//\.cpasbien}
        newFile=${newFile//\.ws}
        newFile=${newFile//\.biz}
        newFile=${newFile//\.cm}
        newFile=${newFile//\.pw}
        newFile=${newFile//\.io}
        newFile=${newFile//\.info}
        newFile=${newFile//\ }
        newFile=${newFile//\\t}
        newFile=${newFile//\\n}

        # Permet de récuperer le nom de la série
        firstPart=${newFile%%.*}
        partsName=${newFile#$firstPart.}
        partsName=${partsName//./' '}
        #On remet le séparateur pour les parties du nom du dossier
        IFS=$' '
        dirName=
        for part in $partsName; do
            if [[ "$part" =~ ^S[0-9][1-9]E[0-9][1-9]|(0?[1-9]|[1-9][0-9]){2}$ ]]; then
                break
            else
                dirName+="${part^} "
            fi
        done
        # retire le dernier espace et remet la première partie
        dirName="$firstPart $dirName"
        dirName=${dirName::-1}

        # récupère le numéro de la saison
        season=`echo $newFile | sed 's/^.*S\([0-9][1-9]\)E[0-9][1-9].*$/\1/i'`
        season=`echo $season | awk '{firstCar=substr($1,0,1)} {print "Saison",firstCar==0?substr($1,2):$1}'`

        newFile="$dirName/$season/$newFile"
        if ! [ -d "$dirName" ]; then
            mkdir "$dirName"
        fi

        if ! [ -d "$dirName/$season" ]; then
            mkdir "$dirName/$season"
        fi
        mv "$fileName" "$newFile" 2> /dev/null
    fi
done

