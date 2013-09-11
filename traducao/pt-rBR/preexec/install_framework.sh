echo Instalando frameworks nao padroes...
if [ -n "$PATHB" ] && [ -f ${0%.*}.txt ]
then
	for APK in $(cat ${0%.*}.txt)
	do
		echo Instalando: $PATHB/$APK
		${MIUIB}/tools/apktool if $PATHB/$APK --frame-path $FRAMEWORKP
	done
fi
