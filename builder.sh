HOME=`pwd`
NOMEPROJ=miui_3.9.6_wagner
PATHP=${HOME}/projetos/${NOMEPROJ}
FRAMEWORKP=$PATHP/frameworks
mkdir -p $FRAMEWORKP $PATHP

APKUNPACK ()
{
	${HOME}/tools/apktool d -f --frame-path $FRAMEWORKP $1 $2 
	if [ $? -ne 0 ]
	then
		echo APKUNPACK ERROR: $1 >> $PATHP/error.log
	fi
}

echo ---
echo Rom inicial: $1
if [ ! -d $PATHP/original ]
then
	unzip $1 -d $PATHP/original
else
	echo Ja existe: $PATHP
fi
echo ----
echo Instalando frameworks para decoding...
for FILE in $PATHP/original/system/framework/*.apk
do
	${HOME}/tools/apktool if $FILE --frame-path $FRAMEWORKP
done
echo ----
echo Desempacotando APKS...
for FILE in $PATHP/original/system/app/*.apk
do
	echo $FILE
        APKUNPACK $FILE $PATHP/unpacked/$(basename $FILE)
	find $PATHP/unpacked/$(basename $FILE) -name "*.xml" | xargs -n1 grep -Po '(?<=type="string" name=").*(?="\sid=)' | sort > $PATHP/unpacked/$(basename $FILE).needed
	find $PATHP/unpacked/$(basename $FILE) -name "*.xml" | xargs -n1 grep -Po '(?<=string name=").*(?=")' | sort > $PATHP/unpacked/$(basename $FILE).exists
	echo -
done
echo ----
