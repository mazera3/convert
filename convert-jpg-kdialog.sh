#!/bin/bash
#Conversor entre formatos de imagem jpg
# Edio Mazera - mazera3@gmail.com
#
################# TESTA SE EXISTE APLICATIVOS ################
dialogo=`which kdialog`
converte=`which convert`
headj=`which jhead`
################ DEFININDO VARIÁVEIS ################################
nome=slide ; ext=jpg ; cont=1 ; output=
#####################################################################
if [ ! $dialogo ]
then
	echo "Kdialog nao encontrado. Instale o Kdialog"
	exit 1
fi
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
# MENSAGEM AO USUARIO
kdialog --title "Converte Slides JPG" --msgbox \
"Este programa converte imagem JPG para o formato não entrelaçado \
\ncria cabeçalho mínimo com uma imagem miniatura \
\nusando convert e jhead.\
\nCréditos: Édio Mazera - mazera3@gmail.com." \
0 0
######### PERGUNTA SE DESEJA CONTINUAR ########
kdialog --yesno "Deseja proseguir com a conversão? \n Escolha a pasta que contem os slides. "
if [ "$?" -ne "0" ]
then
echo " Não! Abortado..."
	exit 1
fi
######### VAI AO DIRETORIO ESCOLHIDO ##########
diretorio=$(kdialog --getexistingdirectory "$HOME")
if [ "$?" -ne "0" ]
then
echo " Sem diretorio! Abortado..."
	exit 1
fi
cd "$diretorio"
######### SALVAR O DIRETORIO ATUAL ################
currentdir=`pwd`
qdbus $dbusRef Set "" value 4 ; sleep 1
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
qdbus $dbusRef Set "" value 5 ; sleep 1
qdbus $dbusRef setLabelText "renomeando slides para o formato slide000.jpg"
############ renomeando slides para o formato slide000.jpg ############
cont=1
for i in *.{jpg,JPG}; do
    zeros=`printf "%02d\n" ${cont}`	# acrescenta 00
    nn="tmp${zeros}.jpg"		# concatena imagens no formato img00.jpg
    mv "$i" "$nn"
    [ $? -eq 0 -a "$output" != "nao" ] && echo "[$i] Renomeado para: $nn" 
    cont=`expr $cont + 1`
done
qdbus $dbusRef Set "" value 6 ; sleep 1
qdbus $dbusRef setLabelText "convertendo slides para formato jpg não entrelaçado"
############## CONVERTE PARA JPG NÃO ENTRELAÇADO ####################
    convert -interlace none *.jpg $nome.jpg
qdbus $dbusRef Set "" value 7 ; sleep 1
qdbus $dbusRef setLabelText "removendo arquivos temporarios tmp00 ..."
############## apaga imagens antigas tmp00.jpg ####################
    `rm tmp*`
qdbus $dbusRef Set "" value 8 ; sleep 1
qdbus $dbusRef setLabelText "renomeando slides para o formato slide-00.jpg"
###################### RENOMEANDO SLIDES  ###################################
for X in $(ls -t *.jpg | grep [-][0-9]\.jpg$); do
Y=$(echo $X | cut -d. -f 1)
NOME=$(echo $Y | cut -d- -f 1)
NUM=$(echo $Y | cut -d- -f 2 )
NOVO=$(echo ${NOME}-0${NUM}.jpg)
mv "$X" "$NOVO";
done;
qdbus $dbusRef Set "" value 9 ; sleep 1
qdbus $dbusRef setLabelText "criando cabeçalho mínimo com miniatura"
############## CRIA CABEÇALHO MÍNIMO COM MINIATURA ####################
    jhead -mkexif -rgt *.$ext
qdbus $dbusRef Set "" value 10 ; sleep 1
qdbus $dbusRef setLabelText "slides convertidos"
qdbus $dbusRef Set "" value 11 ; sleep 1
qdbus $dbusRef setLabelText "renomeando slides para o formato slide000.jpg"
############ RENOMEANDO SLIDES POR ORDEM ALFABETICA #####################
cont=1
for i in *.$ext; do
    zeros=`printf "%03d\n" ${cont}`
    nn="${nome}${zeros}.${ext}"
    mv "$i" "$nn"
    [ $? -eq 0 -a "$output" != "nao" ] && echo "[$i] Renomeado para: $nn"
    cont=`expr $cont + 1`
done
qdbus $dbusRef Set "" value 12 ; sleep 1
qdbus $dbusRef setLabelText "concluindo..."
##############################################################################
qdbus $dbusRef close
kdialog --msgbox "Ok, Slides convertidos!"
##############################################################################
#copiar para pendrive
kdialog --yesno "Deseja salvar os slides no PENDRIVE agora? \n Escolha o caminho. "
if [ "$?" = "0" ]; then
    salvar=$(kdialog --getexistingdirectory "$currentdir")
  else
  exit 1
fi
if [ "$?" = "0" ]; then
    cp *.$ext $salvar ; sleep 1
    kdialog --msgbox "Uma cópia dos slides foram salvos no diretório \n $salvar"
else
    kdialog --msgbox "Encerrando..." ; sleep 1
    exit
fi
exit
############################################ FIM #############################
