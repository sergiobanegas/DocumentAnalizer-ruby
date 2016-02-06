module Main
  require 'GetDocuments'
  require 'Exercises'
  d = GetDocuments.new
  e = Exercises.new(d.getDocuments)
  answer=-1
  while (answer!=0)
    puts "------------------------------------------------------------------------------------------------------------------"
    puts "1- Mostrar los títulos de los documentos ordenados alfabéticamente y publicados en un año dado."
    puts "2- Mostrar el listado de revistas en las que se han publicado los artículos científicos de toda la colección."
    puts "3- Dado un acrónimo, buscarlo en los diferentes documentos y mostrar los títulos de aquellos que contengan el acrónimo."
    puts "4- Dado el nombre de una revista y un acrónimo, mostrar los títulos de los artículos publicados en dicha revista que contengan el acrónimo."
    puts "5- Dado un año de publicación, mostrar para cada documento publicado en ese año el listado de acrónimos que contiene acompañados de sus formas expandidas."
    puts "6- Dado un identificador de documento, mostrar un listado de los acrónimos que contiene, acompañado del número de veces que aparece cada acrónimo en el documento."
    puts "7- Mostrar los títulos e identificador de todos aquellos documentos que no contengan ningún acrónimo."
    puts "8- Dado un acrónimo, mostrar información de todos los documentos que aparezcan en el acrónimo."
    puts "9- Tratar de agrupar los documentos que se refieran a la misma enfermedad o a la misma temática."
    puts "10- Calcular ciertas estadísticas relacionadas con los grupos de documentos similares."
    puts "0- Salir del menú"
    puts "------------------------------------------------------------------------------------------------------------------"
    answer=(gets.chomp).to_i
    case answer
    when 0
      puts "¡Hasta pronto!"
    when 1
      puts "Por favor, introduce el año: "
      year=gets.chomp
      puts "------------------------------------------------------------------------------------------------------------------"
      titles=e.exercise1(year)
      if titles.length>0
        puts titles
      else
        puts "Ningún documento publicado en #{year}"
      end
    when 2
      puts "------------------------------------------------------------------------------------------------------------------"
      puts e.exercise2
    when 3
      puts "Por favor, introduce un acrónimo"
      acronym=gets.upcase.chomp
      puts "------------------------------------------------------------------------------------------------------------------"
      titles=e.exercise3(acronym)
      if titles.length>0
        puts titles
      else
        puts "Ningún documento contiene el acrónimo #{acronym}"
      end
    when 4
      puts "Introduce el nombre de la revista"
      magazine=gets.upcase.chomp
      puts "Introduce un acrónimo"
      acronym=gets.upcase.chomp
      puts "------------------------------------------------------------------------------------------------------------------"
      titles=e.exercise4(magazine,acronym)
      if titles.length>0
        puts titles
      else
        puts "No hay ningún artículo que haya sido publicado en #{magazine} y/o contenga el acrónimo #{acronym}"
      end
    when 5
      puts "Por favor, introduce un año"
      year=gets.chomp
      puts "------------------------------------------------------------------------------------------------------------------"
      puts e.exercise5(year)
    when 6
      puts "Introduce un identificador de documento"
      id=gets.upcase.chomp
      puts "------------------------------------------------------------------------------------------------------------------"
      puts e.exercise6(id)
    when 7
      puts e.exercise7
    when 8
      puts "Por favor, introduce un acrónimo"
      acronym=gets.upcase.chomp
      puts "------------------------------------------------------------------------------------------------------------------"
      documents=e.exercise8(acronym)
      if documents.length>1
        puts documents
      else
        puts "No hay ningún documento que contenga el acrónimo #{acronym}"
      end
    when 9
      puts "------------------------------------------------------------------------------------------------------------------"
      puts e.exercise9
    when 10
      puts "------------------------------------------------------------------------------------------------------------------"
      puts e.exercise10
    else
      puts "Introduce un número válido"
    end
  end
  
end