require 'Document'
require 'Functions'

class Cluster
  include Comparable
  def initialize (title, documents)
    @title, @documents = title, documents
    @expandedTitle=expandedTitle(title)
    @functions=Functions.new
  end

  def <=>(cluster)
    cluster.numberOfDocuments <=> @documents.length
  end

  def hasDocument?(document)
    @documents.include? document
  end

  def numberOfDocuments
    @documents.length
  end

  def biggerThanTwo?
    @documents.length>2
  end

  def getRepresentativeAcronyms
    acronyms=[]
    counts = Hash.new 0
    @documents.each do |document|
      acronyms=document.addAcronyms(acronyms)
    end
    acronyms.each do |acronym|
      counts[acronym] += 1
    end
    counts = Hash[counts.sort_by{|k, v| v}.reverse]
    representativeAcronyms=[]
    representativeAcronyms.push("Grupo #{@expandedTitle}:")
    counts.each do |key, value|
      if value > (@documents.length.to_f/2).ceil
        representativeAcronyms.push("#{key} en #{value} documentos")
      else
        break
      end
    end
    if representativeAcronyms.length == 1
      representativeAcronyms.push("Ningún acrónimo representativo")
    end
    representativeAcronyms.push("--------------------------------------")
    return representativeAcronyms
  end

  def uncategorizedDocuments(groups)
    @documents.select{|document| !@functions.clustersIncludeDocument(groups,document) }
  end

  def setDocuments(documents)
    @documents=documents
  end

  def to_s
    toString="Category: #{@expandedTitle}\n"
    @documents.each do |document|
      toString+=document.getIdAndTitle+"\n"
    end
    toString+="------------------------------------------------\n"
    return toString
  end

  def abstract
    "#{@expandedTitle}: #{@documents.length} documentos"
  end

  private

  def expandedTitle(title)
    title=@documents[0].getExpandedForm(@title)
    if (!title)
      title=@title
    end
    return title
  end

end