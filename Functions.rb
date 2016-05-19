class Functions
  def initialize
  end

  def clustersIncludeDocument(clusters, document)
    clusters.each do |cluster|
      if cluster.hasDocument?(document)
        return true
      end
    end
    return false
  end

  def isAcronym?(acronym)
    if (acronym.include? ")")&&(acronym[acronym.length-1]!=")")
      return false
    end
    acronym=acronym.gsub(/[()]/, '')
    if acronym[acronym.length-1].chr.gsub(/[.,:;()]/, '').length==0
      acronym=acronym[0..acronym.length-2]
    end
    return (numberAndLetters?(acronym))&&(acronym==acronym.upcase)&&(!isRomanNumeral?(acronym))&&(!is_integer?(acronym))&&(acronym.length>1)&&(!((acronym.length==2)&&((is_integer?(acronym[0]))||(is_integer?(acronym[1])))))
  end

  def isInvalidWord? (word)
    (word=="and")||(word=="for")||(word=="of")||(word.include? "(")||(word.include? ")")||(word == "and")||(word=="as")||(word=="such")
  end

  def firstLetters (words, acronym)
    firsts=""
    words.each do |word|
      if word[0].chr=="["
        word=word[1..word.length-1]
      end
      if (word.include? "-")
        splittedWords=word.split("-")
        if splittedWords[0].chr==splittedWords[0].chr.upcase#si empieza por mayuscula se agrega
          splittedWords.each do |splittedWord|
            if (acronym.include? splittedWord)&&(isAcronym?(splittedWord))
              firsts+=splittedWord
            elsif splittedWord.chr==splittedWord.chr.upcase
              firsts+=splittedWord.chr
            end
          end
        else
          splittedWords.each do |splittedWord|
            firsts+=splittedWord.chr
          end
        end

      elsif isInvalidWord?(word)

      else
        if (acronym.include? word)&&(isAcronym?(word))
          firsts+=word
        else
          firsts+=word.chr
        end
      end
    end
    return firsts.upcase
  end

  def is_integer? (word)
    word.to_i.to_s == word
  end

  private

  def numberAndLetters?(acronym)
    number=0
    previousIsNumber=false
    for i in 0..acronym.length-1
      if letter?(acronym[i].chr)||is_integer?(acronym[i].chr)||acronym[i].chr=="-"
        if (!previousIsNumber)||(previousIsNumber&&is_integer?(acronym[i].chr))
          number+=1
        end
        if is_integer?(acronym[i].chr)
          previousIsNumber=true
        else
          previousIsNumber=false
        end
      end
    end
    return number==acronym.length
  end

  def letter?(lookAhead)
    lookAhead =~ /[[:alpha:]]/
  end

  def isRomanNumeral? (word)
    number=0
    position=0
    for position in 0..word.length - 1
      if (is_integer?(word[position].chr))||(word[position].chr=="X")||(word[position].chr=="V")||(word[position].chr=="I")||(word[position].chr=="-")
        number+=1
      end
    end
    return number==word.length
  end

end