class GetDocuments
  require 'Article'
  require 'WikiDocument'
  require 'Functions'

  def initialize
    @articleList = []
    @wikiDocumentsList = []
    readFiles
    formatArticles
    formatWikiDocuments
  end

  def getDocuments
    @articleList+@wikiDocumentsList
  end

  private

  def readFiles
    articleList = []
    wikiDocumentsList = []
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
      w = Functions.new
      if (w.is_integer?(contents[1]))&&(w.is_integer?(contents[2]))
        articleList.push(contents)
      else
        wikiDocumentsList.push(contents)
      end
      @wikiDocumentsList=wikiDocumentsList
      @articleList=articleList
      f.close
    end
    if (@wikiDocumentsList.length==0 && @articleList.length==0)
      abort("No hay ningún documento sobre enfermedades raras en el directorio 'docsUTF8'")
    end
  end

  def formatArticles
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

  def formatWikiDocuments
    wikiDocuments=[]
    @wikiDocumentsList.each do |lines|
      sectionsLines=lines[4, (lines.length-4)]
      sections=[]
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
      lines[0].slice!(0)
      wikiDocuments.push(WikiDocument.new(lines[0], lines[1], lines[2], sections))
    end
    @wikiDocumentsList=wikiDocuments
  end

end