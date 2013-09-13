export MIUIB=`pwd`
export NOMEPROJ=miui_3.9.6_wagner
export PATHB=${MIUIB}/projetos/${NOMEPROJ}
export FRAMEWORKP=$PATHB/frameworks

APKPACK ()
{
	${MIUIB}/tools/apktool b -a $MIUIB/tools/aapt $1 $2 
	if [ $? -ne 0 ]
	then
		echo APKPACK ERROR: $1 >> $PATHP/error.log
	fi
}

echo Empacotando APKS...
for FILE in $(find $PATHB/unpacked/ -type d -iname "*.apk")
do
	echo $FILE
	cd $(dirname $FILE)
	pwd
	DFILE=$(echo $FILE | sed 's/\/unpacked\//\/repacked\//g')
	APKPACK $(basename $FILE) $DFILE
	cd -
done
