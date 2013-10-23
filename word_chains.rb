require 'set'

class WordChains
  attr_accessor :base_dict, :dictionary

  def initialize(dict_file)
    self.base_dict = File.readlines(dict_file).map(&:chomp).to_set
  end

  def cull_dict(length)
    @dictionary = base_dict.select!{ |w| w if w.length == length }
  end

  def find_chain(start_word, end_word)
    start_time = Time.now

    puts "Loading dictionary..."

    cull_dict(start_word.length)

    current_words = [start_word]

    found = false
    trail = Hash.try_convert(start_word => nil)

    found_same = false

    puts "Building chain..."

    until found
      new_words = []

      current_words.each do |current|
        adjacent = adjacent_words(current)

        adjacent.each do |adj|
          next if found_same && no_common_letters?(adj, end_word)

          new_words << adj unless new_words.include?(adj)
          trail[adj] = current unless trail.has_key?(adj)
        end
      end

      if new_words.include?(end_word)
        found = true
      end

      current_words = new_words

      if current_words.any? { |word| !no_common_letters?(word, end_word)}
        found_same = true
      end
    end

    build_chain(trail, end_word).each { |word| puts word }
    end_time = Time.now
    puts "Took #{end_time - start_time} seconds."
  end

  def build_chain(hash, target)
    chain = [target]
    current = target
    until hash[current] == nil
      chain << hash[current]
      current = hash[current]
    end
    chain.reverse
  end

  def no_common_letters?(str, target)
    array = []
    base = "." * str.length
    target.split('').each_with_index do |letter, i|
      temp = base.dup
      temp[i] = letter
      array << temp
    end

    regex = array.join("|")
    (str =~ /#{regex}/).nil?
  end


  def adjacent_words(word)
    possible = [].to_set
    word.split('').each_index do |i|
      regex = word.dup
      regex[i] = "."
      matches = self.dictionary.grep(/^#{regex}$/).to_set
      matches.delete(word)
      possible = possible + matches
    end

    possible.to_a
  end

end

if $0 == __FILE__
  dictionary = 'dictionary.txt'
  if ARGV[0] == "-d"
    ARGV.shift
    dictionary = ARGV.shift
  end
  word1, word2 = ARGV[0].strip.downcase, ARGV[1].strip.downcase

  word_chains = WordChains.new(dictionary)

  word_chains.find_chain(word1, word2)
end