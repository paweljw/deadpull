# frozen_string_literal: true

def pwd
  Pathname.new(Dir.pwd)
end

def fake_file(path, contents)
  location = File.expand_path(path)
  FileUtils.mkdir_p(File.dirname(location))
  File.write(location, contents)
end
