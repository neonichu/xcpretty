module XCPretty
  class Makefile

    include XCPretty::FormatMethods
    FILE_PATH = 'Makefile'

    def initialize(options)
      @file_path = options[:path] || FILE_PATH
      @parser = Parser.new(self)
      @commands = ''
      @pch_path = nil
      @current_file = nil
      @current_path = nil
    end

    def handle(line)
      @parser.parse(line)
    end

    def format_process_pch_command(file_path)
      @pch_path = file_path
    end

    def format_compile(file_name, file_path)
      @current_file = file_name
      @current_path = file_path
    end

    def format_compile_command(compiler_command, file_path)
      command = compiler_command.gsub(/(\-include)\s.*\.pch/, "\\1 #{@pch_path}")
      @commands << "\t#{command}\n"
    end

    def finish
      write_report
    end

    private

    def write_report
      File.open(@file_path, 'w') do |f|
        f.write(".PHONY: all\n\nall:\n")
        f.write(@commands)
      end
    end
  end
end
