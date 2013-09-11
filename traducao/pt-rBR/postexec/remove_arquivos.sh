echo Removendo arquivos indesejados.
if [ -n "$PATHB" ] && [ -f ${0%.*}.txt ]
then
	for FILE in $(cat ${0%.*}.txt)
	do
		echo Removendo: $PATHB/$FILE
		rm -fr $PATHB/$FILE
	done
fi
