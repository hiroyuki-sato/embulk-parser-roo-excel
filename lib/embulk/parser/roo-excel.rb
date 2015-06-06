require 'roo'
module Embulk
  module Parser

    class RooExcelParserPlugin < ParserPlugin
      Plugin.register_parser("roo-excel", self)

      def self.transaction(config, &control)
        # configuration code:
        task = {
          "columns"   => config.param("columns", :array),
          "sheet"     => config.param("sheet",   :string, default: nil),
          "skip_header_lines" => config.param("skip_header_lines",:integer, default:0),
        }

        if( task['skip_header_lines'] < 0 )
          raise ArgumentError, "skip_header_line does not allow negative number"
        end

        columns = []
        task['columns'].each_with_index do |c,i|
          columns << Column.new(i, c['name'], c['type'].to_sym)
        end

        yield(task, columns)
      end

      def init
        # initialization code:
        @sheet   = task["sheet"]
        @columns = task["columns"]
        @data_pos  = task["skip_header_lines"] + 1
      end

      def run(file_input)
        while file = file_input.next_file

          begin
            xlsx = Roo::Excelx.new(StringIO.new(file.read))
            if( @sheet )
              xlsx.default_sheet = @sheet
            else
              xlsx.default_sheet = xlsx.sheets.first
            end
            last_row = xlsx.last_row
            if ( last_row.nil? or  last_row - @data_pos <= 0 )
              puts "No data. skip this file"
              next
            end

            ncol = @columns.size
            @data_pos.upto(last_row) do |row|
              data = []
              1.upto(ncol) do |col|
                column = @columns[col-1]
                data << convert_cell(column,xlsx,row,col)
              end
              @page_builder.add(data)
            end
          rescue ArgumentError
            puts $!
            puts $!.backtrace
            puts "Can't open data file"
          rescue
            raise
          end
        end
        page_builder.finish
      end

      # MEMO roo celltype
      # returns the type of a cell: * :float * :string, * :date * :percentage * :formula * :time * :datetime.
      #
      def convert_cell(column,xlsx,nrow,ncol)
        d = xlsx.cell(nrow,ncol)
        type = column['type'] || 'string'
        case type
        when 'long'
          d.to_i
        when 'double'
          d.to_f
        when 'string'
          d.to_s
        when 'timestamp'
          convert_time(d)
        else # TODO
          d.to_s
        end
      end

      def convert_time(t)
        if( t.kind_of?(Date) or t.kind_of?(DateTime) )
          t.to_time
        elsif( t.kind_of?(Time) )
          t
        elsif( t.kind_of?(String) )
          Time.parse(t)
        else
          raise ArgumentError,"Can't convert time:#{t}"
        end
      end

    end
  end
end
