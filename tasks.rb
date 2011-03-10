$VERBOSE = nil

Dir["#{Gem.searcher.find('carter').full_gem_path}/**/tasks/*.rake"].each { |ext| load  ext }