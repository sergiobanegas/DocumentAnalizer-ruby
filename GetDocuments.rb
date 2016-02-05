class GetDocuments
  require 'Article'
  require 'RareDisease'
  require 'WordFunctions'

  def initialize()
    @articleList = Array.new
    @rareDiseasesList = Array.new
    readFiles()
    formatArticles()
    formatRareDiseases()
  end

  def getDocuments()
    return @articleList+@rareDiseasesList
  end

  private

  def readFiles()
    articleList = Array.new
    rareDiseasesList = Array.new
    if !Dir.exist?('docsUTF8')
      abort("El directorio 'docsUTF8' no existe")
    end
    Dir['docsUTF8/*'].each do |fname|
      f = File.open(fname, "r")
      contents = []
      typeDocument=""
      lineNumber=1
      f.each_line do |line|
        contents.push(line.chomp)
      end
      w = WordFunctions.new()
      if (w.is_integer?(contents[1]))&&(w.is_integer?(contents[2]))
        articleList.push(contents)
      else
        rareDiseasesList.push(contents)
      end
      @rareDiseasesList=rareDiseasesList
      @articleList=articleList
      f.close
    end
    if (@rareDiseasesList.length==0 && @articleList.length==0)
      abort("No hay ningún documento sobre enfermedades raras en el directorio 'docsUTF8'")
    end
  end

  def formatArticles()
    articles=Array.new
    @articleList.each do |article|
      sectionsLines=article[6, (article.length-5)]
      sections=Array.new
      i=-1
      section=""
      while (i<(sectionsLines.length-1))
        i+=1
        if (sectionsLines[i]=="--")
          sections.push(section)
          section=""
        else
          if section==""
            section=(section << sectionsLines[i])
          else
            section=(section << "\n"+sectionsLines[i])
          end
        end
      end
      articles.push(Article.new(article[0], article[1], article[2], article[4], sections) )
    end
    @articleList=articles
  end

  def formatRareDiseases()
    rareDiseases=Array.new
    @rareDiseasesList.each do |disease|
      sectionsLines=disease[4, (disease.length-4)]
      sections=Array.new
      i=-1
      section=""
      while (i<(sectionsLines.length-1)) do
        i+=1
        if (sectionsLines[i]=="--")
          sections.push(section)
          section=""
        else
          if section==""
            section=section << sectionsLines[i]
          else
            section=section << "\n"+sectionsLines[i]
          end
        end
      end
      newDisease = RareDisease.new(disease[0], disease[1], disease[2],sections)
      rareDiseases.push(newDisease)
    end
    @rareDiseasesList=rareDiseases
  end

end