#YEAR=2007
#WORKING_PATH="/Users/Thomas/Downloads/Stata_translate"
TOTALDTA=$(ls *.dta | wc -l)

if [ $YEAR gt $THRESHOLD ]
then
	TOTALI=$((TOTALDTA / 3))
	echo "$TOTALI"
	for i in `seq 1 $TOTALI`; do 
		for j in `seq 1 3`; do
			FILETOMOVE="tradedata-$YEAR-$i-$j.dta"
			#FOLDERDESTINATION=$WORKING_PATH/sup_2007
			mv $FILETOMOVE $TRANSLATEFOLDER  &&
			echo "Begin translate $FILETOMOVE" &&
			stata-mp -e do 03_translate &&
			echo "Done translated $FILETOMOVE" &&
			mv $TRANSLATEFOLDER/$FILETOMOVE $WORKING_PATH
		done
	done
else
	echo "$TOTALDTA"
	for i in `seq 1 $TOTALDTA`; do 
		FILETOMOVE="tradedata-$YEAR-$i.dta"
		mv $FILETOMOVE $TRANSLATEFOLDER  &&
		echo "Begin translate $FILETOMOVE" &&
		stata-mp -e do 03_translate &&
		echo "Done translated $FILETOMOVE" &&
		mv $TRANSLATEFOLDER/$FILETOMOVE $WORKING_PATH
	done
fi

rm -rf $TRANSLATEFOLDER/bak.stunicode