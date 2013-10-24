$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
code = File.read(File.expand_path("../Readme.md", __FILE__))[/<!-- example -->(.*)<!-- example -->/m, 1]
code.gsub!(/```.*/, "")
eval code
