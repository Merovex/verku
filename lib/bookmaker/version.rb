module Bookmaker
  module Version
    MAJOR = 0
    MINOR = 7
    PATCH = 1
    BUILD = 'pre1'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end