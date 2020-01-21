#!/bin/bash/

while [ -n "$1" ]; do # while loop starts

    case "$1" in
 
    -reference) 
	REFERENCE="$2"
	echo "Input reference is $REFERENCE" 
	shift ;;
 
    -1)
        FR="$2"
         echo "Forward reads - $FR"
         shift
        ;;
 
    -2)
	RR="$2"	
	echo "Reverse reads - $RR" 
	shift
	;;

   -num_iterations)
	NUM_IT="$2"	
	echo "Number of polishing iterations - $NUM_IT" 
	shift
	;; 
   -prefix_name)
	PNAME="$2"	
	echo "Name of temp files - $PNAME" 
	shift
	;; 

    --)
        shift # The double dash makes them parameters
 
        break
        ;;
 
    *) echo "Option $1 not recognized" ;;
 
    esac
 
    shift
 
done
 
total=1
 
for param in "$@"; do
 
    echo "#$total: $param"
 
    total=$(($total + 1))
 
done

RED='\033[0;31m'         #  ${RED}
GREEN='\033[0;32m'      #  ${GREEN}
NORMAL='\033[0m' #  ${NORMAL}
BOLD='\033[1m' # {BOLD}

cp $REFERENCE pilon_"$x"_"$REFERENCE"

x=0
while [ $x -le $NUM_IT ]
do
  echo -e "${BOLD}${RED} $x iteration of polishing... ${NORMAL}"
  echo -e "${BOLD}${RED} indexing reference pilon_"$x"_"$REFERENCE" ${NORMAL}"
  bwa index pilon_"$x"_"$REFERENCE"
  echo -e "${BOLD}${GREEN}...done ${NORMAL}"
  echo -e "${BOLD}${RED} performing alignment to reference and BAM-file sorting ${NORMAL}"
  bwa mem -t 8 pilon_"$x"_"$REFERENCE" $FR $RR | samtools sort -o "$PNAME".bam;
  samtools index "$PNAME".bam	
  echo -e "${BOLD}${GREEN} ...done ${NORMAL}"
  echo -e "${BOLD}${RED} Starting $NUM_IT iterations of polishing ${NORMAL}"
  pilon --genome pilon_"$x"_"$REFERENCE" --frags "$PNAME".bam --threads 8 --output pilon_"$x"_"$REFERENCE"	
  x=$(( $x + 1 ))
done

echo -e "${BOLD}${GREEN} finished ${NORMAL}"
echo -e "${BOLD}${GREEN} polished contigs --- "pilon_"$x"_"$REFERENCE""${NORMAL}"

