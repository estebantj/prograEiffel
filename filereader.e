note
	description: "Summary description for {FILEREADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FILEREADER

feature
	load_csv_as_json (nombre_archivo: STRING)
	    local
	    	archivo: PLAIN_TEXT_FILE
	    	linea: STRING
	    	linea_separada: LIST[STRING]
	    	i: INTEGER
	    	j: INTEGER
	    	contenerdor: JSON_CONTAINER
	    	json: JSON_OBJECT
	    	nombre_atributos: LIST[STRING]
	    	tipo_datos: LIST[STRING]
	    	tipo: STRING
	    	nombre: STRING
	    do
	    	create archivo.make (nombre_archivo)
	        if not archivo.exists then
    			print ("Archivo no encontrado%N")
    		else
				if not archivo.is_readable then
					print("No se puede leer el archivo%N")
				else
					archivo.open_read
					archivo.read_line
					-- Se guarda el nombre de cada atributo para su uso posterior
					linea := archivo.last_string.twin
					print("Atributos: "+linea+"%N")
					nombre_atributos := linea.split (';')

					archivo.read_line
					-- Se guarda el tipo de datos de cada atributo
					linea := archivo.last_string.twin
					print("Tipo de datos : "+linea+"%N")
					tipo_datos := linea.split (';')

					-- Este ciclo se repite hasta que se no se puedan leer mas lineas del archvo ##################
					from
						i := 0
					until
						i >= 1
					loop
						archivo.read_line
						if not archivo.last_string.is_empty then
							linea := archivo.last_string.twin
							linea_separada := linea.split (';')
							create json.make_empty
							-- Este ciclo es para recorrer cada element de la linea ########################
							from
								j:=1
							until
								j = linea_separada.count
							loop
								--print(nombre_atributos[j] + " " + tipo_datos[j] + " " + linea_separada[j] + "%N")
								tipo := tipo_datos[j]
								nombre := nombre_atributos[j]
								inspect
									tipo.at (1)
								when 'X' then
									json.put_string (linea_separada[j], nombre)
								when '9' then
									json.put_real (linea_separada[j].to_real, nombre)
								when 'B' then
									inspect
										linea_separada[j].at (1)
									when 'T','S' then
										json.put_boolean (True, nombre)
									when 'F','N' then
										json.put_boolean (False, nombre)
									end
								end

								j := j+1
							end
							print(json.representation)
							Io.new_line
							i := i - 1
						else
							i := 1
						end

					end
					archivo.close
				end
    		end
	    end
end
