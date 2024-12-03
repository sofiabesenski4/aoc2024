require "bundler/setup"
Bundler.require(:default)

require "rspec/autorun" unless ENV["SKIP_TESTS"] || ENV["PART"]

def load_input(current_filename)
  File.read [__dir__, "/", File.basename(current_filename, ".rb"), ".txt"].join
end
