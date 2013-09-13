LOCALES="af|am|ar|be|bg|ca|cs|da|de|el|en|it|en-rGB|es|es-rUS|et|fa|fi|fr|hi|hr|hu|in|iw|ja|ko|lt|lv|ms|nb|nl|pl|pt|pt-rPT|pt-rBR|ro|ru|sk|sl|sr|sv|sw|th|tl|tr|uk|vi|zh-rCN|zh-rTW|zu"
export MIUIB=`pwd`
export NOMEPROJ=miui_3.9.6_wagner
export PATHB=${MIUIB}/projetos/${NOMEPROJ}
export FRAMEWORKP=$PATHB/frameworks

rm -fr $PATHB/unpacked
rm -fr $PATHB/frameworks
rm -f $PATHB/error.log
mkdir -p $FRAMEWORKP $PATHB

APKUNPACK ()
{
	#${MIUIB}/tools/apktool d -s -f --frame-path $FRAMEWORKP $1 $2 
	${MIUIB}/tools/apktool d $1 $2 
	if [ $? -ne 0 ]
	then
		echo APKUNPACK ERROR: $1 >> $PATHB/error.log
	fi
}

echo ---
echo Rom inicial: $1
if [ ! -d $PATHB/original ]
then
	unzip $1 -d $PATHB/original
else
	echo Ja existe: $PATHB
fi
echo ----
echo Instalando frameworks para decoding...
for FILE in $PATHB/original/system/framework/*.apk
do
#	${MIUIB}/tools/apktool if $FILE --frame-path $FRAMEWORKP
	${MIUIB}/tools/apktool if $FILE

done
echo ---
echo Executando preexec...
for SCRIPT in $MIUIB/traducao/*/preexec/*.sh
do
        echo $SCRIPT
        bash $SCRIPT
done
echo ---
echo Desempacotando APKS...
for FILE in $(find $PATHB/original/ -type f -iname "*.apk")
do
	echo $FILE
	DFILE=$(echo $FILE | sed 's/\/original\//\/unpacked\//g')
        APKUNPACK $FILE $DFILE
	echo Procurando strings necessarias...
	find $DFILE -name "*.xml" | xargs -n1 grep -Po '(?<=type="string" name=").*(?="\sid=)' | sort >> $DFILE.needed
	echo Integrando traducao...
	for LOCALE in $(find $MIUIB/traducao -mindepth 1 -maxdepth 1 -type d)
	do
		if [ -d $MIUIB/traducao/$(basename $LOCALE)/main/$(basename $FILE) ]
		then
			cp -R $MIUIB/traducao/$(basename $LOCALE)/main/$(basename $FILE)/* $DFILE
		else
			echo "ERROR: $(basename $FILE) SEM TRADUCAO"  >> $PATHB/error.log
		fi
	done
	echo Procurando strings existentes...
	for XML in $(find $DFILE -name "*.xml")
	do
		LOCALE=$(echo $XML | grep -Po "(?<=-)($LOCALES)(?=/)")
		if [ $? -eq 0 ]
		then
			cat $XML | grep -Po '(?<=string name=").*(?="[^a-zA-Z])' | sort >> $DFILE.$LOCALE
		fi
	done
	echo -
done
echo Executando patches...
for SCRIPT in $MIUIB/traducao/*/patches/*.sh
do
	echo $SCRIPT
	bash $SCRIPT
done
echo Executando postexec...
for SCRIPT in $MIUIB/traducao/*/postexec/*.sh
do
        echo $SCRIPT
        bash $SCRIPT
done
echo ----
