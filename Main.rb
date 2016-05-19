module Main
  require 'GetDocuments'
  require 'Exercises'
  d = GetDocuments.new
  e = Exercises.new(d.getDocuments)
  answer=-1
  while (answer!=0)
    puts "------------------------------------------------------------------------------------------------------------------"
    puts "1- Dado un acrónimo, buscarlo en los diferentes documentos y mostrar los documentos que contengan el acrónimo."
    puts "2- Dado el nombre de una revista y un acrónimo, mostrar los títulos de los artículos publicados en dicha revista que contengan el acrónimo."
    puts "3- Dado un año de publicación, mostrar para cada documento publicado en ese año el listado de acrónimos que contiene acompañados de sus formas expandidas."
    puts "4- Dado un identificador de documento, mostrar un listado de los acrónimos que contiene, acompañado del número de veces que aparece cada acrónimo en el documento."
    puts "5- Mostrar los títulos e identificador de todos aquellos documentos que no contengan ningún acrónimo."
    puts "6- Tratar de agrupar los documentos que se refieran a la misma enfermedad o a la misma temática."
    puts "7- Para cada grupo de documentos similares, mostrar los acrónimos más representativos de un grupo."
    puts "8- Mostrar los diferentes grupos de documentos similares, ordenados de acuerdo a su tamaño."
    puts "9- Mostrar aquellos grupos cuyo tamaño sea superior a dos."
    puts "0- Salir del menú."
    puts "------------------------------------------------------------------------------------------------------------------"
    answer=(gets.chomp).to_i
    case answer
    when 0
      puts "¡Hasta pronto!"
    when 1
      puts "Por favor, introduce un acrónimo"
      acronym=gets.upcase.chomp
      puts "------------------------------------------------------------------------------------------------------------------"
      documents=e.exercise1(acronym)
      if documents.length>0
        puts documents
      else
        puts "Ningún documento contiene el acrónimo #{acronym}"
      end
    when 2
      puts "Introduce el nombre de la revista"
      magazine=gets.upcase.chomp
      puts "Introduce un acrónimo"
      acronym=gets.upcase.chomp
      puts "------------------------------------------------------------------------------------------------------------------"
      titles=e.exercise2(magazine,acronym)
      if titles.length>0
        puts titles
      else
        puts "No hay ningún artículo que haya sido publicado en #{magazine} y/o contenga el acrónimo #{acronym}"
      end
    when 3
      puts "Por favor, introduce un año"
      year=gets.chomp
      puts "------------------------------------------------------------------------------------------------------------------"
      puts e.exercise3(year)
    when 4
      puts "Introduce un identificador de documento"
      id=gets.upcase.chomp
      puts "------------------------------------------------------------------------------------------------------------------"
      puts e.exercise4(id)
    when 5
      puts e.exercise5
    when 6
      puts "------------------------------------------------------------------------------------------------------------------"
      puts e.exercise6
    when 7
      puts "------------------------------------------------------------------------------------------------------------------"
      puts e.exercise7
    when 8
      puts "------------------------------------------------------------------------------------------------------------------"
      puts e.exercise8
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