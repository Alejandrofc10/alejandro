#!/bin/bash
repetir=0
bucle=1
function menu {
echo "*************"
echo "FICHERO LDIF"
echo "*************"
echo "1.Añadir"
echo "2.Modificar"
echo "3.Eliminar"
echo "4.Salir"
echo ""
}
function añadir {

	echo "	a.Añadir unidad organizativa"
	echo "	b.Crear fichero ldif apartir de un CSV"
	echo ""
	read -p "	Opcion: " opcion
		
		case $opcion in
		a) read -p "	Nombre LDIF a crear: " ldif
		if [ -f $ldif.ldif ];then
		read -p "	Introduce el nombre de la unidad organizativa que quieras crear: " ou
			echo "dn: ou=$ou,dc=aula28,dc=com" >> $ldif.ldif
			echo "objectClass: organizationalUnit" >> $ldif.ldif
			echo "objectClass: top" >> $ldif.ldif
			echo "ou: $ou" >> $ldif.ldif
		else
			echo "El fichero $ldif ya existe"
		fi
		;;	
		b) read -p "	Introduce nombre fichero CSV (sin extension): " fichero
		   read -p "	Nombre fichero a crear LDIF (sin extension): " ldif
				if [ -f $ldif.ldif ];then
					echo "	El archivo $ldif ya existe"
				else
					touch $ldif.ldif
						

					if [ -f $fichero.csv ];then
						numlin=$(cat $fichero.csv | wc -l)
						let numlin=$numlin-1

						for var in $(tail -n$numlin $fichero.csv)
						do

							Nom=$(echo $var | cut -d , -f 1 | cut -c1)
							Nom2=$(echo $var | cut -d , -f 1)
							Cognom=$(echo $var | cut -d , -f 2 )
							Password=$(echo $var | cut -d , -f 3)
							UIDnumber=$(echo $var | cut -d , -f 4)
							GIDnumber=$(echo $var | cut -d , -f 5)
							ou=$(echo $var | cut -d , -f 6)




							echo "dn: uid=$Nom$Cognom,ou=$ou,dc=aula28,dc=com" >> $ldif.ldif
							echo "uid: $Nom$Cognom" >> $ldif.ldif
							echo "cn: $Nom2 $Cognom" >> $ldif.ldif
							echo "objectclass: account" >> $ldif.ldif
							echo "objectclass: posixAccount" >> $ldif.ldif
							echo "objectclass: top" >> $ldif.ldif	
							echo "loginshell: /bin/bash" >> $ldif.ldif
							echo "homedirectory: /home/$Nom$Cognom" >> $ldif.ldif	
							echo "uidnumber: $UIDnumber" >> $ldif.ldif
							echo "gidnumber: $GIDnumber" >> $ldif.ldif
							echo "userpassword: {crypt}$Password" >> $ldif.ldif
							echo "" >> $ldif.ldif

						done
						
				
				
					else
						echo ""
						echo "	El archivo $fichero no existe"	
						echo ""
				fi
			
					fi
						
				;;
			esac

}


function modificar {
	echo ""
	echo "	a.Modificar por csv (no recomendable/ no acabado)"
	echo "	b.Modificar por read"
	echo ""
	read -p "	Opcion: " opcion
	case $opcion in
		a)submenucsv ;;
		b)submenuread ;;
esac


}
function submenucsv {
	echo ""
	read -p "	Introduce el archivo csv que quieras modificar (sin extension): " csv
	if [ -f $csv.csv ];then
		echo ""
		echo "	FICHERO: "
		echo ""
		cat -n $csv.csv
		echo ""
 	

		read -p "Que linea quieres modificar? " linea
		read -p "Que palabra/numero quiere cambiar?: " atributo1
		if [[ $(cat $csv.csv | grep $atributo1 | wc -l) -eq 1 ]]; then
			read -p "Introduce nueva palabra: " atributo2

			sed "$linea s/$atributo1/$atributo2/g" $csv.csv > tmp
			mv tmp $csv.csv
		else
			echo ""
			echo "La palabra $atibuto1 no existe"
			exit
		fi

		

		read -p "Nombre nuevo ldif (sin extension): " ldif
		touch $ldif.ldif

		numlin=$(cat $csv.csv | wc -l)
		let numlin=$numlin-1
		for var in $(tail -n$numlin $csv.csv)
		do
				
			Nom=$(echo $var | cut -d , -f 1 | cut -c1)
			Nom2=$(echo $var | cut -d , -f 1)
			Cognom=$(echo $var | cut -d , -f 2 )
			Password=$(echo $var | cut -d , -f 3)
			UIDnumber=$(echo $var | cut -d , -f 4 )
			GIDnumber=$(echo $var | cut -d , -f 5)
			ou=$(echo $var | cut -d , -f 6)

			echo "dn: uid=$Nom$Cognom,ou=$ou,dc=aula28,dc=com" >> $ldif.ldif
			echo "uid: $Nom$Cognom" >> $ldif.ldif
			echo "cn: $Nom2 $Cognom" >> $ldif.ldif
			echo "objectclass: account" >> $ldif.ldif
			echo "objectclass: posixAccount" >> $ldif.ldif
			echo "objectclass: top" >> $ldif.ldif
			echo "loginshell: /bin/bash" >> $ldif.ldif
			echo "homedirectory: $Nom$Cognom" >> $ldif.ldif
			echo "uidnumber: $UIDnumber" >> $ldif.ldif
			echo "gidnumber: $GIDnumber" >> $ldif.ldif
			echo "userpassword: {crypt}$Password" >> $ldif.ldif
			echo "" >> $ldif.ldif

		done

	else
		echo "	El archivo $csv no existe"
		echo ""
		


	fi
}


function submenuread {
	echo ""
 	read -p "	Nombre nuevo ldif (sin extension): " ldif
	if [ -f $ldif.ldif ];then
		echo "	El fichero $ldif ya existe"
	else
		touch $ldif.ldif
		echo ""
		echo "	SUBMENU MODIFICAR"
		echo "	a.Añadir atributo"
		echo "	b.Reemplazar atributo"
		echo "	c.Eliminar atributo"
		echo "	d.Volver al menu principal"
		echo ""
		read -p "	Opcion: " opcion
			case $opcion in

	
			a) 	read -p "	Introduce fichero ldif que quiera cambiar (sin extension): " l 
				echo ""	
				if [ -f $l.ldif ];then
					cat $l.ldif
					echo ""
					read -p "Nombre UID: " uid
					read -p "Nombre unidad organizativa: " ou
					read -p "Nombre atributo a añadir: " atributo
					read -p "Opcion de atributo a añadir: " opcionatributo

					echo "dn: uid=$uid,ou=$ou,dc=aula28,dc=com" >> $ldif.ldif
					echo "changetype: modify" >> $ldif.ldif
			 		echo "add: $atributo" >> $ldif.ldif
			 		echo "$atributo: $opcionatributo" >> $ldif.ldif
					añadirmastributos
				else 
					echo "	El archivo $l no existe"
				fi
			;;
	
			b)	read -p "	Introduce fichero ldif que quiera cambiar (sin extension): " l	
				echo ""
				if [ -f $l.ldif ];then
					cat $l.ldif 
					echo ""	
					read -p "Nombre UID: " uid
					read -p "Nombre unidad organizativa: " ou
					read -p "Atributo para reemplazar: " atributo 
					read -p "Nuevo opcion del atributo: " atributoNuevo

					echo "dn: uid=$uid,ou=$ou,dc=aula28,dc=com">> $ldif.ldif
					echo "changetype: modify" >> $ldif.ldif
					echo "replace: $atributo" >> $ldif.ldif
					echo "$atributo: $atributoNuevo" >> $ldif.ldif
					añadirmastributos
				else 
					echo "	El archivo $l no existe"
				fi
			;;


			 c) 	read -p "	Introduce fichero ldif que quiera cambiar (sin extension): " l	
				echo ""
				if [ -f $l.ldif ];then
					cat $l.ldif 
					echo ""	
					read -p "Nombre UID: " uid
					read -p "Nombre unidad organizativa: " ou
					read -p "Nombre atributo a eliminar: " atributo

					echo "dn: uid=$uid,ou=$ou,dc=aula28,dc=com" >> $ldif.ldif
					echo "changetype: modify" >> $ldif.ldif
				 	echo "delete: $atributo" >> $ldif.ldif
					añadirmastributos
				else 
					echo "	El archivo $l no existe"
				fi
			 ;;
			 d) ;;
		esac
	fi

		
}
function añadirmastributos {
echo ""

while [ $bucle -eq 1 ]
do
	echo ""
	read -p "Quiere añadir algun atributo mas? [si/no]: " opcion
		case $opcion in

		si)	echo "" 	
			echo "		a.Atributo añadir"
			echo "		b.Atributo modificar"
			echo "		c.Atributo eliminar"
			echo ""
				read -p "		Opcion: " opcion2
				case $opcion2 in
			
					a) 	read -p "		Atributo a añadir: " a
						read -p "		Introduce opcion del atributo añadido: " opciona
						echo "-" >> $ldif.ldif
						echo "add: $a" >> $ldif.ldif
						echo "$a: $opciona" >> $ldif.ldif
					;;
	
					b)	read -p "		Atributo para reemplazar: " a 
						read -p "		Introduce nueva opcion al atributo: " aNuevo
						echo "-" >> $ldif.ldif
						echo "replace: $a" >> $ldif.ldif
						echo "$a: $aNuevo" >> $ldif.ldif
					;;
				
					c) 	read -p "		Atributo para eliminar: " a 
						echo "-" >> $ldif.ldif
						echo "delete: $a" >> $ldif.ldif
					;;
				esac
			;;

		no) bucle=0 ;;

					
		esac

				
done
				

}

function eliminar {

	read -p "	Fichero ldif a crear (sin extension): " ldif
	if [ -f $ldif.ldif ];then
		echo "	El fichero $ldif ya existe"
	else 
		touch $ldif.ldif
		read -p "	Fichero ldif donde esta el usuario: " l
		if [ -f $l.ldif ];then
		

			cat $l.ldif
			echo ""
			read -p "	Nombre UID: " uid
			read -p "	Nombre unidad organizativa: " ou
			echo "uid=$Nom$Cognom,ou=$ou,dc=aula28,dc=com" >> $ldif.ldif
			echo "changetype: delete" >> $ldif.ldif
			echo ""
			while [ $bucle -eq 1 ]
			do
				read -p "Quiere eliminar mas usuarios? [si/no]: " opcion
				case $opcion in
					si) read -p "	Nombre UID: " uid
					read -p "	Nombre unidad organizativa: " ou
					echo "uid=$Nom$Cognom,ou=$ou,dc=aula28,dc=com" >> $ldif.ldif
					echo "changetype: delete" >> $ldif.ldif
					echo ""
					;;
				
					no) bucle=0 ;;
				esac
		
			done
		else
			echo "	El fichero $l no existe"	
		
		
		
		fi

			
	fi
			
}
function salir {

	repetir=1
	echo ""
	echo "Saliendo"

}

function opcionNovalida {
	echo ""
	echo "La opcion no es valida"

}




while [ $repetir -ne 1 ]
do
	echo ""
	menu
	read -p "Introduce tu opcion: " opcion
	echo " "
	case $opcion in
	1) añadir ;;
	2) modificar ;;
	3) eliminar ;;
	4) salir ;;
	*) opcionNovalida
	clear ;;
	esac
done



