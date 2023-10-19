#!/bin/bash
codi_country="XX"
codi_state="XX"
while true; do
echo "Escull una opció"
echo "1-Sortir (q)"
echo "2-Llistar països (lp)"
echo "3-Seleccionar país (sc)."
echo "4-Seleccionar estat (se)"
echo "5-Llistar els estats del país seleccionat (le)"
echo "6-Llistar les poblacions del país seleccionat (lcp)"
echo "7-Extreure les poblacions del país seleccionat (ecp)"
echo "8-Llistar les poblacions de l’estat seleccionat (lce)"
echo "9-Extreure les poblacions de l’estat seleccionat (ece)"
echo "10-Obtenir dades d’una ciutat de la WikiData (gwd)"
echo "11-Obtenir estadístiques (est)"
read -p "Escull una opció " opcio
case $opcio in
	'q') echo "Sortint de l'aplicació"
	     exit 0
	     ;;
	'lp') awk -F',' '!seen[$8]++ { printf "%-15s   %-25s\n", $7, $8 }' cities.csv 
	     ;;
	'sc') read -p "Introdueix el nom del país:" country_name
		
		if [ -z "$country_name" ]; then
			echo "No s'ha escrit un nou país. Codi: $codi_country"
		else
			 
		        codi_country_nuevo=$(awk -F',' -v name="$country_name" ' $8 == name && !seen[$7]++ {print $7}' cities.csv)
		if [ -z "$codi_country_nuevo" ]; then
			codi_country_nuevo="XX"
			codi_country="$codi_country_nuevo"
			echo "País no trobat. Se li asigna el valor: $codi_country_nuevo"
		else
		        codi_country="$codi_country_nuevo"
			echo "Codi del país actualitzat: $codi_country"
		fi
		fi
		;;
	
	 'se') read -p "Introdueix el nom de l'estat:" state_name
		if [ "$codi_country" == "XX" ]; then
		    echo "Primer introdueix un país amb l'ordre sc"
	    else
	          if [ -z "$state_name" ]; then
	       echo "No s'ha escrit un nou estat. Codi: $codi_state"

		else
			codi_state_nuevo=$(awk -F',' -v country="$codi_country" -v name="$state_name" '$7 == country && $5 == name && !seen[$4]++ {print $4}' cities.csv)
       	if [ -z "$codi_state_nuevo" ]; then

		codi_state_nuevo="XX"
		codi_state="$codi_state_nuevo"
	      	echo "Estat no trobat. Se li assigna el valor: $codi_state_nuevo"
	else
		  

                  codi_state="$codi_state_nuevo"
                  echo "Codi de l'estat actualitzat: $codi_state"
	            fi
		   fi
		fi
		   
		 
		;;


 
      

	


        
	esac
done
