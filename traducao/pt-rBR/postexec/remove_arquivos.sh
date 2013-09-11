echo Removendo APKs indesejados.
if [ -n "$PATHB" ] && [ -f ${0%.*}.txt ]
then
	for APK in $(cat ${0%.*}.txt)
	do
		echo Removendo: $PATHB/$APK
		rm -fr $PATHB/$APK
	done
fi
