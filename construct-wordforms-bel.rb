#!/usr/bin/env ruby

require 'rexml/document'
require 'find'
include REXML

VERBOSE = false

def parse_xml_file(fname, result)
  file = File.new(fname)
  doc = Document.new(file)

  doc.elements['Wordlist'].each do |paradigm|
    next unless paradigm.to_s =~ /^\<Paradigm/
    abort "error 1" unless paradigm.attributes.has_key?('lemma')
    paradigm.each do |variant|
      next unless variant.to_s =~ /^\<Variant/
      lemma = variant.attributes['lemma'].to_s.gsub("+", "\xCC\x81") # U+301 for stress
      lemma.gsub!(/\'/, "\xCA\xBC") # U+02BC https://en.wikipedia.org/wiki/Apostrophe#Unicode
      if lemma =~ /\s/
        STDERR.printf("== skipping variant due to undesirable whitespaces: ==\n") if VERBOSE
        STDERR.puts variant.to_s if VERBOSE
        next
      end
      result[lemma] = {} unless result.has_key?(lemma)
      variant.each do |form|
        next unless form.to_s =~ /^\<Form/
        word = form[0].to_s.gsub("+", "\xCC\x81") # U+301 for stress
        word.gsub!(/\'/, "\xCA\xBC") # U+02BC https://en.wikipedia.org/wiki/Apostrophe#Unicode
        if word == "" || word =~ /\s/
          STDERR.printf("== skipping bad form: ==\n") if VERBOSE
          STDERR.puts variant.to_s if VERBOSE
          next
        end
        result[lemma][word] = true
      end
    end
  end
  return result
end

xml_list = "A1.xml  A2.xml  C.xml  E.xml  F.xml  I.xml  K.xml  M.xml  N1.xml  N2.xml  N3.xml  NP.xml  P.xml  R.xml  S.xml  V.xml  W.xml  Y.xml Z.xml"

unless File.exists?("GrammarDB")
  STDERR.print("Please 'git clone https://github.com/Belarus/GrammarDB.git'\n")
  exit 1
end

result = {}
xml_list.split.each do |fname|
  STDERR.printf("Processing: %s\n", fname)
  parse_xml_file("GrammarDB/" + fname, result)
end

result.to_a.sort {|x, y| x[0] <=> y[0] }.each {|x| printf("%s %s\n", x[0], x[1].keys.sort.select {|y| y != x[0] }.join(" ")) }
