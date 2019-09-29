Apps=(Music Soundcloud Spotify Springboard Deezer CC Homescreen)
Colors=("#fc3059" "#fc3059" "#fcfcfc" "#fcfcfc" "#fcfcfc" "#fcfcfc" "#fcfcfc")
Enabled=("true" "true" "true" "true" "true" "true" "false")

for idx in ${!Apps[*]}
do
    APP_ID=${Apps[$idx]}
    APP_NAME=${Apps[$idx]}
    APP_COLOR=${Colors[$idx]}
    APP_ENABLED=${Enabled[$idx]}

    cat PlistParts/_skeleton.plist | sed -e "s/%EXTRA%/$(cat PlistParts/${APP_ID}.extra.plist | tr -d '\n' | sed 's:/:\\/:g')/" | sed "s/%APP_ID%/$APP_ID/" | sed "s/%APP_NAME%/$APP_NAME/" | sed "s/%APP_COLOR%/$APP_COLOR/" | sed "s/%APP_ENABLED%/$APP_ENABLED/" | tr -d '\n' | tr -d '\t' | tr '$' '\n' > $2/Library/PreferenceBundles/$1.bundle/${APP_ID}Prefs.plist
done