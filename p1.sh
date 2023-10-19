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


 
        'le') if [ "$codi_country" == "XX" ]; then
		echo "Primer selecciona un país amb l'ordre sc"
	      else
		     echo "LListat d'estats del país seleccionat ($codi_country):"
		      awk -F',' -v country="$codi_country" '$7 == country && !seen[$5]++ {print $4, $5}' cities.csv
	fi
	;;
       'lcp') if [ "$codi_country" == "XX" ]; then
	       echo "Primer selecciona un país amb l'ordre sc"
	      else
		      echo "LListat de poblacions del país seleccionat ($codi_country):"
		      awk -F',' -v country="$codi_country" '{ if ($7 == country) { printf "%-25s   %-10s\n", $2, $11 } }' cities.csv
		      
	fi
	;;
       'ecp') if [ "$codi_country" == "XX" ]; then
	       echo "Primer selecciona un país amb l'ordre sc"
	      else
		file="$codi_country.csv"
		echo "S'està generant un fitxer $file amb les poblacions del país seleccioant ($codi_country)"
		awk -F',' -v country="$codi_country" '{ if ($7 == country) { printf "%s,%s\n", $2, $11 } }' cities.csv > "$file"
	fi
	;;
       'lce') if [ "$codi_country" == "XX" ]; then
	       echo "Primer selecciona un país amb l'ordre sc"
       elif [ "$codi_state" == "XX" ]; then
	       echo "Primer selecciona un estat amb l'ordre se"

       else
	     echo "Llistat de poblacions de l'estat i país seleccionat ($codi_country):"
	       awk -F',' -v country="$codi_country" -v state="$codi_state" '{ if ($7 == country && $4 == state) { printf "%-30s %-10s\n", $2, $11 } }' cities.csv
        fi
	;;
'ece') if [ "$codi_country" == "XX" ]; then
	echo "Primer selecciona un país amb l'ordre sc"
      elif [ "$codi_state" == "XX" ]; then
	echo "Primer selecciona un estat amb l'ordre se"
else
	file2="${codi_country}_${codi_state}.csv"
echo "S'està generant un fitxer $file2 amb les poblacions de l'estat seleccionat ($codi_state)"
 awk -F',' -v country="$codi_country" -v state="$codi_state" ' { if ($7 == country && $4 == state) { printf "%s,%s\n", $2, $11 } }' cities.csv >"$file2"
				            fi
					            ;;
'gwd') if [ "$codi_country" == "XX" ]; then
        echo "Primer selecciona un país amb l'ordre sc"
       elif [ "$codi_state" == "XX" ]; then
        echo "Primer selecciona un estat amb l'ordre se"	
     else
	   read -p "Introdueix el nom d'una població:" city_name
	   wikidata=$(awk -F',' -v country="$codi_country" -v state="$codi_state" -v city="$city_name" ' { if ($7 == country && $4 == state && $2 == city) { print $11 } }' cities.csv)
     if [ -z "$wikidata" ]; then 
  echo " No s'ha trobat la wikidataId per a la població especificada"
   else
	   wikidata2=$(echo "$wikidata" | tr -d '\r')
	   wikidata_url="https://www.wikidata.org/wiki/Special:EntityData/$wikidata2.json"
	   wget 0 "$wikidata2.json" "$wikidata_url"
	   

        
 fi
fi
;;
'est') awk -F',' '{
	if ($9>0) nord++
	else if ($9<0) sud++
	if ($10>0) est++
	else if ($10<0) oest++
	if ($9 == 0 && $10 == 0) no_ubic++
	if ($11 == "") no_wdid++
	}
	END{
	printf "Nord %d Sud %d Est %d Oest %d No ubic %d No WDid %d\n", nord, sud, est, oest, no_ubic, no_wdid
}' cities.csv
;;
	


        
	esac
done
