class Exercises
  require 'WordFunctions'
  require 'LCS'
  require 'Cluster'

  def initialize (documents)
    @documents = documents
    @acronymsHash = createAcronymHash()
    @groups = createGroups()
    @wordFunctions = WordFunctions.new
  end

  def exercise1(year)
    titles=[]
    @documents.each() do |document|
      if document.publishedInYear?(year)
        titles.push(document.title)
      end
    end
    return titles.sort!
  end

  def exercise2()
    magazines=[]
    @documents.each() do |document|
      if (document.isArticle?)
        magazines.push(document.magazine)
      end
    end
    return (magazines.uniq!())
  end

  def exercise3(acronym)
    titles=[]
    @documents.each() do |document|
      if document.containsAcronym?(acronym)
        titles.push(document.title)
      end
    end
    return titles
  end

  def exercise4(magazine, acronym)
    titles=[]
    @documents.each() do |document|
      if (document.isArticle?)
        if (document.magazine.upcase.include? magazine)&&(document.containsAcronym?(acronym))
          titles.push(document.title)
        end
      end
    end
    return titles
  end

  def exercise5(year)
    expandedForms=[]
    expandedForm=false
    @documents.each() do |document|

      #Con hash
      if document.publishedInYear?(year)
        expandedForms.push("------------------------------------------------")
        expandedForms.push("- "+document.getTitleAndId)
        if (document.hasNoAcronyms?)
          expandedForms.push("Este artículo no tiene acrónimos")
        else
          expandedForms.concat(document.getExpandedFromHash(@acronymsHash))
        end

        #sin hash
        #        expandedForm=true
        #        expandedForms.push("------------------------------------------------")
        #        expandedForms.push("- "+document.getTitleAndId)
        #        if (document.hasNoAcronyms?)
        #          expandedForms.push("Este artículo no tiene acrónimos")
        #        else
        #          documentExpandedForms=document.getExpandedForms
        #          stringExpandedForms=[]
        #          for position in 0..documentExpandedForms.length-1
        #            if (documentExpandedForms[position][1]=="")
        #              documentExpandedForms[position][1]=findExpandedFormDocuments(documentExpandedForms[position][0])
        #            end
        #            stringExpandedForms.push(documentExpandedForms[position][0]+" = "+documentExpandedForms[position][1])
        #          end
        #          expandedForms.push(stringExpandedForms)
        #        end

      end
    end
    if (expandedForms)
      return expandedForms
    else
      return "No hay ningún documento publicado en #{year}"
    end
  end

  def exercise6(id)
    acronymsAndTimes=[]
    exists=false
    @documents.each() do |document|
      if (document.hasId?(id))
        exists=true
        acronymsAndTimes=document.getAcronymAndTimesRepeated
        break
      end
    end
    if exists
      return acronymsAndTimes
    else
      return "No hay ningún artículo con id #{id}"
    end
  end

  def exercise7()
    documentsWithoutAcronyms=[]
    @documents.each() do |document|
      if document.hasNoAcronyms?
        documentsWithoutAcronyms.push(document.getTitleAndId)
      end
    end
    return documentsWithoutAcronyms
  end

  def exercise8(acronym)
    documents=[]
    @documents.each() do |document|
      if (document.containsAcronym?(acronym))
        documents.push(document)
      end
    end
    return documents
  end

  def exercise9()
    return @groups
  end

  def exercise10()
    articlesNumber=0
    rareDiseasesNumber=0
    @documents.each() do |document|
      if document.isArticle?
        articlesNumber+=1
      else
        rareDiseasesNumber+=1
      end
    end
    averageDocumentsPerGroup=@documents.length/@groups.length
    averageArticlesPerGroup=articlesNumber/@groups.length
    averageDiseasesPerGroup=rareDiseasesNumber/@groups.length
    sameYearNumber=0
    oneDocumentNumber=0
    @groups.each() do |group|
      sameYear=true
      year=group.documents[0].year
      group.documents.each() do |document|
        if (!document.publishedInYear?(year))
          sameYear=false
        end
      end
      if (sameYear)
        sameYearNumber+=1
      end
      if group.numberOfDocuments==1
        oneDocumentNumber+=1
      end
    end
    statistics=[]
    statistics.push("Número de grupos: #{@groups.length.to_s}")
    statistics.push("Número medio de documentos por grupo: #{averageDocumentsPerGroup.to_s}")
    statistics.push("Número medio de artículos científicos por grupo: #{averageArticlesPerGroup.to_s}")
    statistics.push("Número medio de documentos de Wikipedia por grupo: #{averageDiseasesPerGroup.to_s}")
    statistics.push("Número de grupos con todos los documentos de la misma fecha: #{sameYearNumber.to_s}")
    statistics.push("Número de grupos con todos los documentos de fechas variadas: #{(@groups.length - sameYearNumber).to_s}")
    statistics.push("Número de grupos con un solo documento: #{oneDocumentNumber.to_s}")
    return statistics
  end

  #----------------------------------------------------------------------------------------------------------------------------
  #----------------------------------------------------MÉTODOS PRIVADOS--------------------------------------------------------
  private

  def createAcronymHash()
    acronymsHash=Hash.new()
    @documents.each() do |document|
      acronymsHash=acronymsHash.merge(document.getAcronymsHash)
    end
    acronymsHash.each() do |acronym|
      if acronymsHash[acronym]==""
        acronymsHash[acronym]==findExpandedFormDocuments(acronym)
      end
    end
    return acronymsHash
  end

  #-------------------------------------------Ejercicio 5----------------------------------------------------------------------
  #Busca la forma expandida en todos los documentos hasta que la encuentre
  def findExpandedFormDocuments(acronym)
    expandedForm=""
    for document in @documents
      expanded=document.getExpandedForm(acronym)
      if expanded.length>1
        expandedForm=expanded
      end
    end
    return expandedForm
  end

  #----------------------------------------------------------------------------------------------------------------------------
  #-----------------------------------------------------Ejercicio 9 y 10-------------------------------------------------------
  def createGroups()
    acronymAndDocumentsList=[]
    @acronymsHash.each do |acronym, expandedForm|
      documents=[]
      for document in @documents
        if document.containsAcronym?(acronym)
          documents.push(document)
        end
      end
      if documents.length>1
        acronymAndDocumentsList.push(Cluster.new(acronym, documents))
      end
    end
    acronymAndDocumentsList.sort!#acronimos y documentos en los que se repiten
    groups=[]
    for cluster in acronymAndDocumentsList
      validDocuments=[]
      for document in cluster.documents
        if clustersIncludeDocument(groups,document)
          cluster.removeDocument(document)
        else
          validDocuments.push(document)
        end
      end
      if validDocuments.length>1
        groups.push(Cluster.new(cluster.title, validDocuments))
      end
    end
    groups.sort!
    uncategorizedDocuments=[]
    for document in @documents
      if (!clustersIncludeDocument(groups, document))
        uncategorizedDocuments.push(document)
      end
    end
    otherCategory=Cluster.new("Other category", uncategorizedDocuments)
    groups.push(otherCategory)
    @groups=groups
  end

  #Dada una id de un documento, devuelve true si se encuentra en una categoría
  def clustersIncludeDocument(clusters, document)
    for cluster in clusters
      if cluster.hasDocument?(document)
        return true
      end
    end
    return false
  end

  #devuelve el número de documentos categorizados
  def categorizedDocumentNumber(clusters)
    number=0
    for cluster in clusters
      number+=cluster.numberOfDocuments
    end
    return number
  end

end