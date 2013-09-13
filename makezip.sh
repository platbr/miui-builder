export MIUIB=`pwd`
export NOMEPROJ=miui_3.9.6_wagner
export PATHB=${MIUIB}/projetos/${NOMEPROJ}
export FRAMEWORKP=$PATHB/frameworks

echo Gerando ZIP!!
rm -fr $PATHB/merged
mkdir $PATHB/merged
cp -R $PATHB/original/* $PATHB/merged
cp -R $PATHB/signed/* $PATHB/merged
cd $PATHB/merged
zip -r $PATHB.zip *
echo Assinando ZIP!!
java -jar $MIUIB/tools/signapk.jar $MIUIB/tools/certificate.pem $MIUIB/tools/key.pk8 $PATHB.zip ${PATHB}_signed.zip
echo FIM!!
