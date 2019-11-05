require 'yaml'

module Problems
  class Client
    # module for yaml transformation
    module Yaml
      def transform(filename:, save_dir:)
        return render_error('File is not exist') unless File.file?(filename)
        return render_error('Save dir is not exist') unless File.exists?(save_dir)
        content = handle_file(filename)
        save_to_file(save_dir, content)
      rescue
        render_error('Content format error')
      end

      private

      def handle_file(file)
        File.readlines(file).inject({}) do |lines, line|
          transform_line(lines, line)
        end
      end

      def save_to_file(save_dir, content)
        File.open("#{save_dir}translation.yml", 'w') { |f| f.write(content.to_yaml(line_width: 500)) }
      end

      def render_error(message)
        { 'error' => message }
      end

      def transform_line(lines, line)
        splitted_line = line.split(':')
        keys = splitted_line[0][1..-2].split('.')
        value = splitted_line[1].strip
        check_for_existed_keys(lines, keys, value)
      end

      def check_for_existed_keys(lines, keys, value)
        key = keys.shift
        if lines.key?(key)
          lines[key] = check_for_existed_keys(lines[key], keys, value)
        else
          lines.merge!(check_left_keys(keys, key, value))
        end
        lines
      end

      def generate_hash(keys, value)
        key = keys.shift
        check_left_keys(keys, key, value)
      end

      def check_left_keys(keys, key, value)
        { key => keys.size.positive? ? generate_hash(keys, value) : value }
      end
    end
  end
end
