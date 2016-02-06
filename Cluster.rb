require 'Document'
require 'Functions'

class Cluster
  include Comparable
  def initialize (title, documents)
    @title, @documents = title, documents
    @functions=Functions.new
  end

  attr_accessor :title, :documents

  def <=>(cluster)
    cluster.documents.length <=> @documents.length
  end

  def hasDocument?(document)
    @documents.include? document
  end

  def removeDocument(document)
    @documents.delete(document)
  end

  def numberOfDocuments
    @documents.length
  end

  def deleteCategorized(groups, clusters)
    validDocuments=[]
    @documents.each do |document|
      if @functions.clustersIncludeDocument(groups,document)
        removeDocument(document)
      else
        validDocuments.push(document)
      end
    end
    return validDocuments
  end

  def sameYearDocuments?
    sameYear=true
    year=@documents[0].year
    for document in @documents
      if (!document.publishedInYear?(year))
        sameYear=false
      end
    end
    return sameYear
  end

  def aSingleDocument?
    return @documents.length==1
  end

  def to_s
    expandedFormTitle=@documents[0].getExpandedForm(@title)
    if expandedFormTitle==""
      expandedFormTitle=@title
    end
    toString="Category: #{expandedFormTitle}\n"
    for document in @documents
      toString+=document.getIdAndTitle+"\n"
    end
    toString+="------------------------------------------------\n"
    return toString
  end

end