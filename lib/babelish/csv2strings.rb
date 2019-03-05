module Babelish
  class CSV2Strings < Csv2Base
    attr_accessor :languages

    def language_filepaths(language)
      require 'pathname'
      filepaths = []
      if language.regions.empty?
        filepaths << Pathname.new(@output_dir) + "#{language.code}.lproj/#{output_basename}.#{extension}"
      else
        language.regions.each do |region|
          filepaths << Pathname.new(@output_dir) + "#{language.code}-#{region}.lproj/#{output_basename}.#{extension}"
        end
      end
      filepaths
    end

    def get_row_format(row_key, row_value, comment = nil, indentation = 0)
      if row_value.empty?
        ""
      else
        entry = comment.to_s.empty? ? "" : "\n/* #{comment} */\n"
        curr_value = row_value.gsub('%s', '%@').gsub('$s', '$@')
        curr_value = curr_value.gsub('&amp;', '&').gsub('&#8230;', '...')
        entry + "\"#{row_key}\"" + " " * indentation + " = \"#{curr_value}\";\n"
      end
    end

    def extension
      "strings"
    end

    def output_basename
      @output_basename || 'Localizable'
    end
  end
end
