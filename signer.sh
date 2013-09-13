export MIUIB=`pwd`
export NOMEPROJ=miui_3.9.6_wagner
export PATHB=${MIUIB}/projetos/${NOMEPROJ}
export FRAMEWORKP=$PATHB/frameworks

echo Assinando  APKS...
for FILE in $(find $PATHB/repacked/ -type f -iname "*.apk")
do
	echo $FILE
	cd $(dirname $FILE)
	pwd
	DFILE=$(echo $FILE | sed 's/\/repacked\//\/signed\//g')
	mkdir -p $(dirname $DFILE) >/dev/null
	java -jar $MIUIB/tools/signapk.jar $MIUIB/tools/certificate.pem $MIUIB/tools/key.pk8 $FILE $DFILE
	cd -
done
