class Exercises
  require 'Cluster'
  require 'Functions'

  def initialize (documents)
    @documents = documents
    @functions = Functions.new
    @acronymsHash = createAcronymHash
    @groups = createGroups
  end

  def exercise1(acronym)
    @documents.select{|document| document.containsAcronym?(acronym) }
  end

  def exercise2(magazine, acronym)
    @documents.map{|document| document.publishedInMagazineAndContainsAcronym(magazine, acronym) if document.isArticle?}.compact.sort
  end

  def exercise3(year)
    expandedForms=[]
    @documents.each do |document|
      if document.publishedInYear?(year)
        expandedForms.push("------------------------------------------------")
        expandedForms.push("- "+document.getTitleAndId)
        if document.hasNoAcronyms?
          expandedForms.push("Este artículo no tiene acrónimos")
        else
          expandedForms.concat(document.getExpandedFromHash(@acronymsHash))
        end
      end
    end
    if (expandedForms)
      return expandedForms
    else
      return "No hay ningún documento publicado en #{year}"
    end
  end

  def exercise4(id)
    acronymsAndTimes=[]
    @documents.each do |document|
      if document.hasId?(id)
        acronymsAndTimes=document.getAcronymsAndTimesRepeated
        break
      end
    end
    if acronymsAndTimes.length>0
      return acronymsAndTimes
    else
      return "No hay ningún artículo con id #{id}"
    end
  end

  def exercise5
    @documents.map{|document| document.getTitleAndId if document.hasNoAcronyms?}.compact
  end

  def exercise6
    @groups
  end

  def exercise7
    @groups.collect{|group| group.getRepresentativeAcronyms}
  end

  def exercise8
    @groups.sort.collect{|group| group.abstract}
  end

  def exercise9
    @groups.select{|group| group.biggerThanTwo? }
  end

  private

  def createAcronymHash
    acronymsHash=Hash.new
    @documents.each do |document|
      acronymsHash=document.addAcronymsHash(acronymsHash)
    end
    acronymsHash.each do |acronym, expanded|
      if expanded==""
        acronymsHash[acronym]=findExpandedFormDocuments(acronym)
      end
    end
    return acronymsHash
  end

  def findExpandedFormDocuments(acronym)
    expandedForm=""
    @documents.each do |document|
      expanded=document.getExpandedForm(acronym)
      if expanded
        expandedForm=expanded
        break
      end
    end
    return expandedForm
  end

  def createGroups
    acronymAndDocumentsList=[]
    @acronymsHash.each do |acronym, expandedForm|
      documents=@documents.select{|document| document.containsAcronym?(acronym) }
      if documents.length>1
        acronymAndDocumentsList.push(Cluster.new(acronym, documents))
      end
    end
    acronymAndDocumentsList.sort!
    groups=[]
    acronymAndDocumentsList.each do |cluster|
      validDocuments=[]
      validDocuments=cluster.uncategorizedDocuments(groups)
      if validDocuments.length>1
        cluster.setDocuments(validDocuments)
        groups.push(cluster)
      end
    end
    groups.sort!
    otherCategory=Cluster.new("Other category", @documents.select{|document| !@functions.clustersIncludeDocument(groups, document) })
    if (otherCategory)
      groups.push(otherCategory)
    end
    return groups
  end

end