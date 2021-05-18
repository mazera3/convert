#!/bin/bash
################# TESTA SE EXISTE APLICATIVOS ################
converte=`which convert`
headj=`which jhead`
################ DEFININDO VARIÁVEIS ################################
nome=slide ; ext=jpg ; cont=1 ; output=
#####################################################################
if [ ! $converte ]
then
	echo " Convert nao encontrado"
	exit 1
fi
if [ ! $headj ]
then
	echo " Jhead nao encontrado"
	exit 1
fi
############ RENOMEANDO SLIDES POR ORDEM ALFABETICA #####################
N_IMG=`find -iname "img*" | wc -l`
if [ "$N_IMG" -gt "0" ]
    then
    qdbus $dbusRef setLabelText "renomeando slides img0.jpg a img9.jpg"
for X in $(ls -t *.jpg | grep [g][0-9]\.jpg$); do
Y=$(echo $X | cut -d. -f 1)
NOME=$(echo $Y | cut -dg -f 1)
NUM=$(echo $Y | cut -dg -f 2 )
NOVO=$(echo ${NOME}g0${NUM}.jpg)
mv "$X" "$NOVO";
done;
    else
    echo "Não existe img*..."
fi
############ renomeando slides para o formato slide000.jpg ############
cont=1
for i in *.{jpg,JPG}; do
    zeros=`printf "%02d\n" ${cont}`	# acrescenta 00
    nn="tmp${zeros}.jpg"		# concatena imagens no formato img00.jpg
    mv "$i" "$nn"
    [ $? -eq 0 -a "$output" != "nao" ] && echo "[$i] Renomeado para: $nn" 
    cont=`expr $cont + 1`
done
############## CONVERTE PARA JPG NÃO ENTRELAÇADO ####################
convert -interlace none *.jpg $nome.jpg
############## apaga imagens antigas tmp00.jpg ####################
`rm tmp*`
###################### RENOMEANDO SLIDES  ###################################
for X in $(ls -t *.jpg | grep [-][0-9]\.jpg$); do
Y=$(echo $X | cut -d. -f 1)
NOME=$(echo $Y | cut -d- -f 1)
NUM=$(echo $Y | cut -d- -f 2 )
NOVO=$(echo ${NOME}-0${NUM}.jpg)
mv "$X" "$NOVO";
done;
############## CRIA CABEÇALHO MÍNIMO COM MINIATURA ####################
jhead -mkexif -rgt *.$ext
############ RENOMEANDO SLIDES POR ORDEM ALFABETICA #####################
cont=1
for i in *.$ext; do
    zeros=`printf "%03d\n" ${cont}`
    nn="${nome}${zeros}.${ext}"
    mv "$i" "$nn"
    [ $? -eq 0 -a "$output" != "nao" ] && echo "[$i] Renomeado para: $nn"
    cont=`expr $cont + 1`
done
exit
######## FIM ######
